FROM ruby:2.6.6-buster

WORKDIR /app

RUN bundle install
CMD bundle exec rails console
