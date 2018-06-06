#!/bin/bash

# usage: run.sh
# override defaults: e.g.
# FETCH=y ./run.sh

JSON=mw-topo.json
echo "JSON instance: " $JSON
../../../json-yang/validate $JSON data
