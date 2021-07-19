FROM ruby:2.7.3
RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y nodejs imagemagick build-essential libpq-dev &&\
  apt-get install -y git curl htop postgresql-client vim

RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN gem install bundler rake

ENV APP_HOME /sslguala-ce
RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile Gemfile.lock $APP_HOME/
RUN bundle config set without 'development test'
RUN bundle install --jobs=20

COPY . $APP_HOME
RUN bundle exec rake assets:precompile RAILS_ENV=production

# CMD ["foreman", "start"]
# docker build -t sslguala-ce .