package TestCanVisit;
use strict;
use warnings;

#    -Debug
#    StackTrace

use Catalyst qw/
    Authentication
    Authentication::Store::Minimal
    Authentication::Credential::Password
    Authorization::Roles
    Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

__PACKAGE__->config->{'Plugin::Authentication'} = {
    default_realm => 'members',
    realms => {
        members => {
            credential => {
                class => 'Password',
                password_field => 'password',
                password_type => 'clear'
            },
            store => {
                class => 'Minimal',
                users => {
                    drwho => {
                        password => 'vashta nerada',
                        roles => [qw/doctor companion/],
                    },
                    evilhax0r => {
                        password => "ev11",                                       
                        roles => [],
                    },
                    regularjoe => {
                        password => 'witty',
                        roles => [qw/user/],
                    },
                }                       
            }
        }
    }
};

__PACKAGE__->setup;

1;
