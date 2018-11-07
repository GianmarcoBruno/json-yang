#!/bin/bash
# 

# usage: run.sh
# override defaults: e.g.
# FETCH=y ./run.sh

JSON=interface_1+0_config.json
echo "JSON instance: " $JSON
../../validate -j $JSON -w config
