
#!/bin/tcsh
# Change log
#
# - Parametrized the command line entries for Paver path, Jira ticket, Postgres instance name, and the application server list
# - Removed the recursive flag on the rm commands
# - Added resolution for the grpn CNAME
# - Added functionality for the script to backup the yml file that is to be modified and then allow the rollback option if the changes were incorrect
# - To allow for testing I have added a dryrun flag so that changes are automatically rolled back and no GIT changes are made
# - Added the ability to add IP's to the white list hosts files 
# - Updated the host flag to use h instead of d
# - Updated the AND and OR statements to use && and || instead of -a and -o so that it works in BASH shell as well as TCSH shell
# - Updated the script to prevent whitelist non-prod hosts to prod Daas: Edwin Wang 2017-05-12

IFS=$'\n'
LINE_NUMBER=1

# Flag as each new section is started and processed
SECTION_COMPLETE=0
UPDATES_MADE=0

# Needed for MySQL and Postgres Firewall additions
TYPE_LINE=0
FIREWALL_START_LINE=0
DBA_ACCOUNT_LINE=0

# Needed for Postgres Firewall additions
DBA_SRC_LINE=0
PORT_LINE=0

# Line insert place holders
INSERT_LINE=0
INSERT_LINE_POSTGRES=0

# Postgres flag
POSTGRES=0
SOX_FOUND=0

# Other Global Variables
GDS=''
TICKET=''
INSTANCE=''
DRY_RUN=false
PAVER_PATH=~/paver
LIST='whitelist_hosts'

# For preventing whitelisting non-prod hosts to prod daas
IS_GDS_PROD=0 
IS_HOSTS_PROD=0

# For preventing whitelisting .sac1 or .dub1 boxes against UAT/STG DB VIPs
IS_GDS_UAT_STG=0
IS_HOSTS_SAC_DUB=0

clear
echo "#####################"
echo "White Listing Script"
echo "#####################"
echo ""

usage(){
	echo ""
	echo "Automate the whitelisting process for application servers to talk to GDS database servers"
	echo ""
	echo "Usage for $0 : "
	echo " -h	GDS database server to whitelist against. REQUIRED"
	echo " -j	Jira Ticket to use for GIT push. REQUIRED"
	echo " -i	PostgreSQL instance name.  REQUIRED if database is PostgreSQL"
	echo " -p	Paver Repository Location.  DEFAULT VALUE : ~/paver"
	echo " -l	Application host list to be whitelisted. DEFAULT VALUE : ./whitelist_hosts"
	echo " -D	Dry Run.  Auto rolls back any changes made and no changes will be pushed to GIT"
	echo ""
	echo "Examples :"
	echo " $0 -h stg-emea-inbox-mgmt-rw-vip.us.daas.grpn -j GDS-1234"
	echo " $0 -h stg-emea-inbox-mgmt-rw-vip.us.daas.grpn -j GDS-1234 -i users_stg"
	echo " $0 -h stg-emea-inbox-mgmt-rw-vip.us.daas.grpn -j GDS-1234 -p /root/paver -l /root/my_list"
	echo ""
	exit 1
}

# Validate Arguments

while [ "$#" -gt 0 ]; do
	case "$1" in
		-h) GDS="$2"; shift 2;;
		-j) TICKET="$2"; shift 2;;
		-i) INSTANCE="$2"; shift 2;;
		-p) PAVER_PATH="$2"; shift 2;;
		-l) LIST="$2"; shift 2;;
		-D) DRY_RUN=true; shift;;
		-*) echo "unknown option: $1" >&2; usage; exit 1;;
		*) echo "unrecognized argument: $1"; usage; exit 1;;
  	esac
done

## Validation Steps to help ensure the script will run successfully.
[ "$DRY_RUN" == true ] && echo "DRYRUN:  All YML changes will be rolled back and no changes will be pushed to GIT"
[ ! -e $PAVER_PATH ] && echo "ERROR: Paver GIT repo could not be found at $PAVER_PATH" && usage && exit 1 || echo "Found Paver $PAVER_PATH"
[ ! -f "$LIST" ] && echo "ERROR: Application server list could not be found at $LIST" && usage && exit 1 || echo "Found server list $LIST"
[ -z $GDS ] && echo "ERROR: You have not specified the GDS database server" && usage && exit 1 || echo "Found GDS database server $GDS"
[ -z $TICKET ] && echo "ERROR: Jira ticket not specified" && usage && exit 1 || echo "Found Jira ticket $TICKET"
[ -f ~/.server_list ] && rm -f ~/.server_list
[ -f ~/.yml_backup ] && rm -f ~/.yml_backup

echo ""

echo "Discovering the hosts to white list"
echo ""
for i in `cat $LIST`
do
	#Remove white space
	i=`echo $i | sed 's/ //g'`
	if expr "$i" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
		echo "  Found IP $i resolving hostname to validate"
		i=`host $i | awk '{print $5}'`
	fi

	IP=`host "$i" | awk '{print $4}'`
	if expr "$IP" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
		HOSTNAME=`host "$i" | awk '{print "- "$4 "/32   #"}' | sed "s/$/ $i/g"`
                echo "  $i : $IP"
                echo "$IP;$HOSTNAME" >> ~/.server_list
	else
		echo "!! Unable to find IP for the host  $i.  Please update requester !!"
	fi
done
echo ""
[ ! -f ~/.server_list ] && echo "ERROR: There are no application servers to whitelist !!" && exit 1

## Discover the YML file from the GIT Repo

# There is a very rare occations where a GDS VIP will have more than one IP.  WIll eventually need to add a check for more than 1 IP !!!
echo "Discovering the GDS database host for the VIP $GDS"
echo ""
[ `echo -n $GDS | tail -c 4 | awk '{ print tolower($1) }'` == 'grpn' ] && echo "  GRPN CNAME found" && GDS_IP=`host $GDS | grep address | awk '{print \$4}'` || GDS_IP=`host $GDS | awk '{print \$4}'`
if expr "$GDS_IP" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
	echo "  Found IP $GDS_IP for VIP $GDS"
else
	echo "  No IP found for the GDS VIP $GDS.  Please double check the VIP name is correct"
	exit 1
fi

# Check for multiple YML files and exits if it finds one.  
# This is using grep +1 to get the first slave VIP.  This is assuming that each cluster only has 1 slave which is the case currently

if [ `grep -A 1 "master_vip:\|slave_vips:" $PAVER_PATH/inventory/group_vars/* | grep -w $GDS_IP | grep -v "\-e" | wc -l` -gt 1 ]; then
	echo "Found more than 1 file. The script needs to be updated to handle this.  For now the white listing should be done manually."
	YML_FILE=`grep -A 1 "master_vip:\|slave_vips:" $PAVER_PATH/inventory/group_vars/* | grep -w $GDS_IP | grep -v "\-e"`
	for i in $YML_FILE
	do
		echo "  Found YML file $i"
	done;
	exit 1
fi

# If no YML files are found then it exits

if [ `grep -A 1 "master_vip:\|slave_vips:" $PAVER_PATH/inventory/group_vars/* | grep -w $GDS_IP | grep -v "\-e" | wc -l` -eq 0 ]; then
	echo "ERROR: Did not find a YML that contains $GDS_IP IP found from $GDS"
	exit 1
fi

YML_FILE=`grep -A 1 "master_vip:\|slave_vips:" $PAVER_PATH/inventory/group_vars/* | grep -w $GDS_IP | grep -v "\-e" | cut -d: -f1 | cut -d- -f1`

echo "  Found YML file $YML_FILE"
echo "  Backing up YML file to ~/.yml_backup"
cp $YML_FILE ~/.yml_backup
echo ""

# Find the node in the YML File and determine if it's MySQL or Postgres

FILE_LENGTH=`cat $YML_FILE | wc -l`
echo "Please wait while searching through the YML file for the correct node to white list against!"
echo ""

while [ $LINE_NUMBER -lt $FILE_LENGTH ]
do
	line=`head -$LINE_NUMBER $YML_FILE | tail -1`
	#echo "$LINE_NUMBER $line"
	        # Scanning every line in the YML file

	        if [ `echo "$line" | grep 'type:' | wc -l` -gt 0 ]; then
			TYPE_LINE=$LINE_NUMBER
			if [ `echo "$line" | grep 'postgres' | wc -l` -gt 0 ]; then
				POSTGRES=1
			else
				POSTGRES=0
			fi
		fi
		
		[ `echo "$line" | grep '_SOX_' | wc -l` -gt 0 ] && SOX_FOUND=$LINE_NUMBER	
		[ `echo "$line" | grep 'firewall_permitted_src_cidrs:' | wc -l` -gt 0 ] && FIREWALL_START_LINE=$LINE_NUMBER
		[ `echo "$line" | grep 'dba_account_name:' | wc -l` -gt 0 ] && INSERT_LINE=$LINE_NUMBER && DBA_ACCOUNT_LINE=$LINE_NUMBER
		[ `echo "$line" | grep 'dba_src_cidrs:' | wc -l` -gt 0 ] && DBA_SRC_LINE=$LINE_NUMBER
		[ `echo "$line" | grep 'ports:' | wc -l` -gt 0 ] && SECTION_COMPLETE=1 && INSERT_LINE_POSTGRES=$LINE_NUMBER && PORT_LINE=$LINE_NUMBER

	        if [ $SECTION_COMPLETE -eq 1 ]; then
	        
			# Check the section to see if it contains the IP address that we are looking for.
			#echo "Checking for $GDS_IP in $YML_FILE from $TYPE_LINE to $PORT_LINE"
			FIND_NODE=`/usr/bin/sed -n $TYPE_LINE,$PORT_LINE"p" $YML_FILE | grep -w $GDS_IP | wc -l`
			if [ $FIND_NODE -gt 0 ]; then
				echo ""
				echo "FOUND $GDS_IP in the YML file for the following node"
				echo ""
				TYPE_LINE=$((TYPE_LINE-10))
				/usr/bin/sed -n $TYPE_LINE,$PORT_LINE"p" $YML_FILE
				echo ""
				echo "!! Please verify that this is the correct node by checking the VIP IP for the node!!"
				[ $SOX_FOUND -gt 0 ] && echo " !!!! THIS IS A SOX COMPLIANCE INSTANCE. Please make sure this is OK !!!!"
				echo "Do you wish to white list the servers to this node (y/n) ? "
				read CONFIRM
				if [ $CONFIRM == "y" ] || [ $CONFIRM == "Y" ]; then
					echo "Making changes to YML file accordingly." 
				else
					echo "Y or y was not chosen.  Exiting." 
					rm -f ~/.server_list 
					rm -f ~/.yml_backup
					exit 1
				fi

				[ $POSTGRES -eq 1 ] && [ -z $INSTANCE ] && echo "ERROR: You have not specified the PostgreSQL instance name with the -i" && usage && rm -f ~/.server_list && rm -f ~/.yml_backup && exit 1 || echo "Found instance name $INSTANCE"
				echo ""
	
				echo "Performing a GIT PULL to make sure we have the latest files before starting to update them"
				cd $PAVER_PATH; git pull;	

				echo "Telling GIT to ignore changes to $LIST"
				git update-index --assume-unchanged $LIST
		
				for i in `cat ~/.server_list`
				do
					IP=`echo $i | cut -d\; -f1`
					hname=`echo $i | cut -d\; -f2`
					
					# For preventing whitelisting non-prod hosts to prod daas
					if echo " $YML_FILE " | grep prod > /dev/null; then
	                   IS_GDS_PROD=1 
                    else
	                   IS_GDS_PROD=0
                    fi
					IS_HOSTS_PROD=1
					[ `echo "$hname" | grep "uat\|dev\|stg\|staging\|qa\|test" | wc -l` -gt 0 ] && IS_HOSTS_PROD=0
	                if [ $IS_GDS_PROD -eq 1 ] && [ $IS_HOSTS_PROD -eq 0 ]; then
					  echo " Non-prod host $hname is not allowed to be whitelisted to the prod $YML_FILE.  Skipping"
					  continue
                    fi					
					# End of changes for preventing whitelisting non-prod hosts to prod daas
					
				# For preventing whitelisting .sac1 or .dub1 boxes against UAT/STG DB VIPs
                                        if echo " $YML_FILE " | grep "uat\|stg\|staging" > /dev/null; then
                                           IS_GDS_UAT_STG=1
                                        else
                                           IS_GDS_UAT_STG=0
                                        fi
				IS_HOSTS_SAC_DUB=0
										[ `echo "$hname" | grep "dub1\|sac1" | wc -l` -gt 0 ] && IS_HOSTS_SAC_DUB=1
										if [ $IS_GDS_UAT_STG -eq 1 ] && [ $IS_HOSTS_SAC_DUB -eq 1 ]; then
										  echo "The .sac1 or .dub1 box $hname is not allowed to be whitelisted against UAT/STG DB VIPs $YML_FILE.  Skipping"
										  continue
										fi
						# End of preventing whitelisting .sac1 or .dub1 boxes against UAT/STG DB VIPs	
                                        
                                        SED_COUNT=`/usr/bin/sed -n $FIREWALL_START_LINE,$DBA_ACCOUNT_LINE"p" $YML_FILE | grep -w $IP | wc -l`
					if [ $SED_COUNT -gt 0 ]; then
						echo "    Found $IP in the firewall list.  Skipping"
					else
						sed -i -e ''"$INSERT_LINE"''"i"'\
							'"\ \ \ \ \ \ $hname"'
						' $YML_FILE 
	
						# Incrementing the line numbers since we just inserted 
       	                                 	DBA_ACCOUNT_LINE=$((DBA_ACCOUNT_LINE+1))
       	                                 	DBA_SRC_LINE=$((DBA_SRC_LINE+1))
       	                                 	PORT_LINE=$((PORT_LINE+1))
                                        	LINE_NUMBER=$((LINE_NUMBER+1))
                                        	INSERT_LINE_POSTGRES=$((INSERT_LINE_POSTGRES+1))
						INSERT_LINE=$((INSERT_LINE+1))
						UPDATES_MADE=$((UPDATES_MADE+1))
					fi

					# IF this is postgres check the next section for the IP and add it if it's not there
					if [ $POSTGRES -eq 1 ];then
						POSTGRES_SED_COUNT=`/usr/bin/sed -n $DBA_SRC_LINE,$PORT_LINE"p" $YML_FILE | grep -w $IP | wc -l`
						# echo "  Checking for $IP between the lines $DBA_SRC_LINE and $PORT_LINE"
						if [ $POSTGRES_SED_COUNT -gt 0 ]; then
							echo "    Found $IP in the dba_src list"
						else
							sed -i -e ''"$INSERT_LINE_POSTGRES"''"i"'\
	                                                        '"\ \ \ \ \ \ $hname"'
	                                                ' $YML_FILE
	
                                         	       # echo "    Postgres Inserting $hname at $INSERT_LINE_POSTGRES"
                                         	       # Incrementing the line numbers that are under this line since we just inserted 

                                       	 	        PORT_LINE=$((PORT_LINE+1))
                                	                LINE_NUMBER=$((LINE_NUMBER+1))
                                	                INSERT_LINE_POSTGRES=$((INSERT_LINE_POSTGRES+1))
							UPDATES_MADE=$((UPDATES_MADE+1))
						fi
					fi
				done;
			
				echo ""
				/usr/bin/sed -n $TYPE_LINE,$PORT_LINE"p" $YML_FILE
				echo ""
				cd $PAVER_PATH; git diff;
				echo ""

				[ $UPDATES_MADE -eq 0 ] && echo "No changes are needed.  Exiting" && rm -f ~/.server_list && exit 1
				[ $SOX_FOUND -gt 0 ] && echo " !!!! THIS IS A SOX COMPLIANCE INSTANCE. Please make sure this is OK !!!!"
				echo "Please validate that the changes are correct (y/n) ? "
				read CONFIRM
				if [ $CONFIRM == "y" ] || [ $CONFIRM == "Y" ]; then 
                                        echo "Pushing changes to GIT with $TICKET and applying to host"
                                else 
                                        echo "Y or y was not chosen. Exiting."
                                        echo "Do you wish to rollback your changes to the YML file (y/n) ?"
                       			read ROLLBACK
					[ $ROLLBACK == "y" ] || [ $ROLLBACK == "Y" ] || [ "$DRY_RUN" == true ] && echo "Rolling back YML file to the original file" && rm -f $YML_FILE && cp ~/.yml_backup $YML_FILE || echo "Not rolling back changes.  Backup YML is located at ~/.yml_backup" 
                                        
					rm -f ~/.server_list
                                        exit 1
                                fi
				if [ "$DRY_RUN" == false ]; then
					if [ $SOX_FOUND -gt 0 ]; then 
						echo "!!!! THIS IS A SOX COMPLIANCE INSTANCE. TAGGING THE GIT COMMIT ACCORDINGLY !!!"
						cd $PAVER_PATH; git commit -am "$TICKET - SOX whitelisting request";
					else
						cd $PAVER_PATH; git commit -am "$TICKET whitelisting request"; 
					fi
					cd $PAVER_PATH; git push;
				else
					echo "DRYRUN: Changes are not being commited or pushed to GIT"
				fi

				# Determine server to use in playbooks
				GDS_SERVER=`echo "$YML_FILE" | rev | cut -d"/" -f1 | rev | cut -d. -f1`

				if [ $POSTGRES -eq 1 ];then
					echo ""
					echo "!! POSTGRES FOUND !!"
					echo "Running postgres refresh playbook on $GDS_SERVER instance $INSTANCE"
					echo ""
					echo "ansible-playbook plays/postgres/refresh-pf-add-vip.yml --extra-vars \"target_host=$GDS_SERVER target_instance=$INSTANCE inst_type=postgresql\""
					if [ "$DRY_RUN" == false ]; then
						cd $PAVER_PATH; ansible-playbook plays/postgres/refresh-pf-add-vip.yml --extra-vars "target_host=$GDS_SERVER target_instance=$INSTANCE inst_type=postgresql"
					else
						echo "DRY RUN: ansible-playbook has not been run"
					fi
				else
					echo ""
					echo ""
       		                        echo "Running Firewall Ansible on $GDS_SERVER"
	                                echo ""
	                                echo "ansible-playbook plays/freebsd/firewall.yml --limit $GDS_SERVER"
					if [ "$DRY_RUN" == false ]; then
                                        	cd $PAVER_PATH; ansible-playbook plays/freebsd/firewall.yml --limit $GDS_SERVER
					else
                                                echo "DRY RUN: ansible-playbook has not been run"
                                        fi
				fi

				echo ""
				echo "ALL COMPLETE"
				echo ""
				[ "$DRY_RUN" == true ] && echo "DRY RUN: Reverting YML changes back" && rm -f $YML_FILE && cp ~/.yml_backup $YML_FILE
				rm -f ~/.server_list
                                rm -f ~/.yml_backup
				cd ~/
				exit 1
			fi
			SECTION_COMPLETE=0
			SOX_FOUND=0
			#	sleep 3
	        fi

	LINE_NUMBER=$((LINE_NUMBER+1))
	FILE_LENGTH=`cat $YML_FILE | wc -l`
done
