FROM circleci/php:7.1-node-browsers
RUN sudo apt-get install apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    sudo apt-get update -yq && \
    sudo apt-get install -yq libpng-dev libicu-dev libjpeg62-turbo-dev yarn && \
    sudo docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ && \
    sudo docker-php-ext-install -j$(nproc) gd pcntl intl zip pdo_mysql
