use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Text::CSV::Euclid',
    license             => 'perl',
    dist_author         => 'Ryan C. Thompson <rct@thompsonclan.org>',
    dist_version_from   => 'lib/Text/CSV/Euclid.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0.50,
    },
    add_to_cleanup      => [ 'Text-CSV-Euclid-*' ],
);

$builder->create_build_script();
