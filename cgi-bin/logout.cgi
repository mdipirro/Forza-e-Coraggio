#!/usr/bin/perl -w
use CGI;
use CGI::Carp qw(fatalsToBrowser);

use perlModules::util;
use perlModules::sessions;

&destroy_session();
my $page = new CGI;
print $page->redirect(BASIC_URI.'index.html');