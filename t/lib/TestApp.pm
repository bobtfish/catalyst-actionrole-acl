package TestApp;
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
                        password => 'vashtanerada',
                        roles => [qw/doctor companion/],
                    },
                    foo => {
                        password => "s3cr3t",                                       
                        roles => [qw/delete editor/],
                    },
                    foo2 => {
                        password => "s3cr3t",                                       
                        roles => [qw/banana delete editor /],
                    },
                    william => {
                        password => "s3cr3t",
                        roles => [qw/sarah camel/],
                    },
                    william2 => {
                        password => "s3cr3t",
                        roles => [qw/shahi camel/],
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
