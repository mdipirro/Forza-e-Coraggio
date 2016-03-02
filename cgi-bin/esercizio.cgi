#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);

use perlModules::util;
use perlModules::sessions;
use perlModules::sanityChecks;

use constant ERROR => 'Impossibile visualizzare i dettagli dell\'esercizio. Riprovare più tardi.';

my $page 	= new CGI;
my $param 	= $page->param('es');
my $exHTML 	= &apply_xsl_stylesheet(EXERCISES_PATH, EXERCISE_PATH, 	ERROR, 'exerciseName', $param);
my $commHTML	= "<a href='../login.html'>Accedi</a> o <a href='../registrazione.html'>Registrati</a> per commentare l'esercizio!";
if (check_login()) { # se l'utente ha effettuato il login mostro i commenti associati all'esercizio
	$commHTML = &apply_xsl_stylesheet(COMMENTS_PATH, COMMENT_PATH, ERROR, 'exerciseName', $param);
	$commHTML = &remove_html_entities($commHTML);
}
my $placeholder	= "<div id=\"commenti\">";
$exHTML		=~ s/$placeholder/$placeholder$commHTML/;
print "Content-type:text/html\n\n";
print $exHTML;
