FROM quay.io/presslabs/php-runtime:7.4 as builder

USER root
WORKDIR /app

# Install project dependencies as first build step for child images so that we
# warm up composer cache
COPY composer.json composer.lock /app/
RUN composer install --no-dev --no-interaction --no-progress --no-ansi --no-scripts --no-autoloader
COPY . /app/
RUN composer dump-autoload

# build application container
FROM quay.io/presslabs/php-runtime:7.4
COPY --from=builder --chown=www-data:www-data /app /app

ENV DOCUMENT_ROOT=/app/public
ENV LOG_CHANNEL=stderr
