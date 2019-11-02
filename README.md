# json-yang

A standalone tool to validate instances in JSON format of YANG models.

## Why

The need for some automated tool was expressed in the IETF CCAMP Transport
NBI Design Team (https://github.com/danielkinguk/transport-nbi).
How the toolchain is designed is described in `toolchain.md`.  
Details on the validation process can be found in `validation.md`

## Docker installation (preferred)

The preferred way is to build and use the docker image - currently tested only on Linux.  
```
docker build . -t yl:<version>
```

Then add this function to your ```.bashrc```:

```
function validate() {
    docker run --rm -it --mount type=bind,source="$(pwd)",target=/home/app jy:<version> "$@"
}
```

Now you can use the containerized tool as just ```validate```.
**Note**: do not specify the path because this is actually a function call.

### Installation from source

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

## Versions

| version | pyang   | yanglint | notes |
| ------- | ------- | -------- | ------|
| 0.7 | 1.7.1 | 1.0-rc2 | distinct "downloads", "models" and "target" directories |
| 0.6 | 1.7.1 | 1.0-rc2 | reduced images size from 1.46G to 248M -  only 69M on top of the base image |
| 0.5 | 1.7.1 | 1.0-rc2 |  -           |
| 0.4 | 1.7.1 | 1.0-rc2 | moved back to 1.7.1 as it seems to be the only version to have DSDL plugin supporting Yang 1.1 |
| 0.3 | 2.0.2 | 1.0-rc2 | initial dockerized version |

The folding/unfolding script can be downloaded from https://tools.ietf.org/html/draft-ietf-netmod-artwork-folding-10.

## Thanks

Many thanks to all the design team and in particular to Carlo Perocchio.
