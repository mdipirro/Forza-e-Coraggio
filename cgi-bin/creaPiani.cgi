#!/usr/bin/perl -w
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

use perlModules::util;
use perlModules::sessions;

use constant ERROR => 'Impossibile creare il piano ora. Riprovare più tardi.';

my $page = new CGI;
if (!check_login()) {
    print $page->redirect(BASIC_URI.'login.html');
}
my $html = &apply_xsl_stylesheet(EXERCISES_PATH, CREATE_PLAN_PATH, ERROR, 'mod', 0);
print "Content-type:text/html\n\n";
print $html;

