## Devpi Dockerfile


This repository contains **Dockerfile** of [Devpi](http://doc.devpi.net/) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/scrapinghub/devpi/) published to the public [Docker Registry](https://index.docker.io/).


### Dependencies

* [dockerfile/ubuntu](http://dockerfile.github.io/#/ubuntu)


### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/scrapinghub/devpi/) from public [Docker Registry](https://index.docker.io/): `docker pull scrapinghub/devpi`

   (alternatively, you can build an image from Dockerfile: `docker build -t="scrapinghub/devpi" github.com/scrapinghub/docker-devpi`)


### Usage

#### Run `devpi-server`

    docker run -d --name devpi -p 3141:3141 scrapinghub/devpi

Devpi creates a user named `root` by default, its password can be set with
`DEVPI_PASSWORD` environment variable.

For more options, you can use an environment file, like `devpi-nginx.env`.

    docker run --name devpi -p 3141:3141 -p 3142:3142 --env-file devpi-nginx.env  -v /abspath/to/certs/dir:/opt/nginx/certs devpi

### Notes:

 - HTTPS does not work for the moment
 - Container is built with default empty keys. Generate real ones (you may use the create_keys.sh script for that).
