#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

use perlModules::util;
use perlModules::sessions;

use constant ERROR => 'Impossibile cancellare il piano ora. Riprovare più tardi.';

my $page    = new CGI;
my $parser 	= XML::LibXML->new();
my $doc     = $parser->parse_file(PLANS_PATH)   or &show_error(ERROR);
open(OUT, ">".PLANS_PATH)                       or &show_error(ERROR); # apro il file dei piani
flock(OUT, 2)                                   or &show_error(ERROR); # lock sul file prima del parsing
if ($doc->exists("//piano[\@id = '".$page->param('id')."']")) {
    my $plan    = $doc->findnodes("//piano[\@id = '".$page->param('id')."']")->get_node(1);
    my $plans   = $plan->parentNode;
    $plans->removeChild($plan);
}

print OUT $doc->toString; # serializzazione e scrittura
close(OUT); # chiusura del file
flock(OUT, LOCK_UN); # tolgo il lock dal file
print $page->redirect(-uri => BASIC_URI."cgi-bin/profilo.cgi");
