#!/usr/local/bin/bash


file1="/var/tmp/$1_first.txt"
file2="/var/tmp/$1_second.txt"
port=$1
dbname=$2

if [ ! -f $file2 ]; then
/usr/local/bin/check_postgres_new.pl --dbname=$dbname --dbuser=postgres --port=$port --action=dbstats --include=$dbname > $file2
fi

cp $file2 $file1

/usr/local/bin/check_postgres_new.pl --dbname=$dbname --dbuser=postgres --port=$port --action=dbstats --include=$dbname > $file2


i=0
IFS="="
while read -r name value
do
array1[$i]=${value//\"/}
i=$((i + 1))
#echo "$name = ${value//\"/}"
done < $file1

i=0
while read -r name value
do
array2[$i]=${value//\"/}
i=$((i + 1))
#echo "$name = ${value//\"/}"
done < $file2

#echo "idxscan" ${array1[5]}
#echo "rollbacks" ${array1[2]}

#echo "idxscan" ${array2[5]}
#echo "rollbacks" ${array2[2]}

echo "postgresql OK: | backends=$((${array2[0]}));commits=$((${array2[1]} - ${array1[1]}));rollbacks=$((${array2[2]} - ${array1[2]}));read=$((${array2[3]} - ${array1[3]}));hit=$((${array2[4]} - ${array1[4]}));idxscan=$((${array2[5]} - ${array1[5]}));idxtupread=$((${array2[6]} - ${array1[6]}));idxtupfetch=$((${array2[7]} - ${array1[7]}));idxblksread=$((${array2[8]} - ${array1[8]}));idxblkshit=$((${array2[9]} - ${array1[9]}));seqscan=$((${array2[10]} - ${array1[10]}));seqtupread=$((${array2[11]} - ${array1[11]}));ret=$((${array2[12]} - ${array1[12]}));fetch=$((${array2[13]} - ${array1[13]}));ins=$((${array2[14]} - ${array1[14]}));upd=$((${array2[15]} - ${array1[15]}));del=$((${array2[16]} - ${array1[16]}));"



