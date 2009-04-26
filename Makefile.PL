use inc::Module::Install;

name 'Catalyst-Action-Role-ACL';
all_from 'lib/Catalyst/Action/Role/ACL.pm';

requires 'MRO::Compat';
requires 'Catalyst::Runtime';
test_requires 'Test::More';

WriteAll();
