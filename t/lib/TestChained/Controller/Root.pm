package TestChained::Controller::Root;

use strict;
use warnings;

use Catalyst;
use base 'Catalyst::Controller';

__PACKAGE__->config(namespace => q{});

sub index :Path Args(0) {
    my ($self, $c) = @_;
    $c->res->body('action: index');
}

# Request for http://localhost/stage2 requires both
# 'admin' and 'superuser' roles:

sub stage1
:Local
:ActionClass(Role::ACL)
:RequiresRole(admin)
{
    my ($self, $c) = @_;
    $c->res->body('Ok');
}

sub stage2
:Chained('stage1')
:Path(stage2)
:ActionClass(Role::ACL)
:RequiresRole(superuser)
{
    my ($self, $c) = @_;
    $c->res->body('Ok');
}

sub login :Local {
    my ($self, $c) = @_;

    my $creds = {
        username => $c->req->params->{user},
        password => $c->req->params->{password},
    };

    my $uid;

    if ($c->authenticate($creds, 'members')) {
        $uid = $c->user->id;
    }
    else {
        $uid = '*';
    }

    $c->res->body("logged in: $uid");
}

sub logout :Local {
    my ($self, $c) = @_;

    if (my $user = $c->user) {
        # we can't wait for sessions to expire on their own
        $c->delete_session;
        $user->logout;
        $c->res->redirect($c->uri_for());
    }
    else {
        $c->detach('denied');
    }
}

sub edit
:Local
:ActionClass(Role::ACL)
:RequiresRole(editor)
{
    my ($self, $c) = @_;
    $c->res->body("action: edit");
}

sub end :ActionClass('RenderView') {
    my ($self, $c) = @_;

    if ($c->res->status == 403) {
        $c->detach('denied');
    }
}

sub denied :Private {
    my ($self, $c) = @_;

    $c->res->body('access denied');
}


1;


__END__
/usr/lib64/perl5/site_perl/5.8.8/Class/Accessor.pm

