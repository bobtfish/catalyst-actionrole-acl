#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 33;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

# make sure testapp works
BEGIN {
    use_ok('TestApp');
}

# a live test against TestApp, the test application
use Test::WWW::Mechanize::Catalyst 'TestApp';
my $mech = Test::WWW::Mechanize::Catalyst->new;
my ($uid, $pwd);

$mech->get_ok('http://localhost/', 'main page');
$mech->content_like(qr/action: index/i, 'visit index page');

# user credentials are defined in TestApp.pm

# log in: drwho
$uid = 'drwho';
$pwd = 'vashtanerada';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
# log out: drwho
$mech->get_ok('http://localhost/logout', "$uid: logout");

# user with no roles
# log in: evilhax0r
$uid = 'evilhax0r';
$pwd = 'ev11';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok("http://localhost/", "$uid: get index pg");
$mech->get('http://localhost/killit');
ok($mech->status == 403, "$uid got 403 Forbidden for restricted page, as expected");
$mech->content_like(qr(access denied), qq($uid: content is "access denied"));

# log in: foo
$uid = 'foo';
$pwd = 's3cr3t';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
# user has required role so should get 200 OK
$mech->get_ok('http://localhost/edit', qq($uid: action requiring "editor" role));
$mech->content_like(qr/action: edit/i, "$uid: fetch content Ok");
# user lacks required role "killer" so should get 403 Forbidden
$mech->get('http://localhost/killit');
ok($mech->status == 403, "$uid: got 403 Forbidden, as expected");
$mech->content_like(qr(access denied), qq($uid: content is "access denied"));

# user has only one of two required roles so should get 403 Forbidden
$mech->get('http://localhost/crews');
ok($mech->status == 403, "$uid: got 403 Forbidden, as expected");
$mech->content_like(qr(access denied), qq($uid: content is "access denied"));

# similar user with the additional role required for access
# log in: foo2
$uid = 'foo2';
$pwd = 's3cr3t';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok('http://localhost/crews', qq($uid: action requiring "editor" and "banana" roles));
$mech->content_like(qr/action: crews/i, qq($uid: fetch content Ok));
# log out: foo2
$mech->get_ok('http://localhost/logout', "$uid: logout");
# attempt to access the same page, should get 403
$mech->get('http://localhost/crews');
ok($mech->status == 403, "$uid: got 403 Forbidden after logging out, as expected")
    or diag("unexpected status: " . $mech->status);

# log in: william
$uid = 'william';
$pwd = 's3cr3t';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok('http://localhost/reese', qq($uid: action allowing access to "sarah" and "shahi" roles));
$mech->content_like(qr/action: reese/i, qq($uid: fetch content Ok));

# log in: william2
$uid = 'william2';
$pwd = 's3cr3t';
$mech->get_ok("http://localhost/login?user=${uid}&password=${pwd}", 'login page');
$mech->content_like(qr/logged in: $uid/i, "login user: $uid");
$mech->get_ok('http://localhost/reese', qq($uid: action allowing access to "sarah" and "shahi" roles));
$mech->content_like(qr/action: reese/i, qq($uid: fetch content Ok));

