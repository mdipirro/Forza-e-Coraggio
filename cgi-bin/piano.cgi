#!/usr/bin/perl -w
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

use perlModules::util;
use perlModules::sessions;

use constant ERROR => 'Impossibile visualizzare i dettagli del piano. Riprovare più tardi.';

my $page = new CGI;
if (!check_login()) {
    print $page->redirect(BASIC_URI.'login.html');
}
my $parser 	= XML::LibXML->new();
my $doc     = $parser->parse_file(PLANS_PATH)   or &show_error(ERROR);
my $root    = $doc->getDocumentElement          or &show_error(ERROR);
if ($root->exists("/piani/piano [\@id = '".$page->param("id")."']") &&
    $root->findvalue("/piani/piano [\@id = '".$page->param("id")."']/utente") eq &get_session_param(USER)) {
    my $html = &apply_xsl_stylesheet(PLANS_PATH, PLAN_DETAILS_PATH, ERROR, 'planID', $page->param('id'));
    print "Content-type:text/html\n\n";
    print $html;
} else {
    &show_error('Il piano cercato non esiste o non hai il permesso di visualizzarlo.',
                'Se hai digitato un indirizzo nella barra degli indirizzi, riprova: potresti aver sbagliato.');
}
