use strict;
use warnings;
use ExtUtils::MakeMaker;

eval "use ExtUtils::MakeMaker::Coverage";
if( !$@ ) {
    print "Adding testcover target\n";
}

WriteMakefile(
    NAME                => 'Text::CSV::Euclid',
    AUTHOR              => 'Ryan C. Thompson <rct@thompsonclan.org>',
    VERSION_FROM        => 'lib/Text/CSV/Euclid.pm',
    ABSTRACT_FROM       => 'lib/Text/CSV/Euclid.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Text-CSV-Euclid-*' },
);
