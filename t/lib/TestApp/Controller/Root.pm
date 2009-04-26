package TestApp::Controller::Root;

use strict;
use warnings;

use Catalyst;
use base 'Catalyst::Controller';

__PACKAGE__->config(namespace => q{});

sub index :Path Args(0) {
    my ($self, $c) = @_;
    $c->res->body('action: index');
}

sub edit
:Local
:ActionClass(Role::ACL)
:RequiresRole(editor)
:ACLDetachTo(denied)
{
    my ($self, $c) = @_;
    $c->res->body("action: edit");
}

sub killit
:Local
:ActionClass(Role::ACL)
:RequiresRole(killer)
:ACLDetachTo(denied)
{
    my ($self, $c) = @_;
    $c->res->body("action: killit");
}

sub crews
:Local
:ActionClass(Role::ACL)
:RequiresRole(editor)
:RequiresRole(banana)
:ACLDetachTo(denied)
{
    my ($self, $c) = @_;
    $c->res->body("action: crews");
}

sub reese
:Local
:ActionClass(Role::ACL)
:AllowedRole(sarah)
:AllowedRole(shahi)
:ACLDetachTo(denied)
{
    my ($self, $c) = @_;
    $c->res->body("action: reese");
}

sub wolverines
:Local
:ActionClass(Role::ACL)
:RequiresRole('swayze')
:AllowedRole('actor')
:AllowedRole('guerilla')
:ACLDetachTo(denied)
{
    my ($self, $c) = @_;
    $c->res->body("action: wolverines");
}

sub denied :Private {
    my ($self, $c) = @_;

    $c->res->status(403);
    $c->res->body('access denied');
}


1;

