#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Fcntl qw(:flock);
use List::MoreUtils;
use Encode qw(decode);

use perlModules::util;
use perlModules::sanityChecks;
use perlModules::sessions;

use constant { 
	# insieme K di costanti usate per indicizzare l'array degli errori riscontrati
	USERNAME	=> 'username', 
	PASSWORD	=> 'password',
	PASSWORD_C	=> 'confermaPassword',
	NAME 		=> 'nome',
	SURNAME		=> 'cognome',
	EMAIL		=> 'email',
	TEL	    	=> 'tel',
	BIRTHDATE	=> 'dataNascita',
	GENDER		=> 'sesso',
	HEIGHT		=> 'altezza',
	WEIGHT		=> 'peso',
	PHOTO       => 'foto'
};
use constant ERROR => 'Impossibile completare la registrazione. Riprovare più tardi.';

my $page 		=	new CGI;

# ottenimento dei parametri
my $username 	= 	&insert_html_entities($page->param(USERNAME));
my $password 	= 	&insert_html_entities($page->param(PASSWORD));
my $password_c	= 	&insert_html_entities($page->param(PASSWORD_C));
my $email 		= 	$page->param(EMAIL);
my $tel 		= 	&remove_separators($page->param(TEL));
my $name 		= 	$page->param(NAME);
my $surname 	= 	$page->param(SURNAME);
my $birthdate 	= 	$page->param(BIRTHDATE);
my $gender 		=	$page->param(GENDER);
my $height 		= 	$page->param(HEIGHT);
my $weight 		= 	$page->param(WEIGHT);
my $photo       =   $page->param(PHOTO);

# hash per gli errori
my %valids;
$valids{+USERNAME}					= 	$username ne "";
$valids{+PASSWORD}					=	defined($page->param('mod')) || $password ne "";
$valids{+PASSWORD_C}				=	defined($page->param('mod')) || ($password eq $password_c);
$valids{+NAME} 						= 	&allow_text_only($name);					# nel nome e nel cognome non ci devono essere caratteri speciali
$valids{+SURNAME}			 		=	&allow_text_only($surname);
$valids{+EMAIL}						=	&check_email($email); 						# validità dell'indirizzo email
$valids{+TEL}						=	(!$tel || &check_telephone_number($tel)); 	# numero di telefono non definito o valido
($valids{+BIRTHDATE}, $birthdate)	=	&is_valid_date($birthdate);		 			# validità della data di nascita
$valids{+GENDER}					=	&is_gender($gender); 						# validità del sesso
$valids{+HEIGHT}					=	(!$height || &is_fixed_point($height)); 	# altezza non definita o intera
$valids{+WEIGHT}					=	(!$weight || &is_fixed_point($weight)); 	# peso non definito o intero
$valids{+PHOTO}                     =   (($photo eq "") || &is_image($photo));      # la foto è vuota (default) o ha estensione png o jpg

# Data una chiave k di %valids, $valids[k] è true sse la condizione sul campo k del form è verificata. Se $valids[k]==false allora il
# valore inserito in quel campo del form non è valido, e deve essere mostrato un errore. Se $valids[k]==true per ogni k app K 
# allora tutti i dati inseriti sono validi. Altrimenti, se esiste k app K tc $valids[k]==false, l'utente non può essere inserito nel 
# file xml perché c'è almeno un dato inserito non valido.

# variabili per la gestione dell'albero xml
my $parser			=	XML::LibXML->new() 							or  &show_error(ERROR);
my $doc				=	$parser->parse_file(USERS_PATH) 			or 	&show_error(ERROR);
open(OUT, '>'.USERS_PATH) 											or 	&show_error(ERROR);
flock(OUT, LOCK_EX) 												or 	&show_error(ERROR); # lock sul file prima del parsing
my $root			=	$doc->getDocumentElement 					or  &show_error(ERROR);
$valids{+USERNAME}	=	defined($page->param('mod')) ||
						(!$root->exists("/utenti/utente[username = '$username']") && $valids{+USERNAME}); # lo username deve essere unico

my $errorFound = List::MoreUtils::first_index {$_ == 0} values %valids; # false => c'è stato un errore
if($errorFound == -1) { # tutti i dati validi
	if (defined($page->param('mod'))) {
		my $user    = $doc->findnodes("//utente[username = '".&get_session_param(USER)."']")->get_node(1);
		my $users   = $user->parentNode;
		$users->removeChild($user);
		&destroy_session;
		if ($password eq "") {
			$password = $user->findvalue("password");
		}
	}
	my $newNode		=	"\t<utente>\n".
							"\t\t<username>$username</username>\n".
							"\t\t<password>$password</password>\n".
							"\t\t<email>$email</email>\n";
	if ($tel ne "") {
		$newNode	.=      "\t\t<tel>$tel</tel>\n";
	}
	$newNode		.=		"\t\t<nome>$name</nome>\n".
							"\t\t<cognome>$surname</cognome>\n".
							"\t\t<dataNascita>$birthdate</dataNascita>\n".
							"\t\t<sesso>$gender</sesso>\n";
	if ($height ne "") {
		$newNode 	.= 		"\t\t<altezza>$height</altezza>\n";
	}
	if ($weight ne "") {
		$newNode 	.=		"\t\t<peso>$weight</peso>\n";
	}
	$newNode		.=		"\t</utente>\n";
	my $node		=	$parser->parse_balanced_chunk($newNode) or &show_error(ERROR);
	$root->appendChild($node) 									or &show_error(ERROR);
}
print OUT $doc->toString;
flock(OUT, LOCK_UN); # tolgo il lock dal file
close(OUT);
if ($errorFound != -1) {
	my %errors	=	();
	$errors{+USERNAME}		= 'Username non disponibile o vuoto.';
	$errors{+PASSWORD}		= 'La password non può essere vuota.';
	$errors{+PASSWORD_C}	= 'Le due passoword non coincidono.';
	$errors{+NAME}			= 'Il nome contiene caratteri non alfabetici.';
	$errors{+SURNAME}		= 'Il cognome contiene caratteri non alfabetici.';
	$errors{+EMAIL}			= 'Indirizzo email non valido.';
	$errors{+TEL}			= 'Il numero di telefono non è valido rispetto alle normative italiane.';
	$errors{+BIRTHDATE}		= 'La data di nascita è espressa in un formato non accettato o non è valida.';
	$errors{+GENDER}		= 'Il sesso può essere solo M o F.';
	$errors{+HEIGHT}		= 'L\'altezza contiene caratteri non numerici.';
	$errors{+WEIGHT}		= 'Il peso contiene caratteri non numerici.';
	$errors{+PHOTO}         = 'Il file selezionato non ha estensione \'jpg\' o \'png\'.';

	open(SIGNUP, '<../public_html/registrazione.html')	or &show_error(ERROR);
	my @lines = <SIGNUP>;
	close(SIGNUP);
	my $paramValue;
	foreach my $inp (keys %valids) {
		$index 		= List::MoreUtils::first_index {$_ =~ /id="$inp"/} @lines;
		if (!$valids{$inp}) { # mostro il messaggio di errore
			$lines[$index] .= "<span class='formError'>".$errors{$inp}."</span>";
		}
		if ($inp ne +PASSWORD && $inp ne +PASSWORD_C) {
			if ($inp eq +MALE || $inp eq +FEMALE) {
				if ($gender eq 'F') {
					$lines[$index-2]	=~ s/checked="checked"//;
					$lines[$index]		=~ s/value="F"/value="F" checked="checked"/;
				}
			}
			else {
				$paramValue	= $page->param($inp);
				if ($inp eq dataNascita) {
					$paramValue =~ /^(19\d\d|20\d\d)-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/;
					(my $d, my $m, my $y) = ($3, $2, $1);
					$html =~ s/id="$inp"/id="$inp" value="$d\/$m\/$y"/;
				}
				else {
					$lines[$index]	=~ s/id="$inp"/id="$inp" value="$paramValue"/;
				}
			}
		}
	}
	if (defined($page->param('mod'))) {
		my $hidden 	= $page->param('mod');
		$index 		= List::MoreUtils::first_index {$_ =~ /<\/form>/} @lines;
		$lines[$index] =~ s/<\/form>/\t<fieldset class="hidden"><input type="hidden" name="mod" value="$hidden" \/><\/fieldset>\n\t\t<\/form>/;
		$index 		= List::MoreUtils::first_index {$_ =~ /onblur="checkPasswordConfirm\(\)"/} @lines;
		$lines[$index] =~ s/onblur="checkPasswordConfirm\(\)"/ /;
		$index 		= List::MoreUtils::first_index {$_ =~ /onblur="checkPassword\(\)"/} @lines;
		$lines[$index] =~ s/onblur="checkPassword\(\)"/ /;
		$index 		= List::MoreUtils::first_index {$_ =~ /onclick="return validate\(0\);"/} @lines;
		$lines[$index] =~ s/onclick="return validate\(0\);"/onclick="return validate\(1\)"/g;
		$index 		= List::MoreUtils::first_index {$_ =~ /<title>Registrazione - Forza e Coraggio<\/title>"/} @lines;
		$html			=~ s/<title>Registrazione - Forza e Coraggio<\/title>/<title>Modifica profilo - Forza e Coraggio<\/title>/;
		$index 		= List::MoreUtils::first_index {$_ =~ /<h1>Registrazione<\/h1>"/} @lines;
		$html			=~ s/<h1>Registrazione<\/h1>/<h1>Modifica profilo<\/h1>/;
	}
	print "Content-type:text/html\n\n";
	print correct_paths(join('', @lines));
}
else {
	if ($photo eq "") {
		$photo      =   ($gender eq 'M') ? 'uomo.png' : 'donna.png';
	}
	else {
		# cancello la vecchia immagine
		unlink IMAGES_PATH.$username.'.png';
		unlink IMAGES_PATH.$username.'.jpg';
		# carico la nuova immagine

		my $filename = $username.substr($photo, -4);
		open(IMG, ">>".IMAGES_PATH."$filename") or &show_error(ERROR);
		while(<$photo>) {
			print IMG;
		}
		close(IMG);
	}
	(my $session, my $cookie)=&create_session($page, $username);
	print $page->redirect(-uri => BASIC_URI.'cgi-bin/profilo.cgi', -cookie => $cookie);
}
