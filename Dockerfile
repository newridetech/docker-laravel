FROM newridetech/php:7.2-fpm

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ansible && \
    mkdir /tmp/docker-php-nginx

COPY ansible /tmp/docker-php-nginx
COPY etc/nginx/sites-enabled/default.conf /tmp/docker-php-nginx/default.conf

WORKDIR /tmp/docker-php-nginx

RUN DEBIAN_FRONTEND=noninteractive ansible-playbook -i "localhost," -c local playbook.yml && \
    DEBIAN_FRONTEND=noninteractive apt-get -y remove ansible && \
    rm -rf /tmp/docker-php-nginx

EXPOSE 443 80
