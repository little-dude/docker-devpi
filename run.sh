#!/bin/bash
set -e
set -x

# Default environment if none is provided
: ${DEVPI_SERVERIP:=127.0.0.1}
: ${DEVPI_SERVERPORT:=3143}
: ${DEVPI_SERVERDIR:=/mnt}
: ${DEVPI_CLIENTDIR:=/tmp/devpi-client}
: ${DEVPI_CLIENTPASSWORD:=""}
: ${DEVPI_LDAPCONFILE:=""}

: ${NGINX_IP:=0.0.0.0}
: ${NGINX_PORT:=3141}
: ${NGINX_TLS_PORT:=3142}
: ${NGINX_TLS_PATH:=/opt/nginx/certs}
: ${NGINX_TLS_CERT:=devpi.crt}
: ${NGINX_TLS_KEY:=devpi.key}
export DEVPI_SERVERIP DEVPI_SERVERPORT DEVPI_SERVERDIR DEVPI_CLIENTDIR DEVPI_CLIENTPASSWORD DEVPI_LDAPCONFILE NGINX_IP NGINX_PORT NGINX_TLS_PATH NGINX_TLS_CERT NGINX_TLS_PORT NGINX_TLS_KEY

function start_devpi_server () {
    # Start the server
    devpi-server --start --host ${DEVPI_SERVERIP} --port ${DEVPI_SERVERPORT} &> stdout
    
    # Configure the default client if necessary
    if [[ ! -f ${DEVPI_SERVERDIR}/.serverversion ]]; then
      devpi use http://${DEVPI_SERVERIP}:${DEVPI_SERVERPORT}
      devpi login root --password=""
      devpi user -m root password="${DEVPI_CLIENTPASSWORD}"
      devpi index -y -c public pypi_whitelist='*'
    fi
}

function start_nginx () {
    nginx_template_file=/opt/nginx/nginx-tpl.conf

    # Escape all \ & and / for every variable of the current env, and replace all
    # ${var} occurences in nginx conf template file with the corresponding variable
    # value
    env | sed 's/[\%]/\\&/g;s/\([^=]*\)=\(.*\)/s%${\1}%\2%/' | sed -f- ${nginx_template_file} | tee /tmp/nginx.conf    

    
    # forward nginx logs to stdout and stderr 
    ln -sf /dev/stdout /var/log/nginx/access.log
    ln -sf /dev/stderr /var/log/nginx/error.log

    # Start nginx
    nginx -c /tmp/nginx.conf > /dev/null
}

start_devpi_server
start_nginx
