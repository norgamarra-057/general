#!/usr/bin/env python2.7

# Sometimes we will get a list of servers that have no formatting.  This script will try and parse the hostnames out and potentially format them for you.

import sys
import getopt
import subprocess

delimiter = ' '
hostlist = ''
final_list = []
format_host = False

# Functions

def usage():
    print
    print "Parse and clean up a list of servers"
    print
    print "Usage : "
    print "-d --delimiter=      Description : The delimiter that is seperating each hostname.  Default = ' '"
    print "-f --file=           Description : Specify the files that contains the list of servers to cleanup. Required."
    print "-h --help            Description : Shows the usage of the script."
    print "-F --format          Description : Format host list."
    print
    print "Example : "
    print "%s -d , -f list_hosts" % sys.argv[0]
    print "%s --file=list_hosts" % sys.argv[0]
    print

# Process command line arguments
try:
    myopts, args = getopt.getopt(sys.argv[1:],"f:d:hF",['file=', 'delimiter=','help','format'])
except getopt.GetoptError as e:
    print (str(e))
    usage()
    sys.exit(2)

for o, a in myopts:
    if o in ("-d", "--delimiter"):
        delimiter = a
    elif o in ("-h", "--help"):
	usage()
	sys.exit(0)
    elif o in ("-f", "--file"):
	hostlist = a
    elif o in ("-F", "--format"):
	format_host = True
    else:
        assert False, "unhandled option"

if hostlist == '':
    print "option -f --file is required"
    usage()
    sys.exit(2)

# Display input and output file name passed as the args
with open(hostlist, 'r') as f:
	for read_data in f:
        	splitter = read_data.split(delimiter)
		for s in splitter:
			final = s.strip()
			final_list.append(final)

f.closed

for h in final_list:
	if format_host:
		format_command = "host " + h + " | awk '{print \"      - \"$4 \"/32   #\"}' | sed \"s/$/ $i/g\""
		#print "Executing " + format_command
		host_result = subprocess.Popen(format_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
		host = host_result.stdout.readline().rstrip()
		host = host + "  " + h
		print host
	else:
		print h
