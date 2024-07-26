FROM ubuntu:impish-20220404

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  curl \
  less \
  ruby \
  unzip \
  vim \
  wget \
  ncat \
  telnet \
  dnsutils \
  net-tools \
# python3-pip \
  gnupg \
  lsb-release \
  socat \
  && rm -rf /var/lib/apt/lists/*

#######################################
# Tooling
#######################################

RUN gem install redis -v 4.6.0

# RUN pip install rdbtools python-lzf

# redis-cli
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list
RUN apt-get update && apt-get install redis -y && rm -rf /var/lib/apt/lists/*

COPY ./redis_slowlog.rb /

CMD ["/usr/bin/tail", "-f" , "/dev/null"]
