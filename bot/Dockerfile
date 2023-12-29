# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.1.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

ENV LANG=C.UTF-8 \
    APP_HOME=/bot \
    TZ=Asia/Tokyo \
    BUNDLE_PATH=/bundle 

WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock ./

RUN apt update -qq && \
    apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev

RUN bundle install && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . $APP_HOME
