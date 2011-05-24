use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Dotcloudstoria',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/Dotcloudstoria.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Dancer'     => 1.3040,
        'Plack'      => 0.9979,
        'Template'   => 2.22,
        'Test::More' => 0,
        'Try::Tiny'  => 0,
        'YAML'       => 0,
        'WebService::Nestoria::Search' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Dotcloudstoria-*' },
);
