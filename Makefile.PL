use inc::Module::Install 0.91;

name 'Catalyst-ActionRole-ACL';
all_from 'lib/Catalyst/ActionRole/ACL.pm';

requires 'Catalyst::Runtime';
requires 'Moose';
requires 'Catalyst::Controller::ActionRole';
requires 'namespace::autoclean';

test_requires 'Test::More';

WriteAll();

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Catalyst/ActionRole/ACL.pm > README");
}

