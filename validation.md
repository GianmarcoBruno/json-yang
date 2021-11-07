Validating a JSON instance against YANG
=======================================

Problem: we want to know whether a JSON instance is compliant
with a YANG model without using a NETCONF client/server.

The yanglint based strategy
---------------------------

Starting from 0.3, this tool allow you to choose between pyang or yanglint.
In release 2.0 the support for pyang has been dropped.
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

