FROM cimg/php:7.4-node AS composer

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV DOCKERIZE_VERSION v0.6.1
RUN sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN sudo apt-get update -yq && \
    sudo apt-get install -yq php$PHP_MINOR-mailparse php$PHP_MINOR-intl php$PHP_MINOR-exif php$PHP_MINOR-bcmath python python2 mariadb-client && \
    sudo apt-get clean
