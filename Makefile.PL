use inc::Module::Install;

name 'Catalyst-Action-Role-ACL';
all_from 'lib/Catalyst/Action/Role/ACL.pm';

build_requires 'MRO::Compat';
build_requires 'Catalyst::Runtime';
build_requires 'Test::More';
build_requires 'ok';
test_requires 'Test::WWW::Mechanize::Catalyst';
test_requires 'Catalyst::Plugin::Authentication';
test_requires 'Catalyst::Plugin::Authentication::Store::Minimal';
test_requires 'Catalyst::Plugin::Authentication::Credential::Password';
test_requires 'Catalyst::Plugin::Authorization::Roles';
test_requires 'Catalyst::Plugin::Session';
test_requires 'Catalyst::Plugin::Session::Store::FastMmap';
test_requires 'Catalyst::Plugin::Session::State::Cookie';

WriteAll();
