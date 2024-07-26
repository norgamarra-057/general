# README

raas_info rails app
* Ruby version: 2.5.0
* Rails version: 5.1.4

## How to run on laptop

```
rvm install 2.5.0
gem install bundler
bundle install

# if mysql2 fails:
# make sure these dirs exist:
# ls /usr/local/opt/openssl/ /usr/local/opt/openssl/include
# if not:
# brew install openssl
# then try installing with flags:
# gem install mysql2 -v '0.4.10' --source 'https://rubygems.org/' -- --with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include

# check db name and credentials:
vi config/database.yml

# on your local mysql:
DROP DATABASE raas_info_dev;
CREATE DATABASE raas_info_dev;

# create tables:
bin/rails db:migrate

# populate tables:
./bin/rails runner lib/update_raas_info_db.rb

# add monitoring clusters to clusters table:
mysql --defaults-file=~/Downloads/my.cnf < monitoring_clusters.sql

# run rails server:
./bin/rails server

```

## How to run on vagrant
This tests the cap deploy will work in staging/production

### install vagrant on Mac
Download from https://www.vagrantup.com/downloads.html

```
mkdir -p ~/vagrant/raas_info_vagrant
cd ~/vagrant/raas_info_vagrant

# takes a minute, but it's just once:
vagrant init bento/centos-7.4

# we'll make vagrant's puma listen on 8080, we'll access from laptop's 3001:
vi Vagrantfile
config.vm.network "forwarded_port", guest: 8080, host: 3001

# start the vagrant VM:
vagrant up

# tip 1) how to SSH to the vagrant VM:
vagrant ssh

# tip 2) this is the explicit way to ssh:
# ssh -p2222 -i ~/vagrant/raas_info_vagrant/.vagrant/machines/default/virtualbox/private_key vagrant@127.0.0.1

# tip 3) avoid draining your laptop battery after you're done:
# vagrant suspend

```

### configure the vagrant VM

```
cd ~/git/raas/raas_info/ansible/
ansible-playbook -i development site.yml
```

### deploy the app

```
cd ~/git/raas/raas_info/
cap development deploy
# not necessary on first deploy:
# cap development deploy:migrate
cap development puma:config
cap development puma:start
```

### populate the db

```
# ssh to the VM:
cd ~/vagrant/raas_info_vagrant
vagrant ssh

cd /var/groupon/www/current/
./bin/rails runner lib/update_raas_info_db.rb
mysql -u root -h127.0.0.1 --password='' raas_info_dev < /var/groupon/www/current/monitoring_clusters.sql

```

Access from http://localhost:3001

## How to deploy on raas-admin1-staging.snc1

### On host provisioning
**Already** performed, after machine was provisioned:
1. add system user deploy_user:
```
[~/git/ops-config]$ ./bin/user_access grant deploy_user hosts/raas-admin1-staging.snc1.yml
```
2. roll it
3. grant your linux user permission to write on /var/groupon/www/ by adding it to deploy_user group:
```
ssh raas-admin1-staging.snc1
sudo usermod -a -G deploy_user pablo
```
4. prepare host using ansible on your laptop:
```
[~/git/raas/raas_info/ansible]$ ansible-playbook -i staging site.yml
```
5. install rails app from your laptop:
```
[~/git/raas/raas_info]$ cap staging deploy
```
6. populate db:
```
ssh raas-admin1-staging.snc1
sudo -i -u deploy_user
cd /var/groupon/www/current
./bin/rails runner -e staging lib/update_raas_info_db.rb
```

### How to deploy new code:

From your laptop:
```
[~/git/raas/raas_info]$ cap staging deploy
```

## How this rails app was created (overview)

```
rails new raas_info
cd raas_info

bin/rails generate scaffold Cluster name:string:uniq
bin/rails generate migration AddMonitoringClusterToCluster monitoring_cluster:string
bin/rails generate migration AddVersionToCluster version:string

bin/rails generate scaffold Node rl_id:integer role:string address:string hostname:string num_shards:integer num_shards_max:integer cores:integer version:string rack:string status:string available_ram:bigint available_ram_max:bigint ram:bigint ram_max:bigint cluster:belongs_to

bin/rails generate scaffold Db rl_id:integer name:string engine:string status:string num_shards:integer placement:string replication:string persistence:string endpoint_host:string endpoint_port:integer cluster:belongs_to
bin/rails generate migration AddProxyPolicyToDb proxy_policy:string
bin/rails generate migration AddCrdtGuidToDb crdt_guid:string
bin/rails generate migration AddSyncToDb sync:string
bin/rails generate migration AddResqueWebToDb resque_web:string
bin/rails generate migration AddEvictionPolicyToDb eviction_policy:string
bin/rails generate migration AddEngineVersionToDb engine_version:string
bin/rails generate migration AddMemoryLimitToDb memory_limit:bigint

bin/rails generate scaffold Endpoint rl_id:string role:string ssl:string db:belongs_to node:belongs_to

bin/rails generate scaffold Shard rl_id:integer role:string slots:string used_memory:bigint status:string db:belongs_to node:belongs_to

bin/rails generate migration AddUniqToNodes
#add_index :nodes, [:cluster_id, :rl_id], unique: true

bin/rails generate migration AddUniqToDbs
#add_index :dbs, [:cluster_id, :rl_id], unique: true

bin/rails generate migration AddUniqToEndpoints
#add_index :endpoints, [:db_id, :rl_id], unique: true

bin/rails generate migration AddUniqToShards
#add_index :shards, [:db_id, :rl_id], unique: true

vi app/models/cluster.rb
# has_many :dbs, dependent: :destroy
# has_many :nodes, dependent: :destroy

vi app/models/db.rb
# has_many :shards, dependent: :destroy
# has_many :endpoints, dependent: :destroy

vi app/models/node.rb
# has_many :shards, dependent: :destroy
# has_many :endpoints, dependent: :destroy

vi app/models/endpoint.rb
# replace "belongs_to :node" with "belongs_to :node, optional: true"

```


## How to rename a column

Example where I renamed node.shards to node.num_shards

```
rm app/assets/javascripts/nodes.coffee
rm app/assets/stylesheets/nodes.scss
rm app/controllers/nodes_controller.rb
rm app/helpers/nodes_helper.rb
rm app/models/node.rb
rm -fr app/views/nodes/
rm db/migrate/*_create_nodes.rb
rm test/controllers/nodes_controller_test.rb
rm test/fixtures/nodes.yml
rm test/models/node_test.rb
rm test/system/nodes_test.rb

bin/rails generate scaffold Node rl_id:integer role:string address:string hostname:string num_shards:integer num_shards_max:integer cores:integer version:string rack:string status:string available_ram:bigint available_ram_max:bigint ram:bigint ram_max:bigint cluster:belongs_to

mv db/migrate/20180202230932_create_nodes.rb db/migrate/20180201192707_create_nodes.rb
git co app/models/node.rb

DROP DATABASE raas_info_dev;
CREATE DATABASE raas_info_dev;

bin/rails db:migrate

```
