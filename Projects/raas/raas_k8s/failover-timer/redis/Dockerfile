FROM ruby:2.5-alpine

COPY Gemfile ./
RUN bundle install

COPY test.rb /

CMD ["/usr/local/bin/ruby", "/test.rb"]
