FROM cimg/php:8.2.34-node AS dockerize
ENV DOCKERIZE_VERSION v0.6.1

RUN sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

FROM cimg/php:8.2.34-node

# Build the security release until CircleCI publishes its matching image.
ENV PHP_VERSION=8.2.35
RUN set -eux; \
    curl -fsSLo /tmp/php.tar.xz "https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz"; \
    echo "5737b98601fe5ab1b8c5db0c82ed3158acb9283ed3081ffe2faffb9ac81455e6  /tmp/php.tar.xz" | sha256sum -c -; \
    tar -xJf /tmp/php.tar.xz -C /tmp; \
    cd "/tmp/php-${PHP_VERSION}"; \
    ./configure $(php-config --configure-options); \
    make -j "$(nproc)"; \
    sudo make install; \
    php --version | grep -F "PHP ${PHP_VERSION}"; \
    cd /; \
    rm -rf "/tmp/php-${PHP_VERSION}" /tmp/php.tar.xz

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize
COPY --from=cimg/node:20.19.0 /usr/local/bin/node /usr/local/bin/node
COPY --from=cimg/node:20.19.0 /usr/local/bin/node /usr/local/bin/nodejs

RUN composer --version && \
    dockerize --version && \
    sudo apt-get update -yq && \
    sudo apt-get install -yq python2 mariadb-client && \
    sudo pecl install mailparse xdebug && \
    sudo sed -i '/^zend_extension="mailparse.so"$/d' /etc/php.d/circleci.ini && \
    echo xdebug.mode=coverage | sudo tee /etc/php.d/99-xdebug.ini && \
    php -m | grep "mailparse" && \
    php -m | grep "xdebug" && \
    sudo apt-get clean
