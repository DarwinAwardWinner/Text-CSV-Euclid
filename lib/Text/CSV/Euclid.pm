use strict;
use warnings;
use v5.10;
use utf8;

package Text::CSV::Euclid;
# ABSTRACT: Provide a csv parser with options specified on the command-line

use Carp;
use Text::CSV;
use String::Escape qw(unprintable);
use Getopt::Euclid;
use Data::Alias;
use Symbol qw( gensym );

our $canary;

BEGIN {
    use Data::Dump qw(dump);
    # Set up canary value in %ARGV that will be clobbered during the
    # actual parsing step
    $canary = gensym;
    $ARGV{$canary}++;
    #warn "%ARGV: " . dump(\%ARGV) . "\n";
}


sub _get_csv_attrs_from_hash {
    # Same defaults as Text::CSV
    state $defaults = {
        quote_char          => '"',
        escape_char         => '"',
        sep_char            => ',',
        eol                 => $\,
        always_quote        => 0,
        binary              => 0,
        keep_meta_info      => 0,
        allow_loose_quotes  => 0,
        allow_loose_escapes => 0,
        allow_whitespace    => 0,
        blank_is_undef      => 0,
        verbatim            => 0,
    };

    my %hash;

    # Use %ARGV by default, but accept either hash or hashref
    alias {
        if (@_ == 0) {
            # Default: use %ARGV
            %hash = %ARGV
                or croak "Error: unable to use %ARGV before options have been parsed.";
        }
        elsif (@_ == 1  and  ref $_[0] eq 'HASH') {
            # Only one arg, and it's hashref, so use hashref
            %hash = %{$_[0]};
        }
        else {
            # Multiple args or first arg not a hashref, so assume @_
            # is a hash
            %hash = @_;
        }
    };

    my %ret = map {
        my $key = $_;
        (my $argv_key = "--$key") =~ s{_}{-}g; # Convert e.g. 'quote_char' into '--quotemeta-char'

        $_ => unprintable($hash{$argv_key} // $defaults->{$key});
    } keys %$defaults;

    return \%ret;
}

my $csv;

sub csv {
    if (not $csv) {
        # If the canary still exsits in %ARGV, then parsing has not yet occurred
        if (exists $ARGV{$canary}) {
            croak "Error: unable to create csv parser object before options have been parsed.";
        }

        $csv = Text::CSV->new(_get_csv_attrs_from_hash(\%ARGV));
    }

    return $csv;
}

1; # Magic true value required at end of module
__END__

=head1 SYNOPSIS

In your script:

    use Text::CSV::Euclid;
    my $csv = Text::CSV::Euclid->csv;

    # Now do interesting stuff that involves parsing CSV.
    parse_CSV_files_using($csv);

Now, to run your script:

    $ perl your-script.pl --sep-char='|' --quote-char="'" --escape-char"'"

Your script will read CSV files with vertical bars as separators and
single quotes as quotation characters, instead of the defaults (which
are commas and double quotes).

    $ perl your-script.pl --sep-char='\t' --quote-char="=" --escape-char"="

Your script will read CSV files with tabs characters as separators and
equals signs as quotation characters.

All the options to Text::CSV->new should be supported. These are
listed in the OPTIONS section.

=head1 OPTIONS

=head2 Options Affecting the Processing of CSV Data

The following arguments all correspond to the arguments to
Text::CSV->new:

=over

=item --quote-char [=] <char>

=for Euclid:
    char.type: string, length(char) == 1

=item --escape-char [=] <char>

=for Euclid:
    char.type: string, length(char) == 1

=item --sep-char [=] <char>

=item --eol [=] <eol>

=item --always-quote

=item --binary

=item --keep-meta-info

=item --allow-loose-quotes

=item --allow-loose-escapes

=item --allow-whitespace

=item --blank-is-undef

=item --verbatim

=back


=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.

This module is intended to be used from a script that deals with
tabular data in files. Using this module will allow the user of your
script to specify all possible options to Text::CSV's constructor by
passing command-line arguments to your script.

=head1 INTERFACE

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.

The only method exported by the module is C<csv>. This method returns
the CSV object created according to the command-line arguments that
were passed to the script.

=head1 DIAGNOSTICS

=over

=item C<< Error: unable to create csv parser object before options have been parsed. >>

You tried to use the csv method of this module before the program's
command-line options were parsed. Since the options were not parsed,
the module could not know what options to use to construct a CSV
object for you. This error is probably only possible if you suppress
the import method of this module by using it with an empty import
list.

=item Other errors

See Getopt::Euclid and Text::CSV for errors that could possibly be
generated by command-lline parsing or CSV object usage, respectively.

=back


=head1 CONFIGURATION AND ENVIRONMENT

Text::CSV::Euclid requires no configuration files or environment variables.


=head1 DEPENDENCIES

=over

=item Text::CSV

Provides the CSV object

=item Getopt::Euclid

Used for command-line parsing

=back


=head1 INCOMPATIBILITIES

This module uses Getopt::Euclid, so it may not interact well with
other modules from the Getopt:: family.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<rct+perlbug@thompsonclan.org>.


=head1 SEE ALSO

Getopt::Euclid, Text::CSV

=head1 AUTHOR

Ryan C. Thompson  C<< <rct@thompsonclan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Ryan C. Thompson C<< <rct@thompsonclan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
