#!/usr/bin/perl -w

use Test::More tests => 5;
use File::Compare;

my $t = "tests";
Stripper_test("$t/strip_nothing.json", "$t/strip_nothing.json.ok", 4);
Stripper_test("$t/strip_key-val.json", "$t/strip_key-val.json.ok", 4);
Stripper_test("$t/strip_key-val_end.json", "$t/strip_key-val_end.json.ok", 4);
Stripper_test("$t/strip_key-list.json", "$t/strip_key-list.json.ok", 4);
Stripper_test("$t/strip_nested.json", "$t/strip_nested.json.ok", 4);

sub Stripper_test {
    my ($input, $benchmark, $indent) = @_;

    my $Test = Test::More->builder;

    my $output = $input . "_tmp";
    system("python Stripper.py --infile $input --outfile $output --indent $indent --clean"); 
    my $ok = $Test->ok(compare($output, $benchmark) == 0, "Stripper: $input");
    
    print "Stripper: $input ";
    print $ok ? "passed\n" : "failed\n";

    unlink $output;
}
