#!/usr/bin/env python

import sys
import re
import argparse

import json
from collections import OrderedDict

from pprint import pprint
from datetime import datetime

indent = 2

def Stripper(InFile, OutFile, Clean):

    print "Clean: %s"%(Clean)
    print "Indentation: %s"%(indent)

    try:
        with open(InFile) as infile:
            # OrderedDict is necessary to preserve JSON order to Python dict
            originalData = json.load(infile, object_pairs_hook=OrderedDict)
    except:
        sys.exit("%s: unable to open input file - perhaps malformed JSON?"%(OutFile))

    # do the work
    filteredData = traverse(originalData, Clean)

    # OrderedDict() is used to be on the safe side - though seems not necessary so far
    formattedResult = json.dumps(OrderedDict(filteredData), indent=indent, separators=(',', ': '))
    
    try:
        with open(OutFile, 'w') as outfile:
            outfile.write(formattedResult)
            outfile.write('\n')
    except:
        sys.exit("%s: unable to open outfile"%(OutFile))


#------------------------------------------------------------------------------
def traverse(d, Clean):
    pattern = re.compile("//")
    if isinstance(d, dict):
        for k in d.keys():
            if (isinstance(d[k], basestring) or isinstance(d[k], list)):
               # k is key of a string value so may be a comment
               if (pattern.search(k)):
                   if (Clean):
                       del d[k]
            else:
                traverse(d[k], Clean)
    elif isinstance(d, list):
        for j in d:
            traverse(j, Clean)
    return d

#------------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description='Strip pseudo-comments from JSON')
    parser.add_argument('--infile',
                            help='input file',
                            required=True,
                            nargs=1)
    parser.add_argument('--outfile',
                            help='output file',
                            required=True,
                            nargs=1)
    parser.add_argument('--indent',
                            help='JSON indentation',
                            required=False,
                            nargs=1)
    parser.add_argument('--clean',
                            action='store_true',
                            required=False,
                            help='remove all comments')
    args = parser.parse_args()

    global indent
    indent = 2 if (args.indent==None) else int(args.indent[0])

    Stripper(args.infile[0], args.outfile[0], args.clean)

#------------------------------------------------------------------------------
if __name__ == '__main__':
    main();

