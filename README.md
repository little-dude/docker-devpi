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

#### Use HTTPS

If `NGINX_ENABLETLS` environment variable is set to true, nginx will be
configured to use TLS.  By default it listens on `0.0.0.0:3141` but this is
configurable via `NGINX_IP` and `NGINX_TLSPORT`. 

This image comes with a self signed certificate, but it is recommended that you
use your own certificate. To do so, you can either re-build the container with
your own certificates (see the Dockerfile), or mount the ceertificate and its
key when you start the container. Nginx expects users certificate and
its key to be located in `/opt/nginx/certs/custom/devpi.crt` and
`/opt/nginx/certs/custom/devpi.key`. So after generating `devpi.crt` and `devpi.key`,
one can start the container with :

```
$ cat env_file.txt
# nginx will listen on every interface
NGINX_IP=0.0.0.0
# port for http
NGINX_PORT=3141
# https configuration
NGINX_ENABLETLS=true
NGINX_TLSPORT=3142
NGINX_TLSPATH=/opt/nginx/certs/custom
NGINX_TLSCERT=cert.crt
NGINX_TLSKEY=certKey.key

$ docker run  -d --name devpi -p 3141:3141 -p 3142:3142 --env-file=env_file.txt -v /path/to/certs:/opt/nginx/certs/custom scrapinghub/devpi
```
