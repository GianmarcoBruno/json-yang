#!/usr/bin/perl -w

use Test::More tests => 5;
use File::Compare;
my $t = "t";
# lines are less then the default (68), do nothing
Trim_test("$t/trim_nothing.json", "$t/trim_nothing.json.ok", "-i=4");
# lines are long but we allow a huge width, do nothing
Trim_test("$t/trim_nothing_verylong.json", "$t/trim_nothing_verylong.json.ok", "-w=1000");
# lines exceed a tight limit and after simple rearrangement they fit
Trim_test("$t/trim_long_fit.json", "$t/trim_long_fit.json.ok", "-w=47");
# lines exceed a tight limit and after simple rearrangement they do not fit because we are not aggressive
Trim_test("$t/trim_long_nofit.json", "$t/trim_long_nofit.json.ok", "-w=59");
# lines exceed a tight limit and after aggressive rearrangement they fit
Trim_test("$t/trim_long_nofit.json", "$t/trim_long_fit_aggr.json.ok", "-w=59");

sub Trim_test {
    my ($input, $benchmark, $options) = @_;

    my $Test = Test::More->builder;
    my $output = $input . "_tmp";
    system("perl -s Trim $options -test $input");
    my $ok = $Test->ok(compare($output, $benchmark) == 0, "Trim: $input");
    print "Trim: $input ";
    print $ok ? "passed\n" : "failed\n";

    #unlink $output;
}
