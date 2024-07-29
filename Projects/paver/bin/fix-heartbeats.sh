#!/usr/bin/env bash 

# run this from paver root.
# v1.0 by asutherland 2018-12-07

ME=`whoami`


echo "generating mysql host list"
for i in `grep mysql inventory/group_vars/gds* | awk '{print $1}' | cut -f 3 -d '/' | cut -f 1 -d '.' | sort -n  | uniq | sed 's/_/-/g'`; do ls inventory/host_vars/ | grep $i; done | sed 's/.yml//g' | sort -n | uniq > currenthostlist_mysql

echo "doing snc1 - `date`" 
for i in `cat currenthostlist_mysql | grep snc1`; do scp bin/subscript_check_heartbeats.sh $i:~/ ; ssh -T $i "sudo /home/$ME/subscript_check_heartbeats.sh" > snc1/$i ; done
echo "doing sac1 - `date`" 
for i in `cat currenthostlist_mysql | grep sac1`; do scp bin/subscript_check_heartbeats.sh $i:~/ ; ssh -T $i "sudo /home/$ME/subscript_check_heartbeats.sh" > sac1/$i ; done
echo "doing dub1 - `date`" 
for i in `cat currenthostlist_mysql | grep dub1`; do scp binsubscript_check_heartbeats.sh $i:~/ ; ssh -T $i "sudo /home/$ME/subscript_check_heartbeats.sh" > dub1/$i ; done

echo "copying fix script to boxes"
for i in `cat currenthostlist_mysql` ; do scp bin/subscript_fix_heartbeats.sh $i:~/


echo "processing..."
for i in `ls -1 snc1/ | grep m1`
do
  SNCM1=`echo -ne "$i"`
  SNCS1=`echo -ne "$i" | sed 's/m1/s1/g'`
  SACM1=`echo -ne "$i" | sed 's/snc1/sac1/g'`
  SACS1=`echo -ne "$i" | sed 's/snc1/sac1/g' | sed 's/m1/s1/g'`

  cat snc1/$SNCM1 snc1/$SNCS1 sac1/$SACM1 sac1/$SACS1 | grep -A1 -B0 count | cut -f 1 -d ':' | perl -e 'chomp(@a=<>);print @a' | sed -e $'s/\-\-/\\\n/g' | awk -v "SRV=$SNCM1" '{print "ssh -T ", SRV, " /usr/home/$ME/subscript_fix_heartbeats.sh", $1, $3}' | sort
  cat snc1/$SNCM1 snc1/$SNCS1 sac1/$SACM1 sac1/$SACS1 | grep -A1 -B0 count | cut -f 1 -d ':' | perl -e 'chomp(@a=<>);print @a' | sed -e $'s/\-\-/\\\n/g' | awk -v "SRV=$SNCS1" '{print "ssh -T ", $SRV, " /usr/home/$ME/subscript_fix_heartbeats.sh", $1, $3}' | sort
  cat snc1/$SNCM1 snc1/$SNCS1 sac1/$SACM1 sac1/$SACS1 | grep -A1 -B0 count | cut -f 1 -d ':' | perl -e 'chomp(@a=<>);print @a' | sed -e $'s/\-\-/\\\n/g' | awk -v "SRV=$SACM1" '{print "ssh -T ", $SRV, " /usr/home/$ME/subscript_fix_heartbeats.sh", $1, $3}' | sort
  cat snc1/$SNCM1 snc1/$SNCS1 sac1/$SACM1 sac1/$SACS1 | grep -A1 -B0 count | cut -f 1 -d ':' | perl -e 'chomp(@a=<>);print @a' | sed -e $'s/\-\-/\\\n/g' | awk -v "SRV=$SACS1" '{print "ssh -T ", $SRV, " /usr/home/$ME/subscript_fix_heartbeats.sh", $1, $3}' | sort
done 2>/dev/null | grep gds > fixthings_snc_sac.sh
chmod +x fixthings_snc_sac.sh

for i in `ls -1 dub1/ | grep m1`
do
  DUBM1=`echo -ne "$i"`
  DUBS1=`echo -ne "$i" | sed 's/m1/s1/g'`

  cat dub1/$DUBM1 dub1/$DUBS1 | grep -A1 -B0 count | cut -f 1 -d ':' | perl -e 'chomp(@a=<>);print @a' | sed -e $'s/\-\-/\\\n/g' | awk -v "SRV=$DUBM1" '{print "ssh -T ", SRV, " /usr/home/$ME/subscript_fix_heartbeats.sh", $1, $3}' | sort
  cat dub1/$DUBM1 dub1/$DUBS1 | grep -A1 -B0 count | cut -f 1 -d ':' | perl -e 'chomp(@a=<>);print @a' | sed -e $'s/\-\-/\\\n/g' | awk -v "SRV=$DUBS1" '{print "ssh -T ", $SRV, " /usr/home/$ME/subscript_fix_heartbeats.sh", $1, $3}' | sort
done 2>/dev/null | grep gds > fixthings_dub.sh
chmod +x fixthings_dub.sh

echo "  done"

echo ""
echo "run the following files:"
echo "  fixthings_snc_sac.sh"
echo "  fixthings_dub.sh"
echo ""
echo "you can remove the following temporary files or directories now:"
echo "  dub1/ snc1/ sac1/"
echo "  currenthostlist_mysql"
echo ""