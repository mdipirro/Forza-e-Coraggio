#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

use perlModules::util;
use perlModules::sessions;
use perlModules::sanityChecks;

use constant ERROR => 'Impossibile modificare il piano ora. Riprovare più tardi.';

my $page = new CGI;
if (!check_login()) {
    print $page->redirect(BASIC_URI.'login.html');
}
my $html    = &apply_xsl_stylesheet(EXERCISES_PATH, CREATE_PLAN_PATH, ERROR, 'mod', $page->param('id'));
my $parser 	= XML::LibXML->new();
my $doc     = $parser->parse_file(PLANS_PATH)   or &show_error(ERROR);
my $root    = $doc->getDocumentElement          or &show_error(ERROR);
if ($root->exists("/piani/piano [\@id = '".$page->param("id")."']") &&
    $root->findvalue("/piani/piano [\@id = '".$page->param("id")."']/utente") eq &get_session_param(USER)) {
    my $plan        = $root->findnodes("/piani/piano [\@id = ".$page->param("id")."]")->get_node(1);
    my $planName    = $plan->findvalue("nome");
    $html           =~ s/id="nome"/id="nome" value="$planName"/; # imposto il nome del piano
    my $exercises   = $plan->findnodes("esercizio");
    my $exerciseID, my $replace;
    foreach my $exercise ($exercises->get_nodelist) {
        $exerciseID = $exercise->findvalue("IDEsercizio");
        $html       =~ s/id="includi$exerciseID"/id="includi$exerciseID" checked="checked"/;
        $replace    = $exercise->findvalue("ripetizioni");
        $html       =~ s/id="rip$exerciseID"/id="rip$exerciseID" value="$replace"/;
        $replace    = $exercise->findvalue("serie");
        $html       =~ s/id="serie$exerciseID"/id="serie$exerciseID" value="$replace"/;
        $replace    = $exercise->findvalue("recupero");
        $html       =~ s/id="rec$exerciseID"/id="rec$exerciseID" value="$replace"/;
    }
	$html			=~ s/<title>Creazione piano di allenamento - Forza e Coraggio<\/title>/<title>Modifica piano di allenamento - Forza e Coraggio<\/title>/;
	$html			=~ s/<h1>Crea un piano di allenamento personalizzato!<\/h1>/<h1>Modifica il tuo piano di allenamento<\/h1>/;
	$html			=~ s/value="Crea il piano"/value="Modifica il piano"/;
    print "Content-type:text/html\n\n";
    print $html;
} else {
    &show_error('Il piano cercato non esiste o non hai il permesso di modificarlo.',
                'Se hai digitato un indirizzo nella barra degli indirizzi, riprova: potresti aver sbagliato.')
}