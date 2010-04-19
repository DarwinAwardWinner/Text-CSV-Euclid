#!perl
# -*- mode: sepia -*-
use v5.10;
use Test::More;
use Test::Differences;
use IO::Scalar;
use List::MoreUtils qw( all );
my $number_of_tests_run = 0;

# No args means we use defaults
BEGIN {
    # Need to set @ARGV before using the module
    @ARGV = qw( --sep-char=| --quote-char=' --escape-char=' );
}
use Text::CSV::Euclid;

my $data = <<'EOF';
ID|'Name'|'"Code" Name'
A1|'John Doe'|'Crazy Joe'
EOF

my @correct_lines = (
    [ 'ID', 'Name', '"Code" Name' ],
    [ 'A1', 'John Doe', 'Crazy Joe' ],
);

my $input = IO::Scalar->new(\$data);

my @lines;
my $csv = Text::CSV::Euclid->csv;

while (my $line = <$input>) {
    my $status = $csv->parse($line);
    chomp(my $chomped = $line);
    ok( $status, "parsing line: $chomped");
    $number_of_tests_run++;

    push @lines, [ $status ? $csv->fields() : () ];
}

foreach my $i (0..$#lines) {
    eq_or_diff( $lines[$i] , $correct_lines[$i], "testing line $i" );
    $number_of_tests_run++;
}

done_testing( $number_of_tests_run );

=head1 NAME

yourprog - Your program here

=head1 VERSION

This documentation refers to yourprog version 1.9.4

=head1 USAGE

    yourprog [options]  -s[ize]=<h>x<w>  -o[ut][file] <file>

=head1 OPTIONS

=over

=item --version

=item --usage

=item --help

=item --man

Print the usual program information

=back

Remainder of documentation starts here...

=head1 AUTHOR

Damian Conway (DCONWAY@CPAN.org)

=head1 BUGS

There are undoubtedly serious bugs lurking somewhere in this code.
Bug reports and other feedback are most welcome.

=head1 COPYRIGHT

Copyright (c) 2005, Damian Conway. All Rights Reserved.
This module is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License
(see http://www.perl.com/perl/misc/Artistic.html)
