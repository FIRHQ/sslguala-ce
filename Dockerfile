FROM ruby:2.7.3
RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y imagemagick build-essential libpq-dev &&\
  apt-get install -y git curl htop postgresql-client vim

RUN sed -i 's#http://deb.debian.org#https://mirrors.163.com#g' /etc/apt/sources.list && \
  apt update && apt install -y curl gnupg && \
  curl -sL https://deb.nodesource.com/setup_14.x |  bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt update && apt-get install -y nodejs yarn

RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN gem install bundler rake

ENV APP_HOME /sslguala-ce
RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile Gemfile.lock $APP_HOME/
RUN bundle config set without 'development test'
RUN bundle install --jobs=20
RUN bundle exec rails assets:precompile RAILS_PRECOMPILE=1 RAILS_ENV=production SECRET_KEY_BASE=fake_secure_for_compile

COPY . $APP_HOME
# CMD ["foreman", "start"]
# docker build -t firhq/sslguala-ce:1.0 .