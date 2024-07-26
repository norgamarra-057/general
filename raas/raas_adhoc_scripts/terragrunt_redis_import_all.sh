terragrunt_redis_import_all () {

# Helps bring unmanaged resources from aws to terraform state files.
# You can run this script when your terraform provisioning fails in the middle and the state files are not updated properly.
# 

local TF_RAAS_ENV=$(basename $(cd ..; pwd)|head -c3);
local hosted_zone_id=""
local region=""
local filter1=""

TF_RAAS_ENV=$(basename $(cd ..; pwd)|head -c3);
hosted_zone_id=""
region=""
filter1=""
# ~/github_projects/raas/raas_aws/terragrunt_live/prd_usw2/redis

env0=`pwd | rev | awk -F/ '{ print $2 }' | rev `
env1=`pwd | rev | awk -F/ '{ print $2 }' | rev | awk -F_ '{ print $1 }'`
reg1=`pwd | rev | awk -F/ '{ print $2 }' | rev | awk -F_ '{ print $NF }'`

if [ "$env1" == "prd" ]; then
    filter1="prod"   
elif [ "$env1" == "stg" ]; then
    filter1="staging"
elif [ "$env1" == "dev" ]; then
    filter1="dev"
fi 

if [ "$reg1" == "usw1" ]; then
    region="us-west-1"   
elif [ "$reg1" == "usw2" ]; then
    region="us-west-2"
elif [ "$reg1" == "euw1" ]; then
    region="eu-west-1"
fi 



if [ "$env0" == "dev_stable_euw1" ]; then
    hosted_zone_id="Z2NXVLBZ6ROXR1"      # done 
elif [ "$env0" == "dev_stable_usw1" ]; then
    hosted_zone_id="Z18OUOE2EE6HM4"      # done
elif [ "$env0" == "dev_stable_usw2" ]; then
    hosted_zone_id="Z24SYDWX2RX5DB"      # done
elif [ "$env0" == "prd_euw1" ]; then
    hosted_zone_id="Z1H3C0GFLBTSE2"      # done
elif [ "$env0" == "prd_usw1" ]; then      
    hosted_zone_id="Z149J4JE6N1OEF"      # done
elif [ "$env0" == "prd_usw2" ]; then
    hosted_zone_id="Z44QSCLVUU9XB"       # done
elif [ "$env0" == "stg_stable_euw1" ]; then     
    hosted_zone_id="Z2NXVLBZ6ROXR1"      # done
elif [ "$env0" == "stg_stable_usw1" ]; then  
    hosted_zone_id="Z18OUOE2EE6HM4"      # done
elif [ "$env0" == "stg_stable_usw2" ]; then  
    hosted_zone_id="Z24SYDWX2RX5DB"      # done
fi 

import_cname() {
dbname=$1
echo "aws-okta exec $TF_RAAS_ENV -- terragrunt import aws_route53_record.${dbname}_cname[0] ${hosted_zone_id}_${dbname}--redis.${filter1}_CNAME"
}

import_ec() {
dbname=$1
echo "aws-okta exec $TF_RAAS_ENV -- terragrunt import aws_elasticache_replication_group.${dbname}[0] ${dbname}-${filter1}"
}

echo "#"
echo "# Execute the below commands to fix the state files"
echo "#"
echo "# make sure to run 'terragrunt apply' and make sure all look OK."
echo 

echo "cname" > infra_cname.csv
aws-okta exec $TF_RAAS_ENV -- aws route53 list-resource-record-sets --hosted-zone-id ${hosted_zone_id} | jq '.ResourceRecordSets | .[] | .Name'  | grep redis | tr -d '"' | sed -e 's/--redis.*//' | sort | uniq | sort  >> infra_cname.csv

echo "cname" > state_cname.csv
aws-okta exec $TF_RAAS_ENV -- terragrunt state list 2>/dev/null | grep -e aws_route53_record | sed -e 's/aws_route53_record\.//' -e 's/\[0\]//' -e 's/_cname//' | sort | uniq                                            >> state_cname.csv

sqlite3 > route53.txt <<EOT
.mode csv
.import infra_cname.csv infra_cname
.import state_cname.csv state_cname 
select a.* from (
select cname from infra_cname 
where cname not in('badges-service-cloud','layout-service-templates','optimize-uniques','placereadservice','rapi-rt-cloud-deal-show','relevance-cloud-rapi-pagination')
except 
select cname from state_cname) a
--where a.cname like '%payload%'
;
EOT

# find missing CNAME
for x in `cat route53.txt`
do 
import_cname $x
done 

echo 
echo

echo "iname" > infra_instances.csv
aws-okta exec $TF_RAAS_ENV -- aws --region $region  elasticache describe-cache-clusters | jq '.CacheClusters | .[] | .ReplicationGroupId' | sort | uniq | tr -d '"' | sed -e "s/-${filter1}\$//" | sort | uniq | sort >> infra_instances.csv
echo "iname" > state_instances.csv

aws-okta exec $TF_RAAS_ENV -- terragrunt state list 2>/dev/null | grep -e aws_elasticache | grep -v -e subnet_group -e parameter_group | sed -e 's/aws_elasticache_replication_group\.//' -e 's/\[0\]//'      >> state_instances.csv
#
#aws-okta exec $TF_RAAS_ENV -- terragrunt state list 2>/dev/null | grep -e aws_route53_record | sed -e 's/aws_route53_record\.//' -e 's/\[0\]//' -e 's/_cname//' | sort | uniq                                 >> state_instances.csv


sqlite3 > elasticache.txt <<EOT
.mode csv
.import infra_instances.csv infra_instances
.import state_instances.csv state_instances 

select a.* from (
select iname from infra_instances 
where iname not in ('null') and iname not like '%-replica'
except 
select iname from state_instances) a
--where a.iname like '%payload%'
;

EOT

# find missing ec instances
for x1 in `cat elasticache.txt`
do
import_ec $x1
done

rm -f infra_cname.csv state_cname.csv infra_instances.csv state_instances.csv elasticache.txt route53.txt

# aws-okta exec $TF_RAAS_ENV -- aws route53 list-resource-record-sets --hosted-zone-id Z44QSCLVUU9XB | jq '.ResourceRecordSets | .[] | .Name'  | grep redis | tr -d '"' | sed -e 's/--redis.*//' | sort | uniq | sort
#   "deal-book-service--redis.prod.prod.us-west-2.aws.groupondev.com."
# aws-okta exec $TF_RAAS_ENV -- aws --region $region  elasticache describe-cache-clusters | jq '.CacheClusters | .[] | .ReplicationGroupId' | sort | uniq | tr -d '"' | sed -e 's/-prod//' | sort | uniq | sort
# aws-okta exec $TF_RAAS_ENV -- aws --region us-west-2  elasticache describe-cache-clusters | jq '.CacheClusters | .[] | .ReplicationGroupId' | sort | uniq | tr -d '"' | sed -e 's/-prod//'
#   "deal-book-service-prod"
# aws-okta exec stg -- terragrunt state list 2>/dev/null | grep -e aws_elasticache | grep -v -e subnet_group -e parameter_group | sed -e 's/aws_elasticache_replication_group\.//' -e 's/\[0\]//'
#   aws_elasticache_replication_group.appointments-resque[0]
# aws-okta exec stg -- terragrunt state list 2>/dev/null | grep -e aws_route53_record | sed -e 's/aws_route53_record\.//' -e 's/\[0\]//' -e 's/_cname//'
#   aws_route53_record.appointments-resque_cname[0]
# aws-okta exec $TF_RAAS_ENV -- terragrunt import aws_elasticache_replication_group.deal-book-service[0] deal-book-service-prod
# aws-okta exec $TF_RAAS_ENV -- terragrunt import aws_route53_record.deal-book-service_cname[0] Z44QSCLVUU9XB_deal-book-service--redis.prod_CNAME

}
