#!/bin/bash -i

# "test suite" exits 0 only if all tests exit with 0

EXIT=0
printf '%-16s%-16s%-8s\n' "STRATEGY" "WHAT" "OUT"
for STRATEGY in pyang yanglint; do
    for WHAT in config; do
        rm -rf target downloads

        validate -j interface_1+0_$WHAT.json -w "$WHAT" -m target -s $STRATEGY -f
	OUT=$?
	EXIT=$((EXIT + OUT))
	printf '%-16s%-16s%-8s\n' "$STRATEGY" "$WHAT" "$OUT"
	rm -f .stderr
    done
done
exit $EXIT
