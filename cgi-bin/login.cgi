#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;
use List::MoreUtils;

use perlModules::util;
use perlModules::sessions;

use constant ERROR => 'Impossibile accedere. Riprovare più tardi.';

# ottenimento dei parametri
my $page 		= 	new CGI;
if (check_login()) {
	print $page->redirect(BASIC_URI.'cgi-bin/profilo.cgi');
}
my $username 	= 	$page->param('username');
my $password	= 	$page->param('password');
my $parser 		= 	XML::LibXML->new();
my $doc 		= 	$parser->parse_file(USERS_PATH) or &show_error(ERROR);
my $root	 	= 	$doc->getDocumentElement 		or &show_error(ERROR);
if ($root->exists("/utenti/utente[username='$username' and password='$password']")) {
	(my $session, my $cookie)=&create_session($page, $username);
	print $page->redirect(-uri => BASIC_URI.'cgi-bin/profilo.cgi', -cookie => $cookie);
}
else{
	open(LOGIN, '<../public_html/login.html')	or &show_error(ERROR);
	my @lines 			= 	<LOGIN>;
	close(LOGIN);
	my $pattern			= "<legend>Dati Login</legend>";
	my $index			= List::MoreUtils::first_index {$_ =~ /$pattern/} @lines;
	$lines[$index]	.= "<span class=\"formError\">Username o Password errati.</span>";
	print "Content-type:text/html\n\n";
	print correct_paths(join('', @lines));
}
