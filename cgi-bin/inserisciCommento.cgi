#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;
use Encode;

use perlModules::util;
use perlModules::sessions;
use perlModules::sanityChecks;

use constant ERROR =>  'Impossibile aggiungere il commento. Riprovare più tardi.';

my $page	= new CGI;
if (!check_login()) {
	print $page->redirect(BASIC_URI.'login.html');
}
my $comment	= &insert_html_entities($page->param('commento'));
my $parser 	= XML::LibXML->new();
if ($comment ne "") {
	my $doc = $parser->parse_file(COMMENTS_PATH) or &show_error(ERROR);
    open(OUT, ">".COMMENTS_PATH) or &show_error(ERROR); # apro il file dei commenti
    flock(OUT, 2) or &show_error(ERROR); # lock sul file prima del parsing
    my $root = $doc->getDocumentElement or &show_error(ERROR);
    my $newNode =   "\t<commento>\n".
                        "\t\t<esercizio>".$page->param('esercizio')."</esercizio>\n".
                        "\t\t<utente>".get_session_param(USER)."</utente>\n".
                        "\t\t<testo>$comment</testo>\n".
                    "\t</commento>";
    my $node = $parser->parse_balanced_chunk($newNode) or &show_error(ERROR);
    $root->appendChild($node) or &show_error(ERROR);
    print OUT $doc->toString; # serializzazione e scrittura
    close(OUT); # chiusura del file
    flock(OUT, LOCK_UN); # tolgo il lock dal file
}
print $page->redirect(-uri => BASIC_URI.'cgi-bin/esercizio.cgi?es='.$page->param('esercizio'));