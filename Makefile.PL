use 5.008;
use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'Acme::Opish',
    'VERSION_FROM' => 'Opish.pm',
    'PREREQ_PM'    => {},
    ($] >= 5.005
        ? (ABSTRACT_FROM => 'Opish.pm',
          AUTHOR         => 'Gene Boggs <cpan@ology.net>')
        : ()
    ),
);
