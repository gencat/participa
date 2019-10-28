FROM ruby:2.5.7
MAINTAINER david.morcillo@codegram.com

ARG rails_env=production
ARG secret_key_base=

ENV APP_HOME /code
ENV RAILS_ENV $rails_env
ENV SECRET_KEY_BASE $secret_key_base

RUN apt-get update

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash && \
    apt-get install -y nodejs

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME

RUN gem install bundler -v 2.0.2
RUN bundle install

RUN bundle exec rake assets:precompile
