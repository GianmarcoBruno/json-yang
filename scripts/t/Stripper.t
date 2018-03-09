#!/usr/bin/perl -w

use Test::More tests => 6;
use File::Compare;

my $t = "t";
Stripper_test("$t/strip_nothing.json", "$t/strip_nothing.json.ok", 4);
Stripper_test("$t/strip_key-val.json", "$t/strip_key-val.json.ok", 4);
Stripper_test("$t/strip_key-val_end.json", "$t/strip_key-val_end.json.ok", 4);
Stripper_test("$t/strip_key-list.json", "$t/strip_key-list.json.ok", 4);
Stripper_test("$t/strip_nested.json", "$t/strip_nested.json.ok", 4);
Stripper_test("$t/use-case-1-odu2-service.json", "$t/use-case-1-odu2-service.json.ok", 2);

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
