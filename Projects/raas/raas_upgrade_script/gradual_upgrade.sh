set -vx
set -e
set -u
set -o pipefail
trap 'exit 8' ERR

sudo rladmin tune cluster max_redis_forks 1
sudo rladmin tune cluster max_slave_full_syncs 1

for d in $(sudo rladmin status databases|grep db:|awk '{print $2}');
do echo upgrading db $d;
sudo rladmin upgrade db $d;
sleep 5;
done
