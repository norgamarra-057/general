# Run a failover-timer container
```
cd ~/git/raas/raas_k8s
kubectl cloud-elevator auth
kubectl config use-context raas-mon-dev-us-west-2

# Choose a redis to test, edit the ENDPOINT environment variable:
vi failover-timer-redis-deployment.yml

# Deploy telegraf with the fake servers:
kubectl apply -f failover-timer-redis-deployment.yml

# Tail logs
kubectl logs -f --tail=20 failover-timer-redis-84d4475bf4-rnbm2
```

Using the AWS Console, force a redis failover and watch the logs

**REMEMBER** to delete the deployment after the alerts go off
```
kubectl delete deployment failover-timer-redis
```


# How to create docker image
```
VERSION=v1.0.6
docker build -t raas-redis-failure-observer:$VERSION .
docker tag raas-redis-failure-observer:$VERSION docker-dev.groupondev.com/raas-redis-failure-observer:$VERSION
docker push docker-dev.groupondev.com/raas-redis-failure-observer:$VERSION
```
