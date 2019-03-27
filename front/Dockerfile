FROM node:8.11.3-alpine

ENV APP_ROOT /app
WORKDIR $APP_ROOT

RUN apk update && \
    apk add git && \
    npm install -g npm && \
    npm install -g vue-cli

COPY package.json $APP_ROOT
COPY package-lock.json $APP_ROOT

RUN npm install && \
    npm cache verify

ENV HOST 0.0.0.0
EXPOSE 13000