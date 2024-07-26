#!/usr/bin/env python3

# eval $(cd /Users/ksatyamurthy/github_projects/raas-secrets; ruby load_passwords.rb)
# ../../../tf_beforehook/hook.rb ~/git/raas/raas_aws/terragrunt_live/stg_stable_usw1/redis
# export TF_CLI_ARGS_apply="-compact-warnings"



import glob
import sys 
import os 
import pexpect 
import subprocess 
import yaml 
import logging 
import time 
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--dbname', required=True)
args = parser.parse_args()


logging.basicConfig(format='%(asctime)s - %(message)s', level=logging.INFO)

# afl-analytics--redis.staging.stable.us-west-1.aws.groupondev.com

# dbname="afl-tracking-server"
dbname=args.dbname
username=os.getlogin()
path1=f"/Users/{username}/git/raas_terraform_modules/source"
#regex1=r'.*update in-place.*Plan: 0 to add, 1 to change, 0 to destroy.*Enter a value:.*'   # Not ok
#regex1=r'.*Do you want to perform these actions..*[\r\n ]+.*Terraform will perform the actions described above.[\r\n ]+.*Only \'yes\' will be accepted to approve.[\r\n ]+.*Enter a value:'  #  ok
regex1=r'.* 0 to add, 1 to change, 0 to destroy.*[\r\n ]+.*Warnings:.*[\r\n ]+.*Resource targeting is in effect..*[\r\n ]+.*To see the full warning notes, run Terraform without .compact.warnings..*[\r\n ]+.*Do you want to perform these actions..*[\r\n ]+.*Terraform will perform the actions described above.[\r\n ]+.*Only \'yes\' will be accepted to approve.[\r\n ]+.*Enter a value:'   # ok

os.chdir(path1)

result=subprocess.run(["git","pull"])

if(result.returncode != 0):
	sys.exit(8)
else:
	logging.info("git pull on raas_terraform_modules ✅")

# Load redis_instances.yml


with open("redis_instances.yml", "r") as f:
	yaml_file_data=f.readlines()
	for i,x in enumerate(yaml_file_data):
	    if(dbname in x):
	        index_no=i 

yaml_file_data[index_no]=yaml_file_data[index_no].replace(', staging_ha: true','')

with open("redis_instances.yml", "w") as f:
	f.write(''.join(yaml_file_data))


# time.sleep(60)

result=subprocess.run("./update_tf.rb".split())
if(result.returncode != 0):
	sys.exit(8)
else:
	logging.info("./update_tf.rb ✅")

result=subprocess.run("git add redis_instances.yml ../redis/instances.tf".split())
if(result.returncode != 0):
	sys.exit(8)
else:
	logging.info("git add on raas_terraform_modules ✅")

result=subprocess.run(f"""
git commit -m RAAS-645:_{dbname}_removes_staging_HA
""".split())
if(result.returncode != 0):
	logging.info("git commit on raas_terraform_modules failed ⚠️")
else:
	logging.info("git commit on raas_terraform_modules ✅")

result=subprocess.run("git push".split())
if(result.returncode != 0):
	logging.info("git commit on raas_terraform_modules failed ⚠️")
else:
	logging.info("git push on raas_terraform_modules ✅")



result=subprocess.run("git log --oneline".split(), check=True, capture_output=True)
new_commit_id=result.stdout.decode().split('\n')[0].split()[0]

# /Users/ksatyamurthy/git/raas/raas_aws/terragrunt_live/stg_stable_usw1/redis

username=os.getlogin()
path2=f"/Users/{username}/git/raas/raas_aws/terragrunt_live/stg_stable_usw1/redis"
os.chdir(path2)

with open("terragrunt.hcl", "r") as f:
	terra_file_data=f.readlines()

index_start=terra_file_data[1].index('redis?ref=')+10
old_commit_id=terra_file_data[1][index_start:-2]


terra_file_data[1]=terra_file_data[1].replace(old_commit_id,new_commit_id)

with open("terragrunt.hcl", "w") as f:
	f.write(''.join(terra_file_data))


# eval $(cd /Users/ksatyamurthy/github_projects/raas-secrets; ruby load_passwords.rb)
# ../../../tf_beforehook/hook.rb ~/git/raas/raas_aws/terragrunt_live/stg_stable_usw1/redis


result=subprocess.run("rm -rf .terragrunt-cache".split())
if(result.returncode != 0):
	logging.info(".terragrunt-cache directory not exists ⚠️")
else:
	logging.info(".terragrunt-cache deleted ✅")

# dbname="afl-analytics"
aws_cli_command=f"""aws-okta exec stg -- terragrunt apply -compact-warnings -target=aws_elasticache_replication_group.{dbname}[0] -target=aws_route53_record.{dbname}_cname[0] -target=aws_appautoscaling_target.{dbname}-autoscaling-nodes-target[0]"""
print(aws_cli_command)
child=pexpect.spawn(aws_cli_command, encoding='utf-8', timeout=3600)
child.logfile = sys.stdout
var=child.expect(regex1, timeout=3600)
#print(child.before.decode())
#output=child.read().decode()
child.sendline("no")
child.read() 
child.close()
print(child.exitstatus, child.signalstatus)



myfile=glob.glob(".terragrunt-cache/*/*/redis/instances.tf")
with open(myfile[0],'r') as f:
	data=f.readlines()
for i,x in enumerate(data):
	if(f'resource "aws_elasticache_replication_group" "{dbname}"' in x):
		lineno1=i
for i,x in enumerate(data[lineno1:lineno1+30]):
	if('replicas_per_node_group' in x):
		lineno2=i
data[lineno1+lineno2]=data[lineno1+lineno2].replace(': 0',': 1')
print(myfile[0],lineno1+lineno2,data[lineno1+lineno2])
with open(myfile[0],'w') as f:
	f.write(''.join(data))


# dbname="afl-analytics"
aws_cli_command=f"""aws-okta exec stg -- terragrunt apply -compact-warnings -target=aws_elasticache_replication_group.{dbname}[0] -target=aws_route53_record.{dbname}_cname[0] -target=aws_appautoscaling_target.{dbname}-autoscaling-nodes-target[0]"""
print(aws_cli_command)
child=pexpect.spawn(aws_cli_command, encoding='utf-8', timeout=3600)
child.logfile = sys.stdout
var=child.expect(regex1, timeout=3600)
#print(child.before.decode())
#output=child.read().decode()
child.sendline("yes")
child.read() 
child.close()
print(child.exitstatus, child.signalstatus)


myfile=glob.glob(".terragrunt-cache/*/*/redis/instances.tf")
with open(myfile[0],'r') as f:
	data=f.readlines()
for i,x in enumerate(data):
	if(f'resource "aws_elasticache_replication_group" "{dbname}"' in x):
		lineno1=i
for i,x in enumerate(data[lineno1:lineno1+30]):
	if('replicas_per_node_group' in x):
		lineno2=i
data[lineno1+lineno2]=data[lineno1+lineno2].replace(': 1',': 0')
print(myfile[0],lineno1+lineno2,data[lineno1+lineno2])
with open(myfile[0],'w') as f:
	f.write(''.join(data))


# dbname="afl-analytics"
aws_cli_command=f"""aws-okta exec stg -- terragrunt apply -compact-warnings -target=aws_elasticache_replication_group.{dbname}[0] -target=aws_route53_record.{dbname}_cname[0] -target=aws_appautoscaling_target.{dbname}-autoscaling-nodes-target[0]"""
print(aws_cli_command)
child=pexpect.spawn(aws_cli_command, encoding='utf-8', timeout=3600)
child.logfile = sys.stdout
var=child.expect(regex1, timeout=3600)
#print(child.before.decode())
#output=child.read().decode()
child.sendline("yes")
child.read() 
child.close()
print(child.exitstatus, child.signalstatus)



result=subprocess.run("git add terragrunt.hcl".split())
if(result.returncode != 0):
	sys.exit(8)
else:
	logging.info("git add on raas_aws ✅")

result=subprocess.run(f"""
git commit -m RAAS-645:_{dbname}_removes_staging_HA
""".split())
if(result.returncode != 0):
	sys.exit(8)
else:
	logging.info("git commit on raas_aws ✅")

result=subprocess.run("git push".split())
if(result.returncode != 0):
	sys.exit(8)
else:
	logging.info("git push on raas_aws ✅")
