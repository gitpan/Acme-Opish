use Test::More tests => 14;
BEGIN { use_ok 'Acme::Opish' };

is_deeply enop('a'), 'opa',
    'single vowel word';

is_deeply enop('to'), 'topo',
    'single vowel terminating string';

is_deeply enop('bee'), 'bopee',
    'double vowel terminating string';

is_deeply enop('Abc'), 'Opabc',
    'preserve ucfirst';

is_deeply enop('eg/test.txt'), 'eg/opish-test.txt',
    'convert eg/test.txt to eg/opish-test.txt';

ok -e 'eg/opish-test.txt',
    'eg/opish-test.txt was created';

is_deeply [enop('xe', 'ze')], [('xe', 'ze')],
    'notice silent e';

my $n = no_silent_e();
ok defined $n,
    'no_silent_e succeeded';

is no_silent_e('xe', 'ze'), $n + 2,
    'added words to the OK list';

is_deeply [enop('xe', 'ze')], [('xope', 'zope')],
    'ignore silent e';

my $m = has_silent_e('xe', 'ze');
ok $n == $m,
    'has_silent_e removed words from the OK list';

is_deeply [enop('xe', 'ze')], [('xe', 'ze')],
    'notice silent e';

is_deeply enop(-opish_prefix => 'ubb', 'Foo bar?'), 'Fubboo bubbar?',
    'user defined prefix';
