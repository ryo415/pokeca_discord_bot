# Dockerfileを元にイメージを構築
ARG RUBY_VERSION=3.1.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

ENV LANG=C.UTF-8 \
    APP_HOME=/app \
    TZ=Asia/Tokyo \
    BUNDLE_PATH=/bundle 

FROM base as build

WORKDIR $APP_HOME

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y \
    git \
    libvips \
    pkg-config \
    build-essential \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm6 \
    libgdbm-dev

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

RUN bundle install

COPY . .

FROM base

WORKDIR $APP_HOME

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libsqlite3-0 \
    libvips \
    vim \
    cron \
    libvips \
    build-essential \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm6 \
    libgdbm-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /bundle /bundle
COPY --from=build $APP_HOME $APP_HOME
