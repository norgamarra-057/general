#!/usr/bin/env python2.7

"""Identify mysql instances that don't have plays"""

__author__ = "Robert Barabas"
__email__ = "rbarabas@groupon.com"
__version__ = "0.1"

import os
import re
import sys
import yaml

def find_vars(path):
    l = []
    gds_re = 'gds_(dub|sac|snc|lup)[0-9]_(prod|stg)_db[0-9]+.yml'
    for f in os.listdir(path):
        m = re.match(gds_re, f)
        if not m:
            continue
        fpath = os.path.join(path, f)
        if os.path.isfile(fpath):
            l.append(fpath)
    return l

def main():
    root_dir = os.path.dirname(sys.argv[0])
    vars_dir = '{0}/../inventory/group_vars/'.format(root_dir)
    play_dir = '{0}/../plays/envs/'.format(root_dir)
    varfiles = find_vars(vars_dir)
    count_mysql_instances = 0
    max_mysql_instances = 0
    for varfile in varfiles:
        cluster = os.path.basename(varfile)
        """Find mysql instances in group_vars"""
        with open(varfile, 'r') as f:
            v = yaml.load(f)
        mysql_instances = set()
        for instance in v['gds_instances']:
            itype = v['gds_instances'][instance].get('type', None)
            if itype == None:
                print(" [!] bogus instance definition in {0}".format(cluster))
            elif itype != 'mysql':
                continue
            mysql_instances.add(instance)
        """Look up playbook for this cluster"""
        ppath = os.path.join(play_dir, cluster)
        if not os.path.isfile(ppath):
            print(" [o] no playbook for: {0} (postgres?)".format(cluster))
            continue
        """Find mysql role defs in playbook"""
        with open(ppath, 'r') as f:
            p = yaml.load(f)
        playbook_mysql_instances = set()
        for item in p[0]['roles']:
            role = item.get('role', None)
            if role == None or role != 'gds-mysql-ha':
                continue
            instance = item.get('instance', None)
            if instance == None:
                print(" [!] bogus mysql instance def in {0}".format(cluster))
                continue
            playbook_mysql_instances.add(instance)
        """Look for discrepancies"""
        n1 = len(mysql_instances)
        n2 = len(playbook_mysql_instances)
        msg = " [*] {0}: {1} mysql instances in group_vars, {2} in playbook"
        print(msg.format(cluster, n1, n2))
        if n1 > n2:
            print(" [!] mysql instances not in playbook:")
            for i in list(mysql_instances - playbook_mysql_instances):
                print("     [-] {0}".format(i))
            max_mysql_instances += n1
        elif n1 < n2:
            print(" [!] extra mysql instances in playbook:")
            for i in list(playbook_mysql_instances - mysql_instances):
                print("     [+] {0}".format(i))
            max_mysql_instances += n2
        elif mysql_instances != playbook_mysql_instances:
            print("mismatching mysql instances in group_vars vs. playbook")
            print(" [!] group_vars:")
            for i in list(mysql_instances):
                print("     [!] {0}".format(i))
            print(" [!] playbook:")
            for i in list(playbook_mysql_instances):
                print("     [!] {0}".format(i))
            max_mysql_instances += n1
        else:
            count_mysql_instances += n1
            max_mysql_instances += n1
    print "-" * 80
    print(" [_] {0} healthy mysql instance definitions".format(count_mysql_instances))
    print(" [_] {0} mysql instance definitions present".format(max_mysql_instances))

if __name__ == "__main__":
    main()
