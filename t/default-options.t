#!perl
# -*- mode: sepia -*-
use v5.10;
use Test::More;
use Test::Differences;
use IO::Scalar;

my $number_of_tests_run = 0;

# No args means we use defaults
BEGIN {
    # Need to set @ARGV before using the module
    @ARGV = ();
}
use Text::CSV::Euclid;

is( scalar %ARGV, 0 , '%ARGV is empty');
$number_of_tests_run++;

my $data = <<'EOF';
ID,"Name","""Code"" Name"
A1,"John Doe","Crazy Joe"
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
    ok( $status, "parsing line: $line");
    $number_of_tests_run++;

    push @lines, [ $status ? $csv->fields() : () ];
}

foreach my $i (0..$#lines) {
    eq_or_diff( $lines[$i] , $correct_lines[$i], "testing line $i" );
    $number_of_tests_run++;
}

done_testing( $number_of_tests_run );
