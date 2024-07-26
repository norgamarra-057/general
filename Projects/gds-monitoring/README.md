Monitoring software design based on https://github.groupondev.com/data/raas/tree/master/raas_k8s/

# How to deploy telegraf-daas along with its config-updater in Conveyor
```
# make sure you have access to kubernetes environment:
kubectl config current-context
 daas-mysql-staging-us-west-1

kubectl get pod
  No resources found in daas-mysql-staging namespace.

# Create a secrets file with the monitoring password:
$ cat secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: bast
type: Opaque
stringData:
  config.json: |-
    {
    "mon-password": "xxxx"
    }
$ kubectl apply -f secret.yaml

# check current namespace, should be any of:
# - daas-mysql-production
# - daas-mysql-staging
kubectl config view --minify --output 'jsonpath={..namespace}'

# if above commands look fine, this is how to install:
cd ~/git/gds-monitoring/helm
helm install telegraf-daas ./telegraf-daas --values telegraf-daas/values.rapid-us-west-2.yaml --values ~/git/helm-charts/common/values.yaml --values telegraf-daas/common.yml

```
Useful commands:
```
helm history telegraf-daas
# upgrade:
helm upgrade telegraf-daas ./telegraf-daas --values telegraf-daas/values.rapid-us-west-2.yaml --values ~/git/helm-charts/common/values.yaml --values telegraf-daas/common.yml

# to uninstall:
helm uninstall telegraf-daas
kubectl delete deploy telegraf-daas

# check output is "yes", K8S_NS should be any of:
# - daas-mon-production
# - daas-mon-rapid-dev
# - daas-mon-staging
kubectl auth can-i create configmaps --as=system:serviceaccount:$K8S_NS:config-updater
kubectl auth can-i create deployments --as=system:serviceaccount:$K8S_NS:config-updater

```

# How to build a new config-updater Docker image
```
cd ~/git/gds-monitoring/config-updater
GOOS=linux go build cmd/config-updater.go

# increase image's version (e.g. from v1.0 to v1.1)
grep image ../helm/telegraf-daas/templates/config-updater-deployment.yaml
  image: docker.groupondev.com/daas-config-updater:v1.13

VERSION=$(grep docker.groupondev.com ../helm/telegraf-daas/templates/config-updater-deployment.yaml | awk -F: '{print $NF}')
echo $VERSION
docker build -t daas-config-updater:$VERSION .

docker tag daas-config-updater:$VERSION docker.groupondev.com/daas-config-updater:$VERSION
docker push docker.groupondev.com/daas-config-updater:$VERSION

```

# How to build a new telegraf-daas Docker image

We take the original Telegraf and remove all plugins except the MySQL plugin to make it faster to compile, lighter, and quicker to upload.

## Clone and prune
```
cd ~/git
rm -fr telegraf
git clone https://github.com/influxdata/telegraf.git
cd telegraf
# know the latest version:
git describe --tags $(git rev-list --tags --max-count=1)
# or from https://github.com/influxdata/telegraf/tags
# check it out, example:
git co v1.22.4
cd plugins/inputs/
find * \
-not -path "registry.go" \
-not -path "deprecations.go" \
-not -path "cloudwatch/*" \
-not -path "internal/*" \
-not -path "mysql/*" \
-not -path "postgresql/*" \
-not -path "postgresql_extensible/*" \
-not -path "procstat/*" \
-not -path "snmp/*" \
-delete
cp -r ~/git/gds-monitoring/telegraf/plugins/inputs/all .
############# PATCHES ###############
ID=~/git/gds-monitoring/telegraf/plugins/inputs
cp $ID/mysql/mysql.go mysql/
cp $ID/postgresql/postgresql.go postgresql/
cp $ID/postgresql/service.go postgresql/
cp $ID/postgresql_extensible/postgresql_extensible.go postgresql_extensible/
#####################################
cd ../outputs
find * \
-not -path "registry.go" \
-not -path "deprecations.go" \
-not -path "file/*" \
-not -path "influxdb/*" \
-not -path "wavefront/*" \
-delete
cp -r ~/git/gds-monitoring/telegraf/plugins/outputs/all .
```

## Compile

You'll need Docker: https://www.docker.com/products/docker-desktop

Verify you've installed "dep", if not:
```
brew install dep
```
Compile
```
cd ~/git/telegraf/

# make for macOS:
make

# make (on macOS) for Linux:
# GOOS=linux GOARCH=amd64 make

# test the MySQL plugin (remember to first compile for Linux):
# make plugin-mysql

```

## Create a telegraf-daas Docker image:
```
cd ~/git/telegraf/
# I don't know why they removed these "make docker-image"'s dependency files:
OLD_COMMIT_URL=https://raw.githubusercontent.com/influxdata/telegraf/ecd4d3782c4ad16baf546cfbf5f287fce234c4e1
wget $OLD_COMMIT_URL/scripts/buster.docker -O scripts/buster.docker
wget $OLD_COMMIT_URL/scripts/docker-entrypoint.sh -O scripts/docker-entrypoint.sh
make docker-image
...
 => => naming to docker.io/library/telegraf:61c3a7e6
```
Push image to Groupon's registry to make it available in Conveyor:
```
# push the new image
TAG=docker.groupondev.com/telegraf-daas:v1.10
# use the same tag of the build above:
docker tag telegraf:61c3a7e6 $TAG
docker push $TAG
```