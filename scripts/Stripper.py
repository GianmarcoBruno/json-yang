#!/usr/bin/env python

import sys
import re
import argparse

import json
from collections import OrderedDict

from pprint import pprint
from datetime import datetime

# indentLevel is the current line indentation. indent is the amount of spaces.
indentLevel = 0
indent = 2
maxlen = 0 # infinity

def Stripper(InFile, OutFile, Clean):

    print "Clean: %s"%(Clean)
    print "Max length: %s"%(maxlen)
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
    global indentLevel
    indentLevel = indentLevel + 1
    pattern = re.compile("//")
    if isinstance(d, dict):
        for k in d.keys():
            if (isinstance(d[k], basestring)):
               # k is key of a string value so may be a comment
               if (pattern.search(k)):
                   length = commentLengthEstimate(indentLevel, k, d[k])
                   if ((maxlen != 0) & (length > maxlen)):
                       #print "NEED TO BREAK %s"%(length)
                       #print "STRING IS %s"%(d[k])
		       pass
                   if (Clean):
                       del d[k]
            else:
                traverse(d[k], Clean)
    elif isinstance(d, list):
        for j in d:
            traverse(j, Clean)
    indentLevel = indentLevel - 1
    return d

#------------------------------------------------------------------------------
def commentLengthEstimate(i, k, v):
    # return a guess of the estimated line length of the pseudo-comment:
    # indentLevel * indent + k + v + 7
    # 7 is made of four quotation, one comma, a semicolon and a space
    # It sometimes overestimates by one and we can live with that

    return 7 + i * indent + len(k) + len(v)


#------------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description='Strip pseudo-comments from JSON')
    parser.add_argument('--infile',
                            help='inventory file',
                            required=True,
                            nargs=1)
    parser.add_argument('--outfile',
                            help='output file',
                            required=True,
                            nargs=1)
    parser.add_argument('--maxlen',
                            help='maximum length of JSON pseudo-comments',
                            required=False,
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

    # incompatible options
    if ((args.maxlen != None) & args.clean):
        sys.exit("clean and nonzero maxlen are incompatible")

    # 0 stands for infinity
    global maxlen
    maxlen = 0 if (args.maxlen==None) else int(args.maxlen[0])

    global indent
    indent = 2 if (args.indent==None) else int(args.indent[0])

    Stripper(args.infile[0], args.outfile[0], args.clean)

#------------------------------------------------------------------------------
if __name__ == '__main__':
    main();

