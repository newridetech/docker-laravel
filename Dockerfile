FROM newridetech/php:7.2-fpm

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get install -y ansible openssl && \
    mkdir /tmp/docker-php-nginx

COPY ansible /tmp/docker-php-nginx
COPY etc/nginx/sites-enabled/default.conf /tmp/docker-php-nginx/default.conf
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

WORKDIR /tmp/docker-php-nginx

RUN DEBIAN_FRONTEND=noninteractive ansible-playbook -i "localhost," -c local playbook.yml && \
    DEBIAN_FRONTEND=noninteractive apt-get -y remove ansible && \
    rm -rf /tmp/docker-php-nginx && \
    DEBIAN_FRONTEND=noninteractive apt-get -y autoremove

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 443 80

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD service php7.2-fpm start && nginx -g 'daemon off;'