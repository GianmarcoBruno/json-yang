# json-yang

A lightweight standalone tool to validate RESTCONF instances.

## Why

The need for some automated tool was expressed in the IETF CCAMP Transport
NBI Design Team (https://github.com/danielkinguk/transport-nbi).
The toolchain design is described in `toolchain.md`.  
The validation process is detailed in `validation.md`.

## installation

The easiest way is to build the docker image on Linux:  
```
docker build . -t <my-name>
```

Then add this function to your ```.bashrc```:

```
function validate {
    docker run --rm -it --mount type=bind,source="$(pwd)",target=/home/app <my-name> "$@"
}
```

That's all: use the containerized tool as just ```validate```.  

It is possible to run the tool as-is without using containers. In this case you need to
compile libyang and have wget and jq 1.6 available on your executing environment.

The tool has been tested on Linux only so far.

## Description

The tool receives an annotated JSON file which represents a RESTCONF instance.
The annotations declare the YANG modules and relevant IETF documents from where
they can be downloaded. The tool retrieves the documents, extracts the YANG
models and use them to validate the JSON file using the "yanglint" library.

## How to use the tool

1) create or obtain the annotated JSON file you want to validate.    
    For example you might extract it from a IETF I-D.
    Currently the tool operates only on a JSON file at a time.
   
2) determine if the said file is of kind "config" or "data" which
   means respectively configuration or operational data.
   
3) finally run the validation tool as follows:

```
validate -j <JSON> -w <WHAT> [-y <DIR>] [-f] [-k] [-v]

JSON       the instance to be validated
WHAT       is one of: data, config"
DIR        the directory where YANG models can be found (default .)

flags:
-f        (fetch) validation is made using modules specified in the
           JSON instance itself as, for example"
      "// header": {
        "reference-drafts": {
          "ietf-network@2017-12-18":  "draft-ietf-i2rs-yang-network-topo-20"
	}
      .. }
-k         to keep the temporary directory (it is removed by default)
-v        verbose
```

exit codes:
0         validation is successful
1         validation has been done and failed
2         validation cannot done (e.g. bad parameters, presence of target directory)


## Versions

| version | pyang   | yanglint | notes |
| ------- | ------- | -------- | ------|
| 2.3 | N/A   | 2.0.112 | Dockerfile linting. Image size reduced to 27.2MB |
| 2.2 | N/A   | 2.0.112 | image size reduced to 29.5MB using Alpine and statically-linked yanglint |
| 2.1 | N/A   | 2.0.112 | replaced ubuntu base image with minideb (image is 89M) and refactoring |
| 2.0 | N/A   | 2.0.112 | removed pyang validation and python code (image is now 135M). Use simplified annotations. Upgraded to latest yanglint |
| 1.1 | 2.5.0 | 2.0.88 | uplifted validation engines and aligned tests (new versions are stricter) |
| 1.0 | 1.7.1 | 1.0-rc2 | corrected documentation |
| 0.8 | 1.7.1 | 1.0-rc2 | fixes, improvements and added "fuf" |
| 0.7 | 1.7.1 | 1.0-rc2 | distinct "downloads", "models" and "target" directories |
| 0.6 | 1.7.1 | 1.0-rc2 | reduced images size from 1.46G to 248M -  only 69M on top of the base image |
| 0.5 | 1.7.1 | 1.0-rc2 |  -           |
| 0.4 | 1.7.1 | 1.0-rc2 | moved back to 1.7.1 as it seems to be the only version to have DSDL plugin supporting Yang 1.1 |
| 0.3 | 2.0.2 | 1.0-rc2 | initial dockerized version |

The folding/unfolding program in ```scripts/fuf``` has been extracted from https://www.rfc-editor.org/rfc/rfc8792.txt.

## Thanks

Many thanks to all the design team and in particular to Carlo Perocchio.
