FROM ruby:2.6-alpine

RUN apk add git build-base
RUN gem install ops_team
WORKDIR /srv

COPY . /srv
RUN ops up

CMD ops start