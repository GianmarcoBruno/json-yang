#!/usr/bin/env python

import string
import re
import argparse
import xml.dom.minidom

def Arrange(InFile, OutFile):

    xml_data = ""
    with open (InFile, "r") as infile:
        xml_data = infile.read()

    dom_xml = xml.dom.minidom.parseString(xml_data)
    tmpXml = dom_xml.toprettyxml(indent='  ')
    text_re = re.compile('>\n\s+([^<>\s].*?)\n\s+</',re.DOTALL)
    pretty_xml_data = text_re.sub('>\g<1></', tmpXml)

    with open(OutFile, 'w') as outfile:
        print >> outfile, pretty_xml_data

#------------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description='Slurp a XML file and reformat indentation')
    parser.add_argument('-i',
        help='input file',
        required=True,
        nargs=1)
    parser.add_argument('-o',
        help='output file if specified, otherwise rewrite in place',
        required=False,
        nargs=1)
    args = parser.parse_args()

    outfile = args.i[0] if (args.o==None) else args.o[0]
    Arrange(args.i[0], outfile)

###############################################################################
if __name__ == "__main__":
    main();

