#!/usr/bin/env bash


mypwd=`pwd`

if (($# == 0));
then
cat <<EOT

# Usage:
#<scriptname>             <dbname>

EOT
exit 1
fi


cd ~/git/raas/raas_aws/terragrunt_live/stg_stable_usw1/redis
export TF_RAAS_ENV=$(basename $(cd ..; pwd)|head -c3);
eval $(cd /Users/ksatyamurthy/github_projects/raas-secrets; ruby load_passwords.rb)
../../../tf_beforehook/hook.rb ~/git/raas/raas_aws/terragrunt_live/stg_stable_usw1/redis

python3 ~/git/raas/raas_adhoc_scripts/remove_ha/remove_ha.py --dbname $1 

cd $mypwd
