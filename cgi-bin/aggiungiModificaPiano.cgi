#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use List::MoreUtils;

use perlModules::util;
use perlModules::sessions;
use perlModules::sanityChecks;

use constant {
    ERROR           => 'Impossibile creare il piano ora. Riprovare più tardi.',
    USER_MESSAGE    => 'Questo campo deve contenere valori numerici.',
    RIP             => 'rip',
    SERIES          => 'ser',
    REC             => 'rec',
    ES              => 'Ad esaurimento',
    QB              => 'Quanto basta'
};

my $page = new CGI;
my @mod  = (0, 0);
@mod     = split('=', $ENV{'QUERY_STRING'});
if (!check_login()) {
    print $page->redirect(BASIC_URI.'login.html');
}
my @exercises   = $page->param('includi');
my $parser 	    = XML::LibXML->new();
my $name        = &insert_html_entities($page->param('nome'));
my @data        = ();
my %errors      = ();

foreach my $exercise (@exercises) {
    my $rip = $page->param(RIP.$exercise);
    my $ser = $page->param(SERIES.$exercise);
    my $rec = $page->param(REC.$exercise);

    $errors{RIP.$exercise}      = (&is_fixed_point($rip) || $rip eq '' || $rip eq ES);
    $errors{SERIES.$exercise}   = (&is_fixed_point($ser) || $ser eq '' || $ser eq ES);
    $errors{REC.$exercise}      = (&is_fixed_point($rec) || $rec eq '' || $rec eq QB);
}
my $errorsFound = List::MoreUtils::first_index {$_ == 0} values %errors;
if ($errorsFound >= 0) { #ci sono stati errori
    my $html    = &apply_xsl_stylesheet(EXERCISES_PATH, CREATE_PLAN_PATH, ERROR, 'mod', $mod[1]);
    $html       =~ s/id="nome"/id="nome" value="$name"/;
    my $msg     = "<span class=formError>".USER_MESSAGE."</span>";
    my $paramValue;
    #individuo i gruppi muscolari errati
    my @errorGroups;
    my $exParser = XML::LibXML->new();
    my $exDoc    = $exParser->parse_file(EXERCISES_PATH)    or show_error(ERROR);
    my $exRoot   = $exDoc->getDocumentElement               or show_error(ERROR);
    foreach $exercise (@exercises) {
        $html   =~ s/id="includi$exercise"/id="includi$exercise" checked="checked"/;
    }
    foreach my $inp (keys %errors) {
        if(!$errors{$inp}) {
            $html =~ s/id="$inp" \/>/id="$inp" \/>$msg/;
	    my $exID = substr($inp, 3);
    print "Content-type:text/html\n\n";
	    my $group = $exRoot->findvalue("/gruppiMuscolari/gruppoMuscolare[esercizio/\@id = '$exID']/nomeGruppo");
print "GRUPPO$group $inp $exID";
            if (List::MoreUtils::first_index {$_ =~ /$group/} @errorGroups < 0) {
		push(@errorGroups, $group);
	    }
        }
        if (defined($page->param($inp))) {
            $paramValue = $page->param($inp);
            $html =~ s/id="$inp"/value="$paramValue" id="$inp"/;
        }
    }
	my $numErrors = @errorGroups;
	my $errStr = "";
	if ($numErrors > 0) {
		$errStr = "<span class=\"formError\">Sono presenti errori nei seguenti gruppi muscolari: ";
		foreach my $err (@errorGroups) {
			$errStr .= "<a href=\"#box$err\">$err</a> ";
		}	
		$errStr .= "</span>"
	}
	if ($mod[1] > 0) {
		$html			=~ s/<title>Creazione piano di allenamento - Forza e Coraggio<\/title>/<title>Modifica piano di allenamento - Forza e Coraggio<\/title>/;
		$html			=~ s/<h1>Crea un piano di allenamento personalizzato!<\/h1>/<h1>Modifica il tuo piano di allenamento<\/h1>$errStr/;
		$html			=~ s/value="Crea il piano"/value="Modifica il piano"/;
	}
	else {
		$html			=~ s/<h1>Crea un piano di allenamento personalizzato!<\/h1>/<h1>rea un piano di allenamento personalizzato!<\/h1>$errStr/;	
	}
    print "Content-type:text/html\n\n";
    print $html;
print @errorGroups;
} else {
    if ($name eq "") {
        $name       = "Piano Senza Nome";
    }
    foreach my $exercise (@exercises) {
        my $rip     = $page->param(RIP.$exercise)     eq "" ? ES : $page->param(RIP.$exercise);
        my $series  = $page->param(SERIES.$exercise)  eq "" ? ES : $page->param(SERIES.$exercise);
        my $rec     = $page->param(REC.$exercise)     eq "" ? QB : $page->param(REC.$exercise);
        push(@data, $rip);
        push(@data, $series);
        push(@data, $rec);
    }
    my $doc     = $parser->parse_file(PLANS_PATH)       or &show_error(ERROR);
    open(OUT, ">".PLANS_PATH)                           or &show_error(ERROR); # apro il file dei piani
    flock(OUT, 2)                                       or &show_error(ERROR); # lock sul file prima del parsing
    my $root    = $doc->getDocumentElement              or &show_error(ERROR);
    my $planID  = 1 + $root->findvalue("/piani/piano[not(preceding-sibling::piano/\@id >= \@id) and
                                        not(following-sibling::piano/\@id > \@id)]/\@id")
                                                        or &show_error(ERROR); #ricavo l'ID più alto
    if ($mod[1] > 0) {
        $planID = $mod[1];
    }
    my $newNode = "\t<piano id=\"$planID\">\n".
                    "\t\t<nome>$name</nome>\n".
                    "\t\t<utente>".&get_session_param(USER)."</utente>\n";
    # aggiungo la lista degli esercizi
    my $exParser = XML::LibXML->new();
    my $exDoc    = $exParser->parse_file(EXERCISES_PATH)    or show_error(ERROR);
    my $exRoot   = $exDoc->getDocumentElement               or show_error(ERROR);
    for (my $i = 0; $i < @data; $i += 3) {
        $newNode .= "\t\t<esercizio>\n".
                        "\t\t\t<nomeEsercizio>".$exRoot->findvalue("/gruppiMuscolari/gruppoMuscolare/esercizio[\@id = '".$exercises[$i/3]."']/nomeEsercizio")."</nomeEsercizio>\n".
                        "\t\t\t<IDEsercizio>".$exercises[$i/3]."</IDEsercizio>\n".
                        "\t\t\t<ripetizioni>$data[$i]</ripetizioni>\n".
                        "\t\t\t<serie>".$data[$i+1]."</serie>\n".
                        "\t\t\t<recupero>".$data[$i+2]."</recupero>\n".
                    "\t\t</esercizio>\n";
    }
    $newNode    .= "\t</piano>\n";
    my $node    = $parser->parse_balanced_chunk($newNode) or &show_error(ERROR);
    if ($mod[1] > 0) {
        my $plan    = $doc->findnodes("//piano[\@id = '$planID']")->get_node(1);
        my $plans   = $plan->parentNode;
        $plans->removeChild($plan);
    }
    $root->appendChild($node) or &show_error(ERROR);
    print OUT $doc->toString; # serializzazione e scrittura
    close(OUT); # chiusura del file
    flock(OUT, LOCK_UN); # tolgo il lock dal file
    print $page->redirect(-uri => BASIC_URI."cgi-bin/piano.cgi?id=$planID");
}
