FROM node:lts-alpine3.12

WORKDIR /app
RUN apk add --no-cache --virtual .build-deps git \
    && npm init --yes \
    && npm install zenn-cli \
    && npx zenn init \
    && apk del .build-deps
COPY articles articles
COPY books books

ENTRYPOINT ["npx", "zenn", "preview"]