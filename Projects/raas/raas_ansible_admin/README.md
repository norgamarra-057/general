# README

## How to create a db

Using [the wizard](https://pages.github.groupondev.com/data/raas/wizard_rl.html) get the json required for db.json

Then:
```
# modify:
vi alerts.json
vi db.json
# note: all db.json options are in db_template.json
# note: create_db.yml will consider only:
# alerts.json
# db.json

# case1: create in one cluster (notice the comma):
ansible-playbook -i us.raas-test1.grpn, create_db.yml

# case2: create in two or more clusters:
ansible-playbook -i us.raas-test1.grpn,us.raas-test2.grpn create_db.yml

```

## How to copy a db

```
# fetch_db_specs.yml downloads db json files into local subdir tmp/
# It will ask the db numeric uid (available at raas-info)
ansible-playbook -i us.raas-test1.grpn, fetch_db_specs.yml

# download example:
# tmp//fetched/us.raas-test1.grpn/tmp/fetch_db_response.1.01e0bf89-429c-536c-85aa-a67abd8956f2.json
# tmp//fetched/us.raas-test1.grpn/tmp/fetch_db_alerts_response.1.01e0bf89-429c-536c-85aa-a67abd8956f2.json

# prepare db.json for create_db.yml playbook:
cat tmp//fetched/us.raas-test1.grpn/tmp/fetch_db_response.1.01e0bf89-429c-536c-85aa-a67abd8956f2.json | ./prune_db.py > db.json

# you may want to change name and port in case you need a copy in the same cluster
vi db.json

# prepare alerts.json for create_db.yml playbook:
cat tmp/fetched/us.raas-test1.grpn/tmp/fetch_db_alerts_response.1.01e0bf89-429c-536c-85aa-a67abd8956f2.json | ./prune_alerts.py > alerts.json

# run create_db.yml, see instructions above
```

## How I created multiple similar janus dbs

```
# remove vars_prompt section and set explicit password:
[~/git/raas/raas_ansible_admin]$ vi create_db.yml

# create janus db json with variable name and port:
[~/git/raas/raas_ansible_admin]$ grep XX dbjanus.json
  "name": "janusXX-staging",
  "port": 101XX,

# create dbs replacing XX with a sequence from 00 to 15:
[~/git/raas/raas_ansible_admin]$ for i in $(seq -f "%02g" 0 15); do sed "s/XX/$i/g" dbjanus.json > db.json; ansible-playbook -i snc1.raas-shared3-staging.grpn, create_db.yml; sleep 3; done

```
