#!/bin/bash -i

# "test suite" exits 0 only if all tests exit with 0
printf '%-16s%-16s%-8s\n' "STRATEGY" "WHAT" "OUT"
git clean -xdff .
WHAT=config
STRATEGY=yanglint
validate -j interface_1+0_$WHAT.json -w $WHAT -m downloads -s $STRATEGY -f 2> .stderr 1> /dev/null
OUT=$?
printf '%-16s%-16s%-8s\n' $STRATEGY $WHAT $OUT
exit $OUT
