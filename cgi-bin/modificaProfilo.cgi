#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

use perlModules::util;
use perlModules::sessions;
use perlModules::sanityChecks;

use constant ERROR => 'Impossibile modificare il profilo ora. Riprovare più tardi.';

my $page = new CGI;
if (!check_login()) {
	print $page->redirect(BASIC_URI.'login.html');
}
my $username        = &get_session_param(USER);
open(SIGNUP, '<../public_html/registrazione.html')	or &show_error(ERROR);
my $html = join('', <SIGNUP>);
close(SIGNUP);
my $parser 	        = XML::LibXML->new();
my $doc             = $parser->parse_file(USERS_PATH)   or &show_error(ERROR);
my $root            = $doc->getDocumentElement          or &show_error(ERROR);
if ($root->exists("/utenti/utente [username = '$username']")) {
	my $user        = $root->findnodes("/utenti/utente [username = '$username']")->get_node(1);
	foreach my $infoNode ($user->childNodes()) {
		my $info    = $infoNode->nodeName;
		my $infoVal = $infoNode->textContent;
		if ($info eq 'sesso' && $infoVal eq 'F') {
			$html	=~ s/checked="checked"//;
			$html	=~ s/value="F"/value="F" checked="checked"/;
		}
		elsif ($info ne 'password') {
			if ($info eq dataNascita) {
				$infoVal =~ /^(19\d\d|20\d\d)-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/;
				(my $d, my $m, my $y) = ($3, $2, $1);
				$html =~ s/id="$info"/id="$info" value="$d\/$m\/$y"/;
			}
			else {
				$html   =~ s/id="$info"/id="$info" value="$infoVal"/;
			}
		}
	}
	$html			=~ s/<title>Registrazione - Forza e Coraggio<\/title>/<title>Modifica profilo - Forza e Coraggio<\/title>/;
	$html			=~ s/<h1>Registrazione<\/h1>/<h1>Modifica profilo<\/h1>/;
	$html           =~ s/<\/form>/\t<fieldset class="hidden"><input type="hidden" name="mod" value="$username" \/><\/fieldset>\n\t\t<\/form>/;
	$html 			=~ s/onblur="checkPasswordConfirm\(\)"//g;
	$html			=~ s/onblur="checkPassword\(\)"//g;
	$html 			=~ s/onclick="return validate\(0\);"/onclick="return validate\(1\);"/g;
	print "Content-type:text/html\n\n";
	print &correct_paths($html);
} else {
	&show_error(ERROR);
}