#!/usr/bin/env python

import sys
import re
import argparse
import json
import logging
from os import path
import urllib.request
import subprocess

LOG = logging.getLogger(__name__)
logging.basicConfig(format="%(asctime)s %(levelname)s %(message)s", level=logging.INFO)

RfcPattern = re.compile(r"rfc")
DraftPattern = re.compile(r"draft-")

def Parse(inFile, downloadDir):

    try:
        with open(inFile) as infile:
            data = json.load(infile)
            
    except:
        LOG.error("%s: Xunable to open input file - perhaps malformed JSON?"%(inFile))
        sys.exit(1)

    references=data["// __REFERENCE_DRAFTS__"]
    for model in references.keys():
        document = references[model]
        if (RfcPattern.match(document)):
            Fetch("rfc", model, document, downloadDir)
        else:
            if (DraftPattern.match(document)):
                Fetch("id", model, document, downloadDir)
            else:
                sys.exit("%s starts with neither draft or rfc"%(document));

def Fetch(fragment, model, document, downloadDir):
    location="https://tools.ietf.org/" + fragment + "/" + document + ".txt"
    content = urllib.request.urlopen(location)
    localDoc = path.join(downloadDir, document + ".txt")
    #LOG.info("> writing to " + localDoc)
    try:
        with open(localDoc, 'w') as h:
            h.write(content.read().decode('utf-8'))
    except:
        sys.exit("%s: unable to write to "%(document))

    # example: rfcstrip -d downloads -f ietf-te-topology@2018-06-15.yang downloads/draft-ietf-teas-yang-te-topo-18.txt
    subprocess.call(["rfcstrip", "-d", downloadDir, "-f", model + '.yang', localDoc])

#------------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description='fetch RFC/drafts from the pseudo-comments from JSON')
    parser.add_argument('-i',
        help='input file',
        required=True,
        nargs=1)
    parser.add_argument('-o',
        help='output directory',
        required=True,
        nargs=1)
    args = parser.parse_args()
    
    if not (path.exists(args.i[0])):
        LOG.error("%s: cannot find file "%(args.i[0]))
        sys.exit(1)

    if not (path.isdir(args.o[0])):
        LOG.error("%s: is not a directory"%(args.o[0]))
        sys.exit(1)
    #>>
    #model = "ietf-te-topology@2018-06-15"
    #downloadDir = "downloads"
    #localDoc = "draft-ietf-teas-yang-te-topo-18.txt";
    #try:
    #    with open(localDoc, 'w+') as h:
    #        LOG.warn("opening %s"%(localDoc))
            #subprocess.call(["rfcstrip", "-d", downloadDir, "-f", "model + '.yang'", localDoc], stdout = h)
            #subprocess.call(["rfcstrip", "-d", downloadDir, "-f", "model + '.yang'", localDoc])
            #subprocess.call(["rfcstrip", "--help"])
    #        subprocess.call(["rfcstrip", "-i", downloadDir, "-d", downloadDir, "-f", model + '.yang', localDoc], stdout = h)
    #except:
    #    sys.exit("%s: unable to write to "%(document))
    #exit(7)
    #<<
    Parse(args.i[0], args.o[0])

#------------------------------------------------------------------------------
if __name__ == '__main__':
    main();
