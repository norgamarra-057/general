/home/ksatyamurthy/redis-6.0.5/bin/redis-cli -p 6379 shutdown nosave
/home/ksatyamurthy/redis-6.0.5/bin/redis-cli -p 6380 shutdown nosave
sudo rm -vf /var/groupon/redis/*.rdb

sudo /home/ksatyamurthy/redis-6.0.5/bin/redis-server /home/ksatyamurthy/redis-6379.conf
sudo /home/ksatyamurthy/redis-6.0.5/bin/redis-server /home/ksatyamurthy/redis-6380.conf
