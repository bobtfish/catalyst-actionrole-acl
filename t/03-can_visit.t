#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 30;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

# make sure testapp works
BEGIN {
    use_ok('TestCanVisit');
}

# a live test against TestCanVisit, the test application
use Test::WWW::Mechanize::Catalyst 'TestCanVisit';
my $mech = Test::WWW::Mechanize::Catalyst->new;
my ($uid, $pwd);

$mech->get_ok('http://localhost/', 'main page');
$mech->content_like(qr/action: index/i, 'visit index page');

# user credentials are defined in TestCanVisit.pm

# log in: drwho
$uid = 'drwho';
$pwd = 'vashta nerada';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok("http://localhost/access?action_name=unreachable");
$mech->content_is('no');
$mech->get_ok("http://localhost/access?action_name=thedoctor");
$mech->content_is('yes');
$mech->get_ok("http://localhost/access?action_name=readstuff");
$mech->content_is('no');
# log out: drwho
$mech->get_ok('http://localhost/logout', "$uid: logout");

# log in: evilhax0r
$uid = 'evilhax0r';
$pwd = 'ev11';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok("http://localhost/access?action_name=unreachable");
$mech->content_is('no');
$mech->get_ok("http://localhost/access?action_name=thedoctor");
$mech->content_is('no');
$mech->get_ok("http://localhost/access?action_name=readstuff");
$mech->content_is('no');
# log out: evilhax0r
$mech->get_ok('http://localhost/logout', "$uid: logout");

# log in: regularjoe
$uid = 'regularjoe';
$pwd = 'witty';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok("http://localhost/access?action_name=unreachable");
$mech->content_is('no');
$mech->get_ok("http://localhost/access?action_name=thedoctor");
$mech->content_is('no');
$mech->get_ok("http://localhost/access?action_name=readstuff");
$mech->content_is('yes');
# log out: regularjoe
$mech->get_ok('http://localhost/logout', "$uid: logout");

