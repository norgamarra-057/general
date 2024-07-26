# How to use

## Setup the alerts
Set "create = true" on our three fake servers: rfake1, rfake2, mfake.
```
vi ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/redis/instances.auto.tfvars
vi ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/memcached/instances.auto.tfvars
```

Then run `terraform plan` (NOT apply). Note:
* Respond **yes** when prompted *Perform wavefront updates?*
* Do **not** git commit nor push
```
cd ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/redis/
aws-okta exec $(basename $(cd ..; pwd)|head -c3) -- terragrunt plan
cd ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/memcached/
aws-okta exec $(basename $(cd ..; pwd)|head -c3) -- terragrunt plan
```
Terraform after_hook will create alerts for these instances:
* rfake1: CPU + NIC + stale + OOM
* rfake2: CPU + NIC + stale + evictions
* mfake: stale

These are the alerts we'll test whether they go off.

## Run telegraf with the fake servers

```
cd ~/git/raas/raas_k8s
kubectl cloud-elevator auth
kubectl config use-context raas-mon-dev-us-west-2

# Create a configmap with the test telegraf configs:
kubectl delete configmap alerts-test-telegraf-conf
kubectl create configmap alerts-test-telegraf-conf --from-file=alerts-test/configs/telegraf.conf
kubectl delete configmap alerts-test-telegrafd
kubectl create configmap alerts-test-telegrafd --from-file=alerts-test/configs/telegraf.d/

# Deploy telegraf with the fake servers:
kubectl apply -f alerts-test-deployment.yml --record
```

Wait for several minutes and expect CPU, OOM, NIC, and EvictionPolicy alerts to go off from rfake1 and rfake2.
After 10 minutes one of the fake instances will stop responding and stale node alerts should go off for rfake1, rfake2 and mfake1.

**REMEMBER** to delete the deployment after the alerts go off
```
kubectl delete deployment raas-alerts-test
```

**REMEMBER** to delete the fake server alerts from wavefront:
```
cd ~/git/raas/raas_aws/terragrunt_live/
git checkout dev_stable_usw2/
cd ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/redis/
aws-okta exec $(basename $(cd ..; pwd)|head -c3) -- terragrunt plan
cd ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/memcached/
aws-okta exec $(basename $(cd ..; pwd)|head -c3) -- terragrunt plan
```

That's it! 🍻

## Troubleshooting

Links to fake server dashboards:
* [mfake](https://groupon.wavefront.com/dashboard/raas_aws_memcached#(g:(c:off,l:!t,ls:!t,w:'2h'),p:(server:'mfake-dev.*.*.usw2.cache.amazonaws.com:11211')))
* [rfake1](https://groupon.wavefront.com/dashboard/raas_aws_redis#(g:(c:off,l:!t,ls:!t,w:'2h'),p:(role:(d:master,l:role,m:(master:master,slave:slave)),server:'rfake1-dev-*.usw2.cache.amazonaws.com')))
* [rfake2](https://groupon.wavefront.com/dashboard/raas_aws_redis#(g:(c:off,l:!t,ls:!t,w:'2h'),p:(role:(d:master,l:role,m:(master:master,slave:slave)),server:'rfake2-dev-*.usw2.cache.amazonaws.com')))


Note: Above deployment deploys 3 containers in a pod. In case you need to debug a container, this is how to open a shell on a specific container running on a pod:
```
kubectl exec -it my-pod --container telegraf-raas -- /bin/bash
```

# How to create the fake servers images
**ONLY** when modifying fake server code

```
VERSION=1.0
#ENGINE=memcached
ENGINE=redis

cd ~/git/raas/raas_k8s/alerts-test/$ENGINE

# compile
GOOS=linux go build -o fake fake.go

# create docker image
docker build -t raas-fake-$ENGINE:$VERSION .
docker tag raas-fake-$ENGINE:$VERSION docker-dev.groupondev.com/raas-fake-$ENGINE:$VERSION
docker push docker-dev.groupondev.com/raas-fake-$ENGINE:$VERSION
echo image: docker-dev.groupondev.com/raas-fake-$ENGINE:$VERSION
```
