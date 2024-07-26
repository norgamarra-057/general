set -vx
set -e
set -u
set -o pipefail
trap 'exit 8' ERR

touch /tmp/force_redislabs_install;
sudo /var/tmp/roll;

sleep 10;

var1=`sudo rlcheck|grep "ALL TESTS PASSED" | wc -l`

if [[ $var1 -eq 1 ]];then
if sudo rladmin status extra all | grep "node:" | grep -c -v OK
then
#if [[ $var2 -eq 0]]; then
exit 8
else
echo "All OK"
fi
fi;

sleep 10
