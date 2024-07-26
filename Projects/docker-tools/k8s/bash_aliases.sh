PS1='\e[0;32m\u@k8s:$(date +"%H:%M")\e[m\w$ '

alias k="kubectl"
alias kl="kubectl logs -f --tail=20"
alias kc="kubectl config get-contexts"
alias kcu="kubectl config current-context"
alias ka="kubectl cloud-elevator auth"
alias ku="kubectl config use-context"
alias ku1d="kubectl config use-context raas-dev-us-west-1"
alias ku1="kubectl config use-context raas-staging-us-west-1"
alias ku2d="kubectl config use-context raas-dev-us-west-2"
alias ku2="kubectl config use-context raas-staging-us-west-2"
alias ku3d="kubectl config use-context raas-dev-eu-west-1"
alias ku3="kubectl config use-context raas-staging-eu-west-1"
alias ku4="kubectl config use-context raas-production-us-west-1"
alias ku5="kubectl config use-context raas-production-us-west-2"
alias ku6="kubectl config use-context raas-production-eu-west-1"
alias kp="kubectl get pod"
alias rapid="kubectl config use-context rapid-us-west-2; kubectl config set-context --current --namespace=raas-rapid-dev; echo current namespace:; kubectl config view --minify --output 'jsonpath={..namespace}'; echo"
alias shuttle='kb $(kp | grep shuttle | grep Running | cut -d" " -f1)'
alias helmu='D=$(ls); helm upgrade $D ./$D --values $D/values.$(kubectl config current-context).yaml --values ~/git/helm-charts/common/values.yaml --values $D/common.yml'

function kb(){
  if [ $# -lt 2 ]; then
    kubectl exec -it $1 -- bash
  else
    kubectl exec -it $1 --container $2 -- bash
  fi
}
