FROM cimg/php:8.0-node AS dockerize
ENV DOCKERIZE_VERSION v0.6.1

RUN sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

FROM cimg/php:8.0-node
COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN composer --version && \
    dockerize --version && \
    sudo apt-get update -yq && \
    sudo apt-get install -yq python python2 mariadb-client && \
    sudo pecl install mailparse && \
    php -m | grep "mailparse" && \
    sudo apt-get clean
