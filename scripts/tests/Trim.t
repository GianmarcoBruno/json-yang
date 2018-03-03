#!/usr/bin/perl -w

use Test::More tests => 6;
use File::Compare;
my $t = "tests";
Trim_test("$t/trim_nothing.json", "$t/trim_nothing.json.ok", 4);
Trim_test("$t/trim_nothing72.json", "$t/trim_nothing72.json.ok", 1000);
Trim_test("$t/trim_nothing_w40.json", "$t/trim_nothing_w40.json.ok", 4, 40);
Trim_test("$t/trim_RFC_i4.json", "$t/trim_RFC_i4.json.ok", 4);
Trim_test("$t/trim_RFC_i2.json", "$t/trim_RFC_i2.json.ok", 2);
Trim_test("$t/trim_shortcomments.json", "$t/trim_shortcomments.json.ok", 2);
#Trim_test("$t/trim_arrayedcomments.json", "$t/trim_arrayedcomments.json.ok");

sub Trim_test {
    my ($input, $benchmark, $indent, $width) = @_;

    $width ||= 72;

    my $Test = Test::More->builder;
    my $output = $input . "_tmp";
    system("perl -s Trim -i=$indent -w=$width -test $input");
    my $ok = $Test->ok(compare($output, $benchmark) == 0, "Trim: $input");
    print "Trim: $input ";
    print $ok ? "passed\n" : "failed\n";

    unlink $output;
}
