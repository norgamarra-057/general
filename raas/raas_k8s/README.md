# Overview

```
                   +---------------------------------------+
                   |                                  k8s  |
                   |                                       |
                   | +----------------+                    |
        +------------+ config updater +------+             |
        |          | +----------------+      |             |
        |          |                         |             |
        v          |                         v             |
+-------+--------+ |                  +------+-------+     |
|AWS Elasticache | |                  |telegraf raas |     |
+----------------+ +-------------------------+-------+-----+
                                             |
                                             v
                                      +------+---+
                                      |wavefront |
                                      +----------+
```

Two pods:
* telegraf-raas: daemon that gets metrics from all Elasticache instances and forwards them to Wavefront, in accordance with [Metrics in Conveyor Cloud](https://pages.github.groupondev.com/metrics/metrics-pipeline-docs/aws-k8s.html)
* config-updater: calls AWS Elasticache API every minute, if redis/memcached changes are detected:
  1. creates a new ConfigMap with the new telegraf configuration
  2. starts a new telegraf-raas Deployment with the new ConfigMap.

Note:
* Design discussion on [DATA-6255](https://jira.groupondev.com/browse/DATA-6255)
* telegraf-raas deployment keeps the old telegraf container for 3 minutes before terminating it (minReadySeconds: 180). This way, even though some minutes we'll send double metrics from two telegraf processes, we'll guarantee every minute we'll send metrics and prevent gaps on wavefront.
* If AWS API call frequency increases, communicate to the conveyor team on change. The rationale is that our account can be API rate limited if we exceed a threshold, so we need to be aware of what contributes.
* Conveyor pods can call AWS API thanks to this [PR](https://github.groupondev.com/conveyor-cloud/terra/pull/117/files)

## telegraf plugins
We use the following telegraf input plugins:
* redis & memcached: these are plugins that come with telegraf, with some some extensions (see below).
* memcached_latency & redis_latency: these are homegrown plugins that send an inexpensive request to each redis&memcached instance to measure the response time.

We use also the basicstats aggregator, so that memcached_latency, redis_latency and cpu input plugins can run every second but send aggregated metrics to wavefront every minute with just the max and mean.

# How to install config-updater

```
# make sure you have access to kubernetes environment:
$ kubectl config current-context
raas-staging-eu-west-1
$ kubectl get pod
NAME                             READY   STATUS    RESTARTS   AGE
config-updater-987894585-cjr7n   1/1     Running   0          26m
raas-shuttle-559cd6d5b6-dc6g4    1/1     Running   0          6d23h
telegraf-raas-688cb8bf4f-dwztk   1/1     Running   0          26m

# check current namespace, should be any of:
# - raas-production
# - raas-staging
kubectl config view --minify --output 'jsonpath={..namespace}'

# (only if first time install or passwords have changed)
# create secret object with bast passwords:
# dev/staging:
[~/git/raas-secrets]$ kubectl apply -f bast-k8s-secret-nonprod.yml
secret/bast configured
# prod:
[~/git/raas-secrets]$ kubectl apply -f bast-k8s-secret-prod.yml
secret/bast configured

# if above commands look fine, this is how to install:
[~/git/raas/raas_k8s/helm]$ helm install telegraf-raas ./telegraf-raas --values telegraf-raas/values.stg-euw1.yaml --values ~/git/helm-charts/common/values.yaml --values telegraf-raas/common.yml

```
Useful commands:
```
helm history telegraf-raas
# upgrade:
helm upgrade telegraf-raas ./telegraf-raas --values ~/git/helm-charts/common/values.yaml --values telegraf-raas/common.yml  --values telegraf-raas/values.stg-euw1.yaml --force
# dry-run
helm install telegraf-raas ./telegraf-raas --values ~/git/helm-charts/common/values.yaml --values telegraf-raas/common.yml  --values telegraf-raas/values.stg-euw1.yaml --debug --dry-run

# to uninstall:
helm uninstall telegraf-raas
kubectl delete deploy telegraf-raas

# check output is "yes", K8S_NS should be any of:
# - raas-production
# - raas-staging
kubectl auth can-i create configmaps --as=system:serviceaccount:$K8S_NS:config-updater
kubectl auth can-i create deployments --as=system:serviceaccount:$K8S_NS:config-updater
```

# How to build a config-updater Docker image

```
# compile
export GO111MODULE=on
export GOPATH=$(go env GOPATH)
cd $GOPATH/src/config-updater
GOOS=linux GOARCH=amd64 go build cmd/config-updater.go
# increase image's version (e.g. from v0.11 to v0.12)
cd ~/git/raas/raas_k8s/helm/telegraf-raas/templates
vi config-updater-deployment.yaml

cd ~/git/raas/raas_k8s/config-updater
VERSION=$(grep docker-dev.groupondev.com ../helm/telegraf-raas/templates/config-updater-deployment.yaml | awk -F: '{print $NF}')
echo $VERSION
docker build --platform linux/amd64 -t raas-config-updater:$VERSION .

docker tag raas-config-updater:$VERSION docker-dev.groupondev.com/raas-config-updater:$VERSION
docker push docker-dev.groupondev.com/raas-config-updater:$VERSION
```

## How to test config-updater:
```
[28-Apr 14:53][pablo:~/go/src/config-updater/test]$ ls
config-updater_test.go  k8s_test.go   testdata
[28-Apr 14:53][pablo:~/go/src/config-updater/test]$ ls testdata/
etc_bast_config.json    memcached_latency_input.conf  redis_latency_input.conf
memcached_input.conf    redis_input.conf
[28-Apr 14:53][pablo:~/go/src/config-updater/test]$ go test
PASS
ok    config-updater/test 0.199s
```

## How I created the mod file:
based on https://github.com/kubernetes/client-go/blob/master/INSTALL.md
```
export GOPATH=$(go env GOPATH)
ln -s /Users/pablo/git/raas/raas_k8s/config-updater $GOPATH/src/config-updater
cd $GOPATH/src/config-updater
export GO111MODULE=on
go mod init
go get k8s.io/client-go@kubernetes-1.15.0
```

# How to build a telegraf-raas Docker image

We use the official repo https://github.com/influxdata/telegraf

and copy&paste modifications on the redis input plugin, based on https://github.com/influxdata/telegraf/pull/2902/

and two raas plugins:
- plugins/inputs/redis_latency
- plugins/inputs/memcached_latency

## prepare the telegraf directory
```
cd ~/git
git clone https://github.com/influxdata/telegraf.git
cd telegraf
# checkout the latest: https://github.com/influxdata/telegraf/tags
git co v1.23.0
cd plugins/inputs/
find * \
-not -path "registry.go" \
-not -path "deprecations.go" \
-not -path "cloudwatch/*" \
-not -path "internal/*" \
-not -path "procstat/*" \
-not -path "snmp/*" \
-delete
cp -r ~/git/telegraf-raas/plugins/inputs/all .
cp -r ~/git/telegraf-raas/plugins/inputs/memcached .
cp -r ~/git/telegraf-raas/plugins/inputs/memcached_latency .
cp -r ~/git/telegraf-raas/plugins/inputs/redis .
cp -r ~/git/telegraf-raas/plugins/inputs/redis_latency .
cd ../outputs
find * \
-not -path "registry.go" \
-not -path "deprecations.go" \
-not -path "file/*" \
-not -path "influxdb/*" \
-not -path "wavefront/*" \
-delete
cp -r ~/git/telegraf-raas/plugins/outputs/all .
```

## make:

```
cd ~git/telegraf/
go get github.com/montanaflynn/stats
go get go.uber.org/zap
go get gopkg.in/natefinch/lumberjack.v2
GOOS=linux GOARCH=amd64 make
```

## How to test redis plugin without integration test:
```
cd ~/git/telegraf/plugins/inputs/redis/
go test -short
```

## Create a telegraf-raas Docker image:
```
cd ~/git/telegraf/
mkdir tmp && cd tmp
mv ../telegraf .
cp ~/git/telegraf-raas/Dockerfile .

# increase the image version, for example from v1.41 to v1.42
vi ~/git/raas/raas_k8s/helm/telegraf-raas/templates/_telegraf-raas-deployment.yml
# get the tag
TAG=$(grep docker-dev.groupondev.com ~/git/raas/raas_k8s/helm/telegraf-raas/templates/_telegraf-raas-deployment.yml | awk '{print $2}')
echo $TAG

docker build --platform linux/amd64 -t $TAG .
# Push image to Groupon's registry (in order to make it available in Conveyor):
docker push $TAG
```

# raas-shuttle
raas-shuttle is a kubernetes pod we can use to do debugging of Elasticache instances. Details on [DATA-6705](https://jira.groupondev.com/browse/DATA-6705)

## How to create a raas-shuttle docker image
```
cd ~/git/raas/raas_k8s/raas-shuttle
VERSION=$(grep docker-dev.groupondev.com ../raas-shuttle-deployment.yml | awk -F: '{print $NF}')
echo $VERSION
docker build --platform linux/amd64 -t raas-shuttle:$VERSION .
############
# just if you want to test locally:
docker run -d --name raas-shuttle raas-shuttle:$VERSION
docker exec -it raas-shuttle bash
############
docker tag raas-shuttle:$VERSION docker-dev.groupondev.com/raas-shuttle:$VERSION
docker push docker-dev.groupondev.com/raas-shuttle:$VERSION
```

## How to deploy a raas-shuttle container

```
cd ~/git/raas/raas_k8s/
kubectl apply -f raas-shuttle-deployment.yml --record
# remember to delete it after debugging
kubectl delete deployment raas-shuttle
```

# resque
kubernetes pod with resque software installed
## How to create a resque docker image
```
# based on https://hub.docker.com/_/ruby/
cd ~/git/raas/raas_k8s/resque
VERSION=$(grep docker.groupondev.com ../resque-deployment.yml | awk -F: '{print $NF}')
echo $VERSION
docker build --platform linux/amd64 -t raas-resque:$VERSION .
docker tag raas-resque:$VERSION docker.groupondev.com/raas-resque:$VERSION
docker push docker.groupondev.com/raas-resque:$VERSION
```

## How to deploy a resque container

https://confluence.groupondev.com/display/RED/Cloud+FAQ#CloudFAQ-ResqueWebUI


# redisinsight

How to deploy: read raas manual

How to upgrade docker image:
```
# latest version here: https://hub.docker.com/r/redislabs/redisinsight/tags
V=1.11.1

# pull the latest image
docker pull redislabs/redisinsight:$V

# push to groupon artifactory
TAG=$(docker image list  | grep 'redislabs/redisinsight' | grep $V | awk '{ print $3 }')
echo $TAG
docker tag $TAG docker.groupondev.com/redisinsight:$V
docker push docker.groupondev.com/redisinsight:$V

# update the version:
vi ~/git/raas/raas_k8s/redisinsight_deployment.yaml
```

# How to create a raas tenant on RDE

Rapid Development Environment (RDE): https://pages.github.groupondev.com/production-fabric/cloud-docs/conveyor_cloud/rde.html

On "Tenant Creation" I used this file:
```
[22-Jan 12:28][pablo:~/git/raas/raas_k8s]$ cat ~/Downloads/tenant.yml
apiVersion: conveyor.groupon.com/v1
kind: Tenant
metadata:
  name: raas-rapid
spec:
  selector:
    matchLabels:
      com.groupon.conveyor/tenant: raas-rapid
  template:
    limitRange:
      limits: null
    resourceQuota: {}
    subjects:
      Users:
        okta:pablo: 0
```
