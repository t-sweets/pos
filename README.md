# README

## toc
  * [api specification](#api-specification)
  * [how to build](#how-to-build)


## api specification
  * [v1](https://github.com/t-sweets/pos/wiki/v1)

## how to build
  ```shell
    $ docker-compose build
    $ docker-compose run pos bundle exec rails db:drop db:create db:migrate db:seed
    $ docker-compose up
  ```
