package Catalyst::Action::Role::ACL;

use 5.008_001;

use strict;
use warnings;
use base 'Catalyst::Action';
use MRO::Compat;
use mro 'c3';
Class::C3::initialize();

use vars qw($VERSION);
$VERSION = '0.03';

=head1 NAME

Catalyst::Action::Role::ACL - User role-based authorization action class.

=head1 SYNOPSIS

 sub foo :Local
 :ActionClass(Role::ACL)
 :RequiresRole(admin) {
     my ($self, $c) = @_;
     ...
 }

 # elsewhere
 sub end :ActionClass('RenderView') {
     my ($self, $c) = @_;

     if ($c->res->status eq '403') {
         $c->detach('denied');
     }
 }

=head1 DESCRIPTION

Provides a L<Catalyst reusable action|Catalyst::Manual::Actions> for user
role-based authorization. ACLs are applied via the assignment of attributes to
application action subroutines.

=head2 Processing of ACLs

One or more roles may be associated with an action.

Roles specified with the RequiresRole attribute are processed before roles
specified with the AllowedRole attribute.

An action with an empty ACL (no role attributes assigned) is unreachable by any
user regardless of the roles assigned to his account. This is not particularly
useful, and at some point will be changed so that the absence of role attributes
will cause a compile-time exception.

User roles are fetched via the invocation of the context user object's "roles"
method.

ACLs may be applied to chained actions so that different roles are required or
allowed for each link in the chain (or no roles at all).

=head2 Examples

 sub foo :Local
 :ActionClass(Role::ACL)
 :RequiresRole(admin) {
     my ($self, $c) = @_;
     ...
 }

This action may only be executed by users with the 'admin' role.

 sub bar :Local
 :ActionClass(Role::ACL)
 :RequiresRole(admin)
 :AllowedRole(editor)
 :AllowedRole(writer) {
     my ($self, $c) = @_;
     ...
 }

This action requires that the user has the 'admin' role and
also either the 'editor' or 'writer' role (or both).

 sub easy :Local
 :ActionClass(Role::ACL)
 :AllowedRole(admin)
 :AllowedRole(user) {
     my ($self, $c) = @_;
     ...
 }

Any user with either the 'admin' or 'user' role may execute this action.

 sub unreachable :Local
 :ActionClass(Role::ACL) {
     my ($self, $c) = @_;
     ...
 }

This action is unreachable and will always result in a 403 Forbidden response.
This is probably not very useful and should instead be caught at compile-time
and cause an exception.

=head1 METHODS

=head2 execute

See L<Catalyst::Action/METHODS/action>.

=cut

sub execute {
    my $self = shift;
    my ($controller, $c) = @_;

    if ($c->user) {
        if ($self->can_visit($c)) {
            $self->next::method(@_);
            return;
        }
    }

    $c->res->status(403);

    # execution should now fall through to a private 'end' action that
    # will branch on $c->res->status eq '403'
}

=head2 can_visit($c)

Return true if the authenticated user can visit this action.

This method is useful for determining in advance if a user can execute
a given action.

=cut

sub can_visit {
    my ($self, $c) = @_;

    my $user = $c->user;

    return unless $user;

    return unless
        $user->supports('roles') && $user->can('roles');

    my %user_has = map {$_,1} $user->roles;

    my $required = $self->attributes->{RequiresRole};
    my $allowed = $self->attributes->{AllowedRole};

    if ($required && $allowed) {
        for my $role (@$required) {
            return unless $user_has{$role};
        }
        for my $role (@$allowed) {
            return 1 if $user_has{$role};
        }
        return;
    }
    elsif ($required) {
        for my $role (@$required) {
            return unless $user_has{$role};
        }
        return 1;
    }
    elsif ($allowed) {
        for my $role (@$allowed) {
            return 1 if $user_has{$role};
        }
        return;
    }

    return;
}

1;



=head1 AUTHOR

David P.C. Wollmann E<lt>converter42@gmail.comE<gt>

=head1 BUGS

This is new code. Find the bugs and report them, please.

=head1 COPYRIGHT & LICENSE

Copyright 2009 by David P.C. Wollmann

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

