FROM cimg/php:8.0-node AS dockerize
ENV DOCKERIZE_VERSION v0.6.1

RUN sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

FROM cimg/php:8.0-node

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize
COPY --from=cimg/node:14.18 /usr/local/bin/node /usr/local/bin/node
COPY --from=cimg/node:14.18 /usr/local/bin/node /usr/local/bin/nodejs

RUN composer --version && \
    dockerize --version && \
    sudo apt-get update -yq && \
    sudo apt-get install -yq python python2 mariadb-client && \
    sudo pecl install mailparse xdebug && \
    echo xdebug.mode=coverage | sudo tee /etc/php.d/99-xdebug.ini && \
    php -m | grep "mailparse" && \
    php -m | grep "xdebug" && \
    sudo apt-get clean
