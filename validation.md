Validating a JSON fragment against YANG
=======================================

Problem: we want to know whether a piece of JSON is compliant
with a YANG model without using a client/server.

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

The right way (DSDL-based)
--------------------------

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

How to run examples
-------------------

In this directory you should see two files
`clean_examples` and `run_examples` and a directory (guess?) `example`.
Run `run_example` to run all the examples.
