FROM newridetech/php:7.2-fpm

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ansible && \
    mkdir /tmp/docker-php-nginx

COPY playbook.yml /tmp/docker-php-nginx/playbook.yml
COPY requirements.yml /tmp/docker-php-nginx/requirements.yml
COPY etc/nginx/sites-enabled/default.conf /tmp/docker-php-nginx/default.conf

WORKDIR /tmp/docker-php-nginx

RUN DEBIAN_FRONTEND=noninteractive ansible-galaxy install -r requirements.yml && \
    DEBIAN_FRONTEND=noninteractive ansible-playbook -i "localhost," -c local playbook.yml

EXPOSE 443 80
