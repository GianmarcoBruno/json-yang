# json-yang

A standalone tool to validate instances in JSON format of YANG models.

## Why

The need for some automated tool was expressed in the IETF CCAMP Transport
NBI Design Team (https://github.com/danielkinguk/transport-nbi).
How the toolchain is designed is described in `toolchain.md`.  
Details on the validation process can be found in `validation.md`

## Installation

You can run the tool from source or build the docker image.  
In both case clone this repo:
```
git clone https://github.com/GianmarcoBruno/json-yang.git
cd json-yang
```

### Run from source

Prerequisites:
- `bash 4.3`
- `python 3`
- `pyang 1.7.1`
- `xmllint` (optional)
- `rfcstrip 0.6`
- `yanglint` v1.0-rc2 to be build by yourself if you want it

To run the tool and see the options:
```
./validate
```

**Note**: specify the path to the script or add its location to your ```$PATH```.
The tool has been tested on Linux so far.

### Run the docker image

Starting from 0.3 you can build the docker image and then run
the containerized tool. Assume a generic <version>, e.g. 0.6:

```
docker build . -t yl:<version>
```

Then add this function to your ```.bashrc```:

```
function validate() {
    docker run --rm -it --mount type=bind,source="$(pwd)",target=/home/app jy:<version> "$@"
}
```

Now you can use the dockerized tool as ```validate```.
**Note**: do not specify the path because this is actually a function call.


## Versions

| version | pyang   | yanglint | notes |
| ------- | ------- | -------- | ------|
| 0.5 | 1.7.1 | 1.0-rc2 |  -           |
| 0.4 | 1.7.1 | 1.0-rc2 | moved back to 1.7.1 as it seems to be the only version to have DSDL plugin supporting Yang 1.1 |
| 0.3 | 2.0.2 | 1.0-rc2 | initial dockerized version |

The folding/unfolding script can be downloaded from https://tools.ietf.org/html/draft-ietf-netmod-artwork-folding-10.

## Thanks

Many thanks to all the design team and in particular to Carlo Perocchio.
