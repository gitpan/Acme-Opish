package Acme::Opish;

use vars qw($VERSION); $VERSION = '0.01';
use base qw(Exporter);
use vars qw(@EXPORT @EXPORT_OK);
@EXPORT = @EXPORT_OK = qw(
    enop
    has_silent_e
    no_silent_e
);
use strict;
use Carp;
use File::Basename;

# no_silent_e list {{{
my %OK; @OK{qw(
    adobe
    acme
    acne
    anime
    antistrophe
    apostrophe
    be
    breve
    Brule
    cabriole
    cache
    Calliope
    capote
    Catananche
    catastrophe
    clave
    cliche
    consomme
    coyote
    diastrophe
    epanastrophe
    epitome
    forte
    Giuseppe
    kamikaze
    karate
    me
    misogyne
    Pele
    phlebotome
    progne
    Psyche
    psyche
    Quixote
    Sade
    Salome
    saute
    stanze
    supercatastrophe
    Tempe
    tousche
    tsetse
    tonsillectome
    tonsillotome
    tracheotome
    ukulele
    we
    ye
    zimbabwe
)} = undef;
# }}}

sub no_silent_e {
    $OK{$_} = undef for @_;
    return keys %OK;
}

sub has_silent_e {
    delete $OK{$_} for @_;
    return keys %OK;
}

sub enop {
    my $prefix = 'op';
    if ($_[0] eq '-opish_prefix') {
        shift;
        $prefix = shift;
    }

    my @strings = @_;
    for (@strings) {
        if (-f) {
            # Open the file for reading.
            open IN, $_ or carp "Can't read $_: $!\n";

            # Construct a new filename.
            my ($name, $path) = fileparse($_, '');
            $_ = $path . 'opish-' . $name;

            # Open the new file for writing.
            open OUT, ">$_" or carp "Can't write $_: $!\n";

            # Write opish to the file.
            while (my $line = <IN>) {
                print OUT _to_opish($prefix, $line), "\n";
            }

            # Close the files.
            close IN;
            close OUT;
        }
        else {
            $_ = _to_opish($prefix, $_);
        }
    }

    return @strings;
}

# DrMath++ && DrForr++ && Yay!
sub _to_opish {
    my ($prefix, $string) = @_;

    # XXX Oof. We don't preserve whitespace.  : \
    my @words = split /\s+/, $string;

    for (@words) {
        my $is_capped = /^[A-Z]/ ? 1 : 0;
        $_ = lcfirst;

        # XXX Ack.  How can I simplify this ugliness?
        if (exists $OK{lc $_}) {
            s/
                (                   # Capture...
                    [aeiouy]+       # consecutive vowels
                    \B              # that do not terminate at a word boundry
                    (?![aeiouy])    # that are not followed by another vowel
                    |               # or
                    [aeiouy]*       # any consecutive vowels
                    [aeiouy]        # with any vowel following
                    \b              # that terminates at a word boundry.
                )                   # ...end capture.
            /$prefix$1/gisx;        # Add 'op' to what we captured.
        }
        else {
            # This regexp captures the "non-solitary, trailing e" vowels.
            s/
                (                   # Capture...
                    [aeiouy]+       # consecutive vowels
                    \B              # that do not terminate at a word boundry
                    (?![aeiouy])    # that are not followed by another vowel
                    |               # or
                    [aeiouy]*       # any consecutive vowels
                    [aiouy]         # with any non-e vowel following
                    \b              # that terminates at a word boundry.
                    |               # or
                    [aeiouy]+       # consecutive vowels
                    [aeiouy]        # with any vowel following
                    \b              # that terminates at a word boundry.
                )                   # ...end capture.
            /$prefix$1/gisx;        # Add 'op' to what we captured.
        }

        $_ = ucfirst if $is_capped;
    }

    return join ' ', @words;
}

1;
__END__

=head1 NAME

Acme::Opish - Prefix the audible vowels of words

=head1 SYNOPSIS

  use Acme::Opish;

  print join (', ',
      enop('Hello Aeryk!')
  ), "\n";
  # Hopellopo Opaeropyk! 

  @opped = enop('five', '/literature/Wuthering_Heights.txt');
  # fopive, /literature/opish-Wuthering_Heights.txt

  @opped = enop('xe', 'ze'));       # xe, ze
  @words = no_silent_e('xe', 'ze');
  @opped = enop('xe', 'ze');        # xope, zope
  @words = has_silent_e('xe', 'ze');
  @opped = enop('xe', 'ze');        # xe, ze

  # Okay.  Why not add anything you want, instead of "op"?
  print join (', ',
      enop(-opish_prefix => 'ubb', 'Foo bar?')
  ), "\n";
  # Fubboo bubbar?

=head1 ABSTRACT

Add an arbitrary prefix to the vowel groups of words (except for the 
"silent e").

=head1 DESCRIPTION

Convert words to Opish, which is similar to "Ubish", but infinitely 
cooler.

More accurately, this means, add an arbitrary prefix to the vowel 
groups of words (except for the "silent e").

Note: This module capitalized words beginning with a vowel to a 
capitalized version with the prefix prepended.  Maybe a couple 
examples will elucidate this point:

  enop('Abc') produces 'Opabc'
  enop('abC') produces 'opabC'

Unfortunately, this function, currently converts consecutive spaces 
into a single space.  Yes, this is not a feature, but a bug.

=head1 EXPORT

=head2 enop [-opish_prefix => STRING,] ARRAY

Convert strings or entire text files to opish.

If a member of the given array is a string, it is converted to opish.
If it is an existing text file, it is opened and converted to opish, 
and then saved as "opish-$filename".

If the first member of the argument list is "-opish_prefix", then the 
next argument is assumed to be the user defined prefix to use, in 
place of "op".

=head2 no_silent_e ARRAY

Add the given arguments to the "OK" list of words that are to be 
converted without regard for the "silent e".

This function returns the number of keys in the "OK" list.

=head2 has_silent_e ARRAY

Delete the given arguments from the "OK" list of words that are to be
converted with regard for the "silent e".

This function returns the number of keys in the "OK" list.

=head1 SEE ALSO

=head1 TO DO

Make this thing preserve contiguous spaces.

Go in reverse.  That is "deop" text.

Add more "OK" words".

=head1 THANK YOU

DrForr (A.K.A. Jeff Goff) and DrMath (A.K.A. Ken Williams)

=head1 DEDICATION

Hopellopo Opaeropyk!

=head1 AUTHOR

Gopene Bopoggs, E<lt>cpan@ology.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Gopene Bopoggs

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
