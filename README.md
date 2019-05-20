# README

## toc
  * [api specification](#api-specification)
  * [how to build](#how-to-build)
    * [for development](#for-development)
    * [for production](#for-production) 


## api specification
  * [v1](https://github.com/t-sweets/pos/wiki/v1)

## how to build
### for development
```bash
  $ docker-compose build
  $ docker-compose run pos bundle exec rails db:drop db:create db:migrate db:seed
  $ docker-compose up -d
```

### for production
```bash
  $ docker-compose -f docker-compose.production.yml build
  $ docker-compose -f docker-compose.production.yml run pos bundle exec rails db:drop db:create db:migrate RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1
  $ docker-compose -f docker-compose.production.yml run pos bundle exec rails r db/prd.seeds.rb
  $ docker-compose -f docker-compose.production.yml up -d
```

## testing
```bash
  $ docker-compose run pos bundle exec rails test
```
