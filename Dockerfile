FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# Install ubuntu packages
RUN apt-get update -q && apt-get install -y netbase python nginx && rm -rf /var/lib/apt/lists/*
ADD https://raw.github.com/pypa/pip/master/contrib/get-pip.py /get-pip.py    

# Install devpi
RUN python /get-pip.py
RUN pip install "devpi-server" "devpi-client" "requests"

# By default expose a data volume
VOLUME /mnt

# By default Nginx will listen on port 3141 for HTTP and 3142 on HTTPS
EXPOSE 3141
EXPOSE 3142

# devpi-server will listen on 127.0.0.1:3143 by default
EXPOSE 3143

# Create a directory for the certificates
RUN mkdir -p /opt/nginx/certs
ADD devpi.crt devpi.key /opt/nginx/certs/

# add nginx template file
ADD nginx-tpl.conf /opt/nginx/

# Add and run script that configures and starts devpi and nginx
ADD run.sh /
CMD ["/run.sh"]
