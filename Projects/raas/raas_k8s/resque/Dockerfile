FROM ruby:2.5

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

RUN sed -i 's/<div id="main">/<p style="font-size:30px; color:yellow; background-color:tomato;">raas-team troubleshooting resque-web DO NOT USE FOR BUSINESS USE CASE<br \/><%=h Resque.redis_id%><\/p><div id="main">/' /usr/local/bundle/gems/resque-*/lib/resque/server/views/layout.erb

# open-source bugfix:
RUN sed -i 's/<%=Resque.redis_id%>/<%=h Resque.redis_id%>/' /usr/local/bundle/gems/resque-*/lib/resque/server/views/layout.erb

COPY resque_config.rb ./

CMD ["/usr/bin/tail", "-f" , "/dev/null"]
