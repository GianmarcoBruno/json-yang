# json-yang

A standalone tool to validate instances in JSON format of YANG models.

## Why

The need for some automated tool was expressed in the IETF CCAMP Transport
NBI Design Team (https://github.com/danielkinguk/transport-nbi).
The toolchain design is described in `toolchain.md`.  
The validation process is detailed in `validation.md`.

## Docker installation (preferred)

The easiest way is to build and use the docker image on Linux.  
Say this is version 1.1:  
```
docker build . -t jy:1.1
```

Then add this function to your ```.bashrc```:

```
function validate() {
    docker run --rm -it --mount type=bind,source="$(pwd)",target=/home/app jy:1.1 "$@"
}
```

Now you can use the containerized tool as just ```validate```.  

### Installation from source on Linux (discouraged)

Prerequisites:
- `bash 4.3`
- `python 3.7`
- `pyang 1.7.1`
- `xml linter` (libxml2-utils on Alpine Linux or libxml2 on Cygwin)
- `xslt processor` (xlstproc on Alpline Linux or libxslt on Cygwin)
- `rfcstrip 0.6`
- `yanglint` v1.0-rc2 to be build by yourself if you want it (Linux only)

You can build `yanglint` (https://github.com/CESNET/libyang) or download it
on Linux. It is is not available on Cygwin, neither it can be compiled as is.
On Cygwin you will still be able to validate using `pyang` with its limitations.

To run the tool from source:
```
./validate
```

**Note**: specify the path to the script or add its location to your ```$PATH```.
The tool has been tested on Linux so far.

## Description

The tool receives an annotated JSON file which represents a RESTCONF instance.
The annotations declare the YANG modules and relevant IETF documents from where
they can be downloaded. The tool automatically retrieves the documents, extracts
the YANG modules and use them to validate the JSON file. The user can specify
"yanglint" or "pyang" as validation engine.

## How to use the tool

1) create or obtain the annotated JSON file you want to validate.    
    For example you might extract it from a IETF I-D.
    Currently the tool operates only on a JSON file at a time.
   
2) determine if the said file is of kind "config" or "data" which
   means respectively configuration or operational data.
   
3) finally run the validation tool as follows:

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
```

exit codes:
0         validation is successful
1         validation has been done and failed
2         validation cannot done (e.g. bad parameters, presence of target directory)


## Versions

| version | pyang   | yanglint | notes |
| ------- | ------- | -------- | ------|
| 1.1 | 2.5.0 | 2.0.88 | uplifted validation engines and aligned tests (new versions are stricter) |
| 1.0 | 1.7.1 | 1.0-rc2 | corrected documentation |
| 0.8 | 1.7.1 | 1.0-rc2 | fixes, improvements and added "fuf" |
| 0.7 | 1.7.1 | 1.0-rc2 | distinct "downloads", "models" and "target" directories |
| 0.6 | 1.7.1 | 1.0-rc2 | reduced images size from 1.46G to 248M -  only 69M on top of the base image |
| 0.5 | 1.7.1 | 1.0-rc2 |  -           |
| 0.4 | 1.7.1 | 1.0-rc2 | moved back to 1.7.1 as it seems to be the only version to have DSDL plugin supporting Yang 1.1 |
| 0.3 | 2.0.2 | 1.0-rc2 | initial dockerized version |

The folding/unfolding program in ```scripts/fuf``` has been extracted from https://tools.ietf.org/html/draft-ietf-netmod-artwork-folding-11.

## Thanks

Many thanks to all the design team and in particular to Carlo Perocchio.
