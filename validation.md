Validating a JSON instance against YANG
=======================================

Problem: we want to know whether a JSON instance is compliant
with a YANG model without using a NETCONF client/server.

The wrong way (XSD-based)
-------------------------

This did not work. It is reported just to save your time.

The idea is to convert YANG to XSD, JSON to XML and validate it against the XSD.

```
            (1) 
YANG-module ---> XSD-schema - \       (3)
                               +--> Validation
JSON-file------> XML-file ----/
            (2)
```

pyang support for the XSD output format was deprecated in 1.5 and removed in 1.7.1.
1.7.1 is necessary to work with YANG 1.1 so the process stops just at (1).

The DSDL-based way
------------------

The steps are outlined below:

1. The driver file (JTOX) is generated from the YANG module. It is a JSON describing the YANG module.
2. An XML file is generated from the input JSON and the driver file and an option
   (either `config` or `data`). *Warning: check whether this means that `rpc` and `notifications` are
   not supported*.
3. The DSDL schemas for a given `target` are generated from the YANG module.
   `target` is the target document, i.e. one of `data`, `config`, `get-reply`, `rpc` etc.
4. The XML document generated in step 2. is validated against the schemas.   

Useful link: https://github.com/mbj4668/pyang/wiki/XmlJson

```
           data|config|rpc|rpc-reply|etc..
                      \
                       \
                        \ (3) 
         YANG-module ----+----> DSDL-schemas (RNG,SCH,DSRL)
                |                  |
                + (1)              |
                |                  | 
config|data  JTOX-file             |
       \        |                  |
        \       |                  |
         \      V                  V
JSON-file------>+----> XML-file -->+------------> Output
               (2)                (4)

```
Prerequisites: YANG tools and jing to have more useful output in case of failed XML
validation. If you do not want to use jing, remove the `-j` from the `yang2dsdl` in
step (4).

The yanglint based strategy
---------------------------

Starting from 0.3, this tool allow you to choose between pyang (2.0.2) or yanglint.
The first does not support Yang 1.1 (or better, the DSDL plugn we need).
The latter supports Yang 1.1.   
The instance document together with the YANG module(s) and other parameters are used to
create a set of instructions (1) for `yanglint`. `yanglint` is invoked non-interactively
and perform the validation.


```
JSON-file --------------+
                        |
YANG-module -------+    |
                   |    |
                   |    |
                   V    V
config|data -> yanglint-script ---> output
                    (1)        (2)  

```

How to use the tool
----------------
```
validate -j <JSON> -w <WHAT> [-y <DIR>] -s <STRATEGY> [-f] [-k] [-v]

JSON       the instance to be validated
WHAT       is one of: data, config"
DIR        the directory where YANG models can be found (default .)
STRATEGY   one of pyang (default) or yanglint

flags:
-f        (fetch) validation is made using modules specified in the
           JSON instance itself as, for example"
      "// __REFERENCE_DRAFTS__": {
          "ietf-network@2017-12-18":  "draft-ietf-i2rs-yang-network-topo-20",
      .. }
-k         to keep the temporary directory (it is removed by default)
-v        verbose

exit codes:
0         validation is successful
1         validation has been done and failed
2         validation cannot done (e.g. bad parameters, presence of target directory)

```
