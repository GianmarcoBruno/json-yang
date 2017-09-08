#!/usr/bin/env python

import sys
import re
import argparse

import json
from collections import OrderedDict

def Stripper(InFile, OutFile, indent):

    try:
        with open(InFile) as infile:
            originalData = json.load(infile, object_pairs_hook=OrderedDict)
    except:
        sys.exit("%s: unable to open input file - perhaps malformed JSON?"%(OutFile))

    formattedResult = json.dumps(OrderedDict(originalData), indent=indent, separators=(',', ': '))
    
    try:
        with open(OutFile, 'w') as outfile:
            outfile.write(formattedResult)
            outfile.write('\n')
    except:
        sys.exit("%s: unable to open outfile"%(OutFile))

#------------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description='Slurp a JSON file and reformat indentation')
    parser.add_argument('--infile',
                            help='input file',
                            required=True,
                            nargs=1)
    parser.add_argument('--outfile',
                            help='output file',
                            required=True,
                            nargs=1)
    parser.add_argument('--indent',
                            help='indentation',
                            required=False,
                            nargs=1)
    args = parser.parse_args()

    global indent
    indent = 2 if (args.indent==None) else int(args.indent[0])
    Stripper(args.infile[0], args.outfile[0], indent)

#------------------------------------------------------------------------------
if __name__ == '__main__':
    main();
