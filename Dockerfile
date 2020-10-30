FROM cimg/php:7.4-node
ENV DOCKERIZE_VERSION v0.6.1
RUN sudo apt-get update -yq
RUN sudo apt-get install -yq php$PHP_MINOR-mailparse php$PHP_MINOR-intl php$PHP_MINOR-exif php$PHP_MINOR-bcmath && \
    sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    sudo rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
