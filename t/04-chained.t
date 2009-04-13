#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 17;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

# make sure testapp works
BEGIN {
    use_ok('TestChained');
}

# a live test against TestCanVisit, the test application
use Test::WWW::Mechanize::Catalyst 'TestChained';
my $mech = Test::WWW::Mechanize::Catalyst->new;
my ($uid, $pwd);

$mech->get_ok('http://localhost/', 'main page');
$mech->content_like(qr/action: index/i, 'visit index page');

# user credentials are defined in TestCanVisit.pm

# log in: administrator
$uid = 'administrator';
$pwd = 's3cr3t';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok("http://localhost/stage1");
$mech->content_is('Ok');
$mech->get("http://localhost/stage2");
ok($mech->status eq '403', "$uid: got 403 Forbidden as expected");
# log out: administrator
$mech->get_ok('http://localhost/logout', "$uid: logout");

# log in: phb
$uid = 'phb';
$pwd = 's3cr3t';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok("http://localhost/stage1");
$mech->content_is('Ok');
$mech->get("http://localhost/stage2");
$mech->content_is('Ok');
# log out: phb
$mech->get_ok('http://localhost/logout', "$uid: logout");

# user with no roles
# log in: evilhax0r
$uid = 'evilhax0r';
$pwd = 'ev11';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
#$mech->get_ok("http://localhost/", "$uid: get index pg");
#$mech->get('http://localhost/killit');
#ok($mech->status == 403, "$uid got 403 Forbidden for restricted page, as expected");
#$mech->content_like(qr(access denied), qq($uid: content is "access denied"));

