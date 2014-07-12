FROM google/debian:wheezy

# Install Nginx.
RUN apt-get update
RUN apt-get install -y python-software-properties wget
RUN add-apt-repository 'deb http://nginx.org/packages/debian/ wheezy nginx'
RUN wget -q http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key

RUN apt-get update
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# fix for long server names
RUN sed -i 's/# server_names_hash_bucket/server_names_hash_bucket/g' /etc/nginx/nginx.conf

RUN mkdir /app
WORKDIR /app
ADD . /app

RUN wget -q -P /usr/local/bin https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego
RUN chmod u+x /usr/local/bin/forego

RUN wget -q https://github.com/jwilder/docker-gen/releases/download/0.3.0/docker-gen-linux-amd64-0.3.0.tar.gz
RUN tar xvzf docker-gen-linux-amd64-0.3.0.tar.gz

EXPOSE 80
ENV DOCKER_HOST unix:///tmp/docker.sock

CMD ["forego", "start", "-r"]
