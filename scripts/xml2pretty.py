#!/usr/bin/env python
#

import string
import re
import optparse

import xml.dom.minidom

###############################################################################
def main():

    p = optparse.OptionParser()
    p.add_option('-i', '--infile',
                 action="store",
                 dest="infile",
                 help="input xml file",
                 default=None)

    p.add_option('-o', '--outfile',
                 action="store",
                 dest="outfile",
                 help="output xml prettified file",
                 default=None)

    options, args = p.parse_args()

    infile = open(options.infile)

    xml_data = ""
    with open (options.infile, "r") as infile:
        xml_data = infile.read()

    dom_xml = xml.dom.minidom.parseString(xml_data)
    tmpXml = dom_xml.toprettyxml(indent='  ')
    text_re = re.compile('>\n\s+([^<>\s].*?)\n\s+</',re.DOTALL)
    pretty_xml_data = text_re.sub('>\g<1></', tmpXml)

    with open(options.outfile, 'w') as outfile:
    	print >> outfile, pretty_xml_data

###############################################################################
if __name__ == "__main__":
    main();

