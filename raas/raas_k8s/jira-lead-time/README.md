# How to run
We currently run this pod in the raas-mon-dev-us-west-2 k8s context.
We run it in only **one** context, because there's just one Jira.

```
kubectl cloud-elevator auth
kubectl config use-context raas-mon-dev-us-west-2

# create k8s secret with user & password
cd ~/git/raas-secrets/
kubectl apply -f jira-k8s-secret.yml

cd ~/git/raas/raas_k8s

# Create a configmap with the telegraf config:
kubectl delete configmap jira-telegraf-conf
kubectl create configmap jira-telegraf-conf --from-file=jira-lead-time/telegraf.conf

# Deploy telegraf:
kubectl apply -f jira-lead-time-deployment.yml --record
```
