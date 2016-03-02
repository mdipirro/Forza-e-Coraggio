#!/usr/bin/perl -w
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use utf8;

use perlModules::util;
use perlModules::sessions;

use constant ERROR => 'Impossibile visualizzare il profilo. Riprovare più tardi.';

my $page = new CGI;
if (!check_login()) {
	print $page->redirect(BASIC_URI.'login.html');
}
my $username    = &get_session_param(USER);
my $html 	    = &apply_xsl_stylesheet(USERS_PATH, PROFILE_PATH, ERROR, 'username', $username);
my $plans	    = &apply_xsl_stylesheet(PLANS_PATH, GENERAL_PLAN_PATH, ERROR, 'username', $username);
my $ext         = "";
if (-e IMAGES_PATH.$username.'.png') {
	$ext        = '.png';
}
elsif (-e IMAGES_PATH.$username.'.jpg') {
	$ext        = '.jpg';
}
if ($ext ne "") {
	$html       =~ s/uomo.png|donna.png/$username$ext/;
}
my $placeholder	= "<div id=\"piani\">";
$html 		    =~ s/$placeholder/$placeholder$plans/;
print "Content-type:text/html\n\n";
print $html;
