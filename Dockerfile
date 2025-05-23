FROM ruby:3.3

WORKDIR /app

COPY Gemfile* ./

RUN bundle install

COPY . .
