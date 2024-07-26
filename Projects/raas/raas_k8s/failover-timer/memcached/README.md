
# How to create docker image
```
VERSION=v1.0.8
docker build -t raas-memcached-failure-observer:$VERSION .
docker tag raas-memcached-failure-observer:$VERSION docker-dev.groupondev.com/raas-memcached-failure-observer:$VERSION
docker push docker-dev.groupondev.com/raas-memcached-failure-observer:$VERSION
```
