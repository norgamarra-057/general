# how to use:
# [~/git/ops-config]$ bash ~/git/raas/bast_network_access.bash

SHARED_US_SNC_HOSTS=hosts/raas-shared?-us-bast.snc1.yml
SHARED_US_SAC_HOSTS=hosts/raas-shared?-us-bast.sac1.yml
SHARED_SNC_HOSTS=hosts/raas-shared?-bast.snc1.yml
SHARED_SAC_HOSTS=hosts/raas-shared?-bast.sac1.yml
SHARED_DUB_HOSTS=hosts/raas-shared?-bast.dub1.yml
CS_US_SNC_HOSTS=hosts/raas-cs?-us-bast.snc1.yml
CS_US_SAC_HOSTS=hosts/raas-cs?-us-bast.sac1.yml
CS_DUB_HOSTS=hosts/raas-cs?-bast.dub1.yml

DB_NAME=orders
DB_PORT=13003
NA_US_SNC_GROUPS="['orders-irb-snc1','orders-read-app-snc1','orders-read-batch-snc1','orders-worker-snc1','orders-app-snc1','orders-irb-rw-snc1','orders-utility-snc1','orders-ext-snc1']"
NA_US_SAC_GROUPS="['orders-irb-sac1','orders-read-app-sac1','orders-read-batch-sac1','orders-worker-sac1','orders-app-sac1','orders-irbrw-sac1','orders-utility-sac1','orders-ext-sac1']"
NA_DUB_GROUPS="['orders-irbrw-dub1','orders-read-app-dub1','orders-worker-dub1','orders-utility-dub1','orders-app-dub1','orders-irb-dub1','orders-ext-dub1','orders-read-batch-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS

DB_NAME="billing_record_service" # actual name: billing-record-service
DB_PORT=13001
NA_SNC_GROUPS="['billing-record-service-app']"
NA_SAC_GROUPS="['billing-record-service-app']"
NA_DUB_GROUPS="['billing-record-service-app']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_SNC_GROUPS" $SHARED_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_SAC_GROUPS" $SHARED_SAC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS

DB_NAME=custsvc_tokenizer # actual name: custsvc-tokenizer
DB_PORT=13000
NA_US_SNC_GROUPS="['custsvc-app-snc1','custsvc-token-snc1','custsvc-util-snc1']"
NA_US_SAC_GROUPS="['custsvc-app-sac1','custsvc-token-sac1','custsvc-util-sac1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $CS_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $CS_US_SAC_HOSTS

DB_NAME=custsvc_intl_tokenizer # actual name: custsvc-intl-tokenizer
DB_PORT=13000
NA_DUB_GROUPS="['custsvc-intl-app-dub','custsvc-token-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $CS_DUB_HOSTS

DB_NAME=ticketsvc
DB_PORT=13004
NA_US_SNC_GROUPS="['ticketsvc-app-snc1']"
NA_US_SAC_GROUPS="['ticketsvc-app-sac1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS

DB_NAME=ticketsvc_intl # actual name: ticketsvc-intl
DB_PORT=13004
NA_DUB_GROUPS="['ticketsvc-app-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS

DB_NAME=flying_dutchman # actual name: flying-dutchman
DB_PORT=13005
NA_US_SNC_GROUPS="['flyingdutchman-app-snc1','flyingdutchman-cron-snc1']"
NA_US_SAC_GROUPS="['flyingdutchman-app-sac1','flyingdutchman-cron-sac1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS

DB_NAME=voucher_inventory_emea # actual name: voucher-inventory-emea
DB_PORT=13002
NA_DUB_GROUPS="['voucher-inventory-worker-dub1','voucher-inventory-backfill-write-app-dub1','voucher-inventory-read-app-dub1','voucher-inventory-write-app-dub1','voucher-inventory-lt-write-app-dub1','voucher-inventory-lt-read-app-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS

DB_NAME=unity_gifting_emailer # actual name: unity-gifting-emailer
DB_PORT=13006
NA_SNC_GROUPS="['unity_gifting_emailer_app_snc1']"
NA_SAC_GROUPS="['unity_gifting_emailer_app_sac1']"
NA_DUB_GROUPS="['unity_gifting_emailer_app_dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_SNC_GROUPS" $SHARED_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_SAC_GROUPS" $SHARED_SAC_HOSTS

DB_NAME="custsvc_cache" # actual name: custsvc-cache
DB_PORT=13007
NA_US_SNC_GROUPS="['custsvc-app-snc1','custsvc-cron-snc1','custsvc-token-snc1','custsvc-util-snc1','custsvc-api-snc1','aws-conveyor-prod-usw1','cs-api-snc1']"
NA_US_SAC_GROUPS="['custsvc-app-sac1','custsvc-cron-sac1','custsvc-token-sac1','custsvc-util-sac1','custsvc-api-sac1','aws-conveyor-prod-usw1','cs-api-sac1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS

DB_NAME="custsvc_cache_intl" # actual name: custsvc-cache-intl
DB_PORT=13007
NA_DUB_GROUPS="['custsvc-intl-app-dub','custsvc-intl-cron-dub','custsvc-intl-utility-dub','custsvc-intl-api-dub','aws-conveyor-prod-euw1','cs-api-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS

DB_NAME=fraud
DB_PORT=13013
NA_US_SNC_GROUPS="['orders-read-app-snc1','orders-app-snc1','orders-worker-snc1','orders-utility-snc1','orders-irb-snc1','orders-irb-rw-snc1','orders-read-batch-snc1','orders-dashboard-snc1']"
NA_US_SAC_GROUPS="['orders-read-app-sac1','orders-app-sac1','orders-worker-sac1','orders-utility-sac1','orders-irb-sac1','orders-irbrw-sac1','orders-read-batch-sac1','orders-dashboard-sac1']"
NA_DUB_GROUPS="['orders-app-dub1','orders-dashboard-dub1','orders-irb-dub1','orders-irbrw-dub1','orders-read-app-dub1','orders-read-batch-dub1','orders-utility-dub1','orders-worker-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS


DB_NAME=orders_dashboard # actual name: orders-dashboard
DB_PORT=10075
NA_SNC_GROUPS="['orders-dashboard-snc1']"
NA_SAC_GROUPS="['orders-dashboard-sac1']"
NA_DUB_GROUPS="['orders-dashboard-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_SNC_GROUPS" $SHARED_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_SAC_GROUPS" $SHARED_SAC_HOSTS

DB_NAME=users_service # actual name: users-service
DB_PORT=10062
NA_US_SNC_GROUPS="['users-service-app-snc1']"
NA_US_SAC_GROUPS="['users-service-app-sac1']"
NA_DUB_GROUPS="['users-service-app-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS


DB_NAME=gdt_automation # actual name: gdt-automation, ticket: DATA-6902,DATA-6905
DB_PORT=10118
NA_US_SNC_GROUPS="['gdt-automation-app-snc1']"
NA_US_SAC_GROUPS="['gdt-automation-app-sac1']"
NA_DUB_GROUPS="['gdt-automation-app-dub1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_DUB_GROUPS" $SHARED_DUB_HOSTS

DB_NAME=content_service_cache # actual name: content-service-cache, ticket: DATA-7159
DB_PORT=10128
NA_US_SNC_GROUPS="['content-service-model-snc1']"
NA_US_SAC_GROUPS="['content-service-model-sac1']"
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SNC_GROUPS" $SHARED_US_SNC_HOSTS
./bin/yawk -i "d.network_access.allow['db_$DB_NAME']={};d.network_access.allow.db_$DB_NAME['port']=$DB_PORT;d.network_access.allow.db_$DB_NAME['from']=$NA_US_SAC_GROUPS" $SHARED_US_SAC_HOSTS
