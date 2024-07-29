#!/usr/bin/env bash

## usage -
##   test_restore.sh gds-snc1-prod-user-lists-api-ro-vip.snc1
##


INSTANCE=$1

   RESTORE_HOST=gds-snc1-test-db001m1.snc1
   RESTORE_INSTANCE=gds_restore_test
   # GDS_NAME=user_lists_api_prod
   # INSTANCE=gds-snc1-prod-user-lists-api-ro-vip.snc1


   # clean space
     echo " clean space on $RESTORE_HOST"
      sudo sudo zfs destroy -rv tank/var/groupon/percona/$RESTORE_INSTANCE@%
      sudo find  /var/groupon/percona/${RESTORE_INSTANCE}/ -depth 2 -exec rm -rf '{}' \;
      sudo find  /var/groupon/restore/ -type f -depth 1 -exec rm -rf '{}' \;
     echo " space cleaned"
   # identify server it's on
     echo " identify server"
      cd /var/groupon/restore/delorean
      DELOREAN_HOST=`grep $INSTANCE inventory/delorean* | cut -f 1 -d ':' | cut -f 2 -d '/' | sed 's/-prod-snc1-//g' | sed s'/$/m1/g'`
     echo " $DELOREAN_HOST identified"
   # identify backup file
     echo " identify backup file"
      BACKUP_FILE=`ssh  -o StrictHostKeyChecking=no -T $DELOREAN_HOST "sudo find /var/groupon/delorean/pools/us/ -name '${INSTANCE}*.gz' | head -n1"`
     echo " file $BACKUP_FILE identified"
   # copy file to test server
     echo " copy $BACKUP_FILE to $RESTORE_HOST"
      scp -o StrictHostKeyChecking=no $DELOREAN_HOST:$BACKUP_FILE /var/groupon/restore/
     echo " file copied"
   # extract
     echo " extract file"
      sudo /usr/local/bin/gtar -zxivf /var/groupon/restore/*.gz -C /var/groupon/percona/$RESTORE_INSTANCE/data/
     echo " file extracted"
   # prepare
     echo " preparing backup"
      sudo cd /var/groupon/percona/$RESTORE_INSTANCE/data
      sudo innobackupex --defaults-file=/var/groupon/percona/$RESTORE_INSTANCE/data/backup-my.cnf --use-memory=8G --apply-log /var/groupon/percona/$RESTORE_INSTANCE/data
      sudo chown -R gds_uid60002:ops_gds_app /var/groupon/percona/$RESTORE_INSTANCE
     echo " prepared"
   # verify server up
     echo " verifying service is started"
      sudo grep 'mysqld: ready for connections' /var/groupon/percona/${RESTORE_INSTANCE}/log/error.log
    #verify data
exit 0