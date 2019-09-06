FROM circleci/php:7.2-node-browsers
ENV DOCKERIZE_VERSION v0.6.1
ENV PHP_INI_DIR /usr/local/etc/php
RUN sudo apt-get install apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    sudo apt-get update -yq && \
    sudo apt-get install -yq libpng-dev libicu-dev libjpeg62-turbo-dev yarn && \
    sudo echo pecl config-set php_ini "${PHP_INI_DIR}/php.ini" && \
    sudo pecl install mailparse && \
    sudo docker-php-ext-enable mailparse && \
    sudo docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ && \
    sudo docker-php-ext-install -j$(nproc) gd pcntl intl pdo_mysql exif bcmath && \
    sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
