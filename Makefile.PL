use inc::Module::Install 0.91;

name 'Catalyst-Action-Role-ACL';
all_from 'lib/Catalyst/Action/Role/ACL.pm';

requires 'Catalyst::Runtime';
requires 'Moose';
requires 'Catalyst::Controller::ActionRole';
requires 'namespace::autoclean';

test_requires 'Test::More';

WriteAll();
