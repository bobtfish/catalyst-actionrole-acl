package Catalyst::Action::Role::ACL;
use strict;
use warnings;
use Catalyst::Exception;

use base 'Catalyst::Action';
use vars qw($VERSION);
$VERSION = '0.01';

sub execute {
    my $self = shift;
    my ($controller, $c) = @_;

    if ($c->user) {
        if ($self->can_visit($c)) {
            $self->NEXT::execute(@_);
            return;
        }
    }

    $c->res->status(403);

    # execution should now fall through to a private 'end' action that
    # will branch on $c->res->status eq '403'
}

sub can_visit {
    my ($self, $c) = @_;

    my $user = $c->user;

    unless ($user) {
        Catalyst::Exception->throw(
            'The Catalyst application context in $c did not return an authenticated user object'
        );
    }

    unless ($user->supports('roles')) {
        Catalyst::Exception->throw("The supplied user object does not support roles (user=$user)");
    }

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

=head1 NAME

Catalyst::Action::Role::ACL - 

=cut

1;
