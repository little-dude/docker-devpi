FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# Install ubuntu packages
RUN apt-get update -q && \
        apt-get install -y netbase python nginx && \
        rm -rf /var/lib/apt/lists/*
ADD https://raw.github.com/pypa/pip/master/contrib/get-pip.py /get-pip.py    

# Install devpi
RUN python /get-pip.py
RUN pip install "devpi-server>=2.0.6,<2.1dev" "devpi-client>=2.0.2,<2.1dev" \
        "requests>=2.4.0,<2.5"

# By default expose a data volume
VOLUME /mnt

# By default Nginx will listen on port 3141 for HTTP and 3142 on HTTPS
EXPOSE 3141
EXPOSE 3142

# devpi-server will listen on 127.0.0.1:3143 by default
EXPOSE 3143

# add nginx template file
RUN mkdir -p /opt/nginx/certs/{default,custom}
ADD nginx-tpl.conf /opt/nginx/

# For TLS, build the container with a cert and a key
ADD devpi.crt /opt/nginx/default/
ADD devpi.key /opt/nginx/default/

# Add and run script that configures and starts devpi and nginx
ADD run.sh /
CMD ["/run.sh"]
