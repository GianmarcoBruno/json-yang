# json-yang

A standalone tool to validate instances in JSON format of YANG models.

## Why

The need for some automated tool was expressed in the IETF CCAMP Transport
NBI Design Team (https://github.com/danielkinguk/transport-nbi).

## Getting started

See `validation.md` for a description of the process.

Starting from version `0.3` you can build from scratch the tool on Linux:  

- `bash 4.3.11`
- `python 3`
- `pyang 2.0.2`
- `jing 20131210`
- `xmllint`
- `rfcstrip 0.2` patched to accept `-f`
- `yanglint` v1.0-rc2
- `perl 5.18` or later and also the JSON module  
  `sudo apt-get install libjson-perl` and
  `sudo apt-get install libfile-slurp-perl`

or just use the dockerized version:  
```
docker build -t yl:<version>
docker run -it --rm --mount type=bind,source="$(pwd)",target=/home/app jy:0.4 ...
```

It is convenient to add this function to your startup file:
```
function validate() {
    docker run --rm -it --mount type=bind,source="$(pwd)",target=/home/app jy:<YOUR-DESIRED-VERSION> "$@"
}
```


## Versions

| version | pyang   | yanglint | notes |
| ------- | ------- | -------- | ------|
| 0.5 | 1.7.1 | 1.0-rc2 |  -           |
| 0.4 | 1.7.1 | 1.0-rc2 | moved back to 1.7.1 as it seems to be the only version to have DSDL plugin supporting Yang 1.1 |
| 0.3 | 2.0.2 | 1.0-rc2 | initial dockerized version |

The folding/unfolding script can be downloaded from https://tools.ietf.org/html/draft-ietf-netmod-artwork-folding-10.

## Thanks

Many thanks to all the design team and in particular to Carlo Perocchio.
