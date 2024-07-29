 
#!/bin/tcsh
# Change log
#
                                        
IFS=$'\n'
LINE_NUMBER=1

# Flag as each new section is started and processed
SECTION_COMPLETE=0

# Needed for MySQL and Postgres Firewall additions
TYPE_LINE=0
FIREWALL_START_LINE=0
DBA_ACCOUNT_LINE=0

# Needed for Postgres Firewall additions
DBA_SRC_LINE=0
PORT_LINE=0
       
# Other Global Variables
GDS=''
PAVER_PATH=~/paver

clear
echo "#####################"
echo "List Hosts Script"
echo "#####################"
echo ""

usage(){
        echo ""
        echo "Automate the whitelisting process for application servers to talk to GDS database servers"
        echo ""
        echo "Usage for $0 : "
        echo " -h       GDS database server to whitelist against. REQUIRED"
        echo ""
        echo "Examples :"
        echo " $0 -h stg-emea-inbox-mgmt-rw-vip.us.daas.grpn "
        echo ""
        exit 1
}

# Validate Arguments

while [ "$#" -gt 0 ]; do
        case "$1" in
                -h) GDS="$2"; shift 2;;
                 -*) echo "unknown option: $1" >&2; usage; exit 1;;
                *) echo "unrecognized argument: $1"; usage; exit 1;;
        esac
done
## Validation Steps to help ensure the script will run successfully.
[ -z $GDS ] && echo "ERROR: You have not specified the GDS database server" && usage && exit 1 || echo "Found GDS database server $GDS"

echo ""


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
echo ""

# Find the node in the YML File and determine if it's MySQL or Postgres

FILE_LENGTH=`cat $YML_FILE | wc -l`
echo "Please wait while searching through the YML file for the correct node to show whitelisted hosts!"
echo ""

while [ $LINE_NUMBER -lt $FILE_LENGTH ]
do
        line=`head -$LINE_NUMBER $YML_FILE | tail -1`
        #echo "$LINE_NUMBER $line"
                # Scanning every line in the YML file

                if [ `echo "$line" | grep 'type:' | wc -l` -gt 0 ]; then
                        TYPE_LINE=$LINE_NUMBER
                fi

                [ `echo "$line" | grep 'firewall_permitted_src_cidrs:' | wc -l` -gt 0 ] && FIREWALL_START_LINE=$LINE_NUMBER
                [ `echo "$line" | grep 'dba_account_name:' | wc -l` -gt 0 ] && DBA_ACCOUNT_LINE=$LINE_NUMBER
                [ `echo "$line" | grep 'dba_src_cidrs:' | wc -l` -gt 0 ] && DBA_SRC_LINE=$LINE_NUMBER
                [ `echo "$line" | grep 'ports:' | wc -l` -gt 0 ] && SECTION_COMPLETE=1 && PORT_LINE=$LINE_NUMBER

               if [ $SECTION_COMPLETE -eq 1 ]; then
                   #echo $LINE_NUMBER $line
                        # Check the section to see if it contains the IP address that we are looking for.
                        #echo "Checking for $GDS_IP in $YML_FILE from $TYPE_LINE to $PORT_LINE plus $FIREWALL_START_LINE"
                        FIND_NODE=`/usr/bin/sed -n $TYPE_LINE,$PORT_LINE"p" $YML_FILE | grep -w $GDS_IP | wc -l`
                        if [ $FIND_NODE -gt 0 ]; then
                                echo ""
                                echo "FOUND $GDS_IP in the YML file for the following node"
                                echo ""
				DBA_ACCOUNT_LINE=$((DBA_ACCOUNT_LINE-1))
				/usr/bin/sed -n $FIREWALL_START_LINE,$DBA_ACCOUNT_LINE"p" $YML_FILE
                                echo ""
                                echo ""
                                echo ""
                                echo "ALL COMPLETE"
                                echo ""
                                cd ~/
                                exit 1
                        fi
                        SECTION_COMPLETE=0
                        #       sleep 3
                fi

        LINE_NUMBER=$((LINE_NUMBER+1))
        FILE_LENGTH=`cat $YML_FILE | wc -l`
done
