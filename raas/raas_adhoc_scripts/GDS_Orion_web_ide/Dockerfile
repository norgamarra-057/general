FROM alpine:3.14


RUN addgroup -S redis && adduser -S -G redis redis


RUN apk add --no-cache 'su-exec>=0.2'

ARG REDIS_VERSION="6.0.5"
ARG REDIS_DOWNLOAD_SHA="42cf86a114d2a451b898fcda96acd4d01062a7dbaaad2801d9164a36f898f596"
ARG REDIS_DOWNLOAD_URL="https://download.redis.io/releases/redis-6.0.5.tar.gz"


RUN set -ex && \
  	apk add --no-cache \
  		coreutils \
  		gcc \
      linux-headers \
  		make \
  		musl-dev \
      bash \
      supervisor \
      curl \
      git \
      vim \
      libc6-compat \
      nginx \
      libgit2-dev \
      build-base \
      zip \
      ttyd \
      cmake \
      dpkg \
      python3 \
      py-pip && \
    pip3 install --upgrade pip && \
    pip3 install --upgrade --no-cache-dir redis==3.5.3 && \
  	wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL" && \
  	echo "$REDIS_DOWNLOAD_SHA *redis.tar.gz" | sha256sum -c - && \
  	mkdir -p /usr/src/redis && \
  	tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 && \
  	rm redis.tar.gz && \

#  	grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' /usr/src/redis/src/server.h && \
#  	sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /usr/src/redis/src/server.h && \
#  	grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' /usr/src/redis/src/server.h && \
# server, [it assumes] you are going to specify everything"

  	make -C /usr/src/redis -j "$(nproc)" && \
  	make -C /usr/src/redis install && \
  	rm -r /usr/src/redis && \

    apk del libgit2-dev build-base git make gcc linux-headers musl-dev cmake

RUN mkdir -p /run/nginx && chown nginx:nginx /run/nginx && \
#    rm /etc/nginx/conf.d/default.conf && \
    chown -R nginx:nginx /var/lib/nginx && chown -R nginx:nginx /var/log/nginx
ADD entry.html /var/lib/nginx/html/

RUN mkdir /data && chown redis:redis /data
ADD nginx.conf /etc/nginx/conf.d/
ADD wait-for-it.sh /run

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

ADD supervisord.conf /etc/

RUN addgroup -S student && adduser -G student -s /bin/bash -S -h /home/student student && \
    mkdir -p /src/redisu && chown student:student /src/redisu && \
    echo 'PS1="\W$ "' >> /home/student/.bashrc
ENV HOME=/home/student
ADD .bashrc /home/student/.bashrc
#ADD .logo /home/student/.logo


ADD helloworld.py /src/redisu
RUN chown -R student:student /src/redisu

EXPOSE 8888

WORKDIR /src/redisu

CMD ["supervisord"]
