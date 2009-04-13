package TestChained;
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
                    administrator => {
                        password => "s3cr3t",
                        roles => [qw/admin/],
                    },
                    phb => {
                        password => "s3cr3t",
                        roles => [qw/admin superuser/],
                    },
                    evilhax0r => {
                        password => "ev11",                                       
                        roles => [],
                    },
                }                       
            }
        }
    }
};

__PACKAGE__->setup;

1;
