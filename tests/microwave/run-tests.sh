#!/bin/bash

# "test suite" exits 0 only if all tests exit with 0

# here you can decide to use dockerized tool or not
function validate {
    docker run -it --rm --mount type=bind,source="$(pwd)",target=/home/app jy:0.4 "$@"
    #../../validate "$@"
}

EXIT=0
printf '%-16s%-16s%-8s\n' "STRATEGY" "WHAT" "OUT"
for STRATEGY in pyang yanglint; do
    for WHAT in config; do
        rm -rf target fetched_yang_models

        #validate -j interface_1+0_$WHAT.json -w "$WHAT" -y . -s $STRATEGY 2> .stderr 1> /dev/null
        validate -j interface_1+0_$WHAT.json -w "$WHAT" -y target -s $STRATEGY -f
	OUT=$?
	EXIT=$((EXIT + OUT))
	printf '%-16s%-16s%-8s\n' "$STRATEGY" "$WHAT" "$OUT"
	rm -f .stderr
    done
done
exit $EXIT
