use inc::Module::Install;

name 'Catalyst-Action-Role-ACL';
all_from 'lib/Catalyst/Action/Role/ACL.pm';

build_requires 'MRO::Compat';
build_requires 'Catalyst::Runtime';
build_requires 'Test::More';
build_requires 'ok';
test_requires 'Test::WWW::Mechanize::Catalyst';

WriteAll();
