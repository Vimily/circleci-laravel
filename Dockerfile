FROM cimg/php:7.2-node as dockerize

ENV DOCKERIZE_VERSION v0.6.1
RUN sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz 

FROM cimg/php:7.2-node
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN composer --version && \
    dockerize --version && \
    sudo apt-get update -yq && \
    sudo apt-get install -yq php$PHP_MINOR-mailparse php$PHP_MINOR-intl php$PHP_MINOR-exif php$PHP_MINOR-bcmath python python2 mariadb-client && \
    sudo apt-get clean
