FROM cimg/php:7.4-node AS composer

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

FROM cimg/php:7.4-node AS dockerize
ENV DOCKERIZE_VERSION v0.6.1

RUN sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

FROM cimg/php:7.4-node
COPY --from=composer /usr/local/bin/composer /usr/local/bin/composer
COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN sudo apt-get update -yq && \
    sudo apt-get install -yq php$PHP_MINOR-mailparse php$PHP_MINOR-intl php$PHP_MINOR-exif php$PHP_MINOR-bcmath python python2 && \
    sudo apt-get clean
