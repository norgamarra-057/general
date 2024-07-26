source ~/git/raas-secrets/.raas_private

export RAAS_SECRETS_PATH=~/git/raas-secrets

export RUBYOPT="-KU -E utf-8:utf-8"
PS1='\e[0;32m\u@terra:$(date +"%H:%M")\e[m\w$ '

alias latest-modules='L=$(cd ~/git/raas_terraform_modules && git log --format="%H" -n 1 | head -c7); for engine in redis memcached; do sed -i "s/raas_terraform_modules.git\/\/$engine?ref=.*/raas_terraform_modules.git\/\/$engine?ref=$L\"/g" terragrunt.hcl; done'

function ta(){
  export TF_RAAS_ENV=$(basename $(cd ..; pwd)|head -c3)
  eval $(cd $RAAS_SECRETS_PATH; ruby load_passwords.rb)
  ../../../tf_beforehook/hook.rb $(pwd)
  aws-okta exec $TF_RAAS_ENV -- terragrunt apply
}
function target(){
  export TF_RAAS_ENV=$(basename $(cd ..; pwd)|head -c3)
  eval $(cd $RAAS_SECRETS_PATH; ruby load_passwords.rb)
  aws-okta exec $TF_RAAS_ENV -- terragrunt  apply \
    -target=aws_elasticache_replication_group.$1[0] \
    -target=aws_route53_record.$1_cname[0]
}

function targetmem(){
  export TF_RAAS_ENV=$(basename $(cd ..; pwd)|head -c3)
  eval $(cd $RAAS_SECRETS_PATH; ruby load_passwords.rb)
  aws-okta exec $TF_RAAS_ENV -- terragrunt  apply \
    -target=aws_elasticache_cluster.$1[0] \
    -target=aws_route53_record.$1_cname[0]
}