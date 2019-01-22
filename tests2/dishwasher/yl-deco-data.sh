#!/bin/bash
# yanglint interactive scripting
JSON_FILE=dishwasher-deco-data.json
YANG_FILE=dishwasher.yang
YANG_AUG_FILE=dishwasher-decorated.yang

JSON_FILE_TMP=tmp-${JSON_FILE}
cp $JSON_FILE $JSON_FILE_TMP

python ../../scripts/Stripper.py -i $JSON_FILE_TMP --clean

echo "add -i ${YANG_FILE}
      add -i ${YANG_AUG_FILE}
      data ${JSON_FILE_TMP}" | yanglint

rm $JSON_FILE_TMP
