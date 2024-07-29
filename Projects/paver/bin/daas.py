#!/usr/bin/env python2.7

""" DaaS CLI """

__author__ = "Robert Barabas"
__email__ = "rbarabas@groupon.com"
__version__ = "0.1"

import os
import re
import sys
import glob
import yaml
import argparse
import socket

from dns import resolver, reversename

class DaaSInstance(object):
    def __init__(self, name, **kwargs):
        self.name = str(name)
        self.type = kwargs.get('type', None)
        if self.type == None:
            raise Exception("incorrect instance specification")
        required = set()
        optional = set()
        ignore = set([
            'name',
            'type',
            'required',
            'optional',
            'ignore'
        ])
        self.required = kwargs.get('required', required)
        self.optional = kwargs.get('optional', optional)
        self.ignore = kwargs.get('ignore', ignore)
        for k, v in kwargs.items():
            setattr(self, k, v)

    def __str__(self):
        return self.name

    def to_yaml(self):
        return yaml.dump(self.__dict__, default_flow_style=False)

    def check_keys(self):
        errcount = 0
        for k in self.required:
            found = self.__dict__.get(k, None)
            if found == None:
                errcount += 1
                print(" [!] {0} reqired key missing: {1}".format(self.name, k))
        possible_keys = {}
        for k in (self.required | self.optional | self.ignore):
            possible_keys[k] = 1
        for k in self.__dict__.keys():
            found = possible_keys.get(k, None)
            if found == None:
                errcount += 1
                print(" [!] {0} extra key present: {1}".format(self.name, k))
        return errcount

    def check_name_length(self, limit=22):
        length_check = len(self.name) > limit
        if length_check == True:
            m = " [!] instance name {0} too long (> {1})"
            print(m.format(self.name, limit))
        return length_check

    def check_vip_resolve(self, type='all'):
        errcount = 0
        def check_reverse(ip):
            ip = trim_ip(ip)
            hostname = lookup_ip(ip, method='dns')
            if hostname == None:
                print(" [!] {0} has no reverse".format(ip))
                return 1
            return 0
        if type == 'all' or type == 'admin':
            if hasattr(self, 'admin_redirect_peers'):
                for ip in self.admin_redirect_peers:
                    errcount += check_reverse(ip)
        if type == 'all' or type == 'dba':
            for ip in self.dba_src_cidrs:
                errcount += check_reverse(ip)
        if type == 'all' or type == 'firewall':
            for ip in self.firewall_permitted_src_cidrs:
                errcount += check_reverse(ip)
        return errcount

    def check(self):
        errcount = 0
        errcount += self.check_name_length()
        errcount += self.check_keys()
        errcount += self.check_vip_resolve()
        return errcount

class MySQLDaaSInstance(DaaSInstance):
    def __init__(self, name, **kwargs):
        super(MySQLDaaSInstance, self).__init__(name, **kwargs)
        required = set([
            'type',
            'write_origin',
            'firewall_priority',
            'unix_user',
            'nodes',
            'master_carp_interface',
            'slave_carp_interface',
            'vhid',
            'slave_vhid',
            'replication_ips',
            'firewall_permitted_src_cidrs',
            'dba_account_name',
            'dba_src_cidrs',
            'ports',
            'master_vip',
            'slave_vips',
        ])
        optional = set([
            'admin_redirect_peers',
            'mysqld_options',
            'playback_enabled',
            'playback',
        ])
        self.required = kwargs.get('required', required)
        self.optional = kwargs.get('optional', optional)

    def check(self):
        return super(MySQLDaaSInstance, self).check()

class PostgreSQLDaaSInstance(DaaSInstance):
    def __init__(self, name, **kwargs):
        super(PostgreSQLDaaSInstance, self).__init__(name, **kwargs)
        required = set([
            'type',
            'dbnames',
            'write_origin',
            'firewall_priority',
            'unix_user',
            'master_vip',
            'slave_vips',
            'replication_ips',
            'firewall_permitted_src_cidrs',
            'dba_account_name',
            'dba_src_cidrs',
            'ports',
        ])
        optional = set([
            'admin_redirect_peers',
            'extra_variables',
        ])
        self.required = kwargs.get('required', required)
        self.optional = kwargs.get('optional', optional)

    def check(self):
        return super(PostgreSQLDaaSInstance, self).check()

class DaaSHost(object):
    def __init__(self):
        pass

class DaaSCluster(object):
    def __init__(self, name, path, **kwargs):
        self.name = str(name)
        self.path = path
        if self.name == None or self.path == None:
            raise Exception("initialization error")
        self.instances = {}

    def parse_yaml(self):
        with open(self.path, 'r') as f:
            self.__yaml = yaml.load(f)

    def find_instances(self):
        self.parse_yaml()
        instances = []
        instances = self.__yaml.get('gds_instances', None)
        for k, v in instances.items():
            instance_type = v.get('type', None)
            if instance_type == None:
                continue
            if instance_type == 'mysql':
                self.instances[k] = MySQLDaaSInstance(k, **v)
            elif instance_type == 'postgresql':
                self.instances[k] = PostgreSQLDaaSInstance(k, **v)

    def getinstance(self, name):
        return self.instances[name]

    def __str__(self):
        return self.name

    def to_yaml(self):
        return yaml.dump(self.__dict__, default_flow_style=False)

    def write(self):
        """ Not implemented yet"""
        return
        with open(self.path, 'w') as f:
            f.write(self.yaml)

    def check_instance_ports(self):
        errcount = 0
        ports = {}
        for instance in self.instances:
            i = self.getinstance(instance)
            for port_type, port in i.ports.items():
                found = ports.get(port, None)
                if found == None:
                    ports[port] = [i.name]
                else:
                    ports[port].append(i.name)
                    m = " [!] dupicate port definition found: {0}, instances: {1}"
                    print(m.format(port, ', '.join(ports[port])))
                    errcount += 1
        return errcount

    def check(self):
        errcount = 0
        errcount += self.check_instance_ports()
        return errcount

    def get_instances(self, instance_spec=None, instance_type=None):
        l = []
        spec = None
        if instance_spec != None:
            spec = re.compile("{0}".format(instance_spec))
        for name, instance in self.instances.items():
            if spec == None:
                if instance_type == None:
                    l.append(instance)
                elif instance_type == instance.type:
                    l.append(instance)
            elif spec.search(name):
                if instance_type == None:
                    l.append(instance)
                elif instance_type == instance.type:
                    l.append(instance)
        return l

class DaaSInventory(object):
    def __init__(self, **kwargs):
        mydir = os.path.abspath(os.path.dirname(sys.argv[0]))
        self.root = kwargs.get('root', mydir)
        self.path = kwargs.get('path', '{0}/../inventory/'.format(self.root))
        self.dcs = kwargs.get('dcs', ['dub', 'sac', 'snc', 'lup'])
        self.envs = kwargs.get('envs', ['dev', 'prod', 'stg', 'uat', 'test'])
        self.dcs_re = '({0})'.format('|'.join(self.dcs))
        self.envs_re = '({0})'.format('|'.join(self.envs))
        daas_re ='gds_{0}[0-9]_{1}_db[0-9]*'.format(self.dcs_re, self.envs_re)
        self.daas_re = daas_re
        self.clusters = {}

    def find_clusters(self):
        group_vars = [f for f in glob.glob("{0}/group_vars/*.yml".format(self.path))]
        for v in group_vars:
            if v.endswith('.yml'):
                path = v
                name = os.path.basename(v[:-4])
                if re.match(self.daas_re, name):
                    self.clusters[name] = DaaSCluster(name, path)

    def get_cluster(self, name):
        return self.clusters[name]

    def get_clusters(self, cluster_spec):
        l = []
        spec = None
        if cluster_spec != None:
            spec = re.compile("{0}".format(cluster_spec))
        for name, cluster in self.clusters.items():
            if spec == None:
                l.append(cluster)
            elif spec.search(name):
                l.append(cluster)
        return l

def parse_args():
    valid_instances = ['mysql', 'postgresql']
    valid_accesses = ['firewall', 'dba', 'admin', 'simple']
    p = argparse.ArgumentParser(description="Management utility for DaaS")
    sp = p.add_subparsers(help="avilable subcommands", dest='subcommand')

    c_cmds = sp.add_parser('cluster', help='cluster management commands')
    sp_cluster = c_cmds.add_subparsers(help="available cluster commands",
                                       dest='cluster_subcommand')
    list_cluster = sp_cluster.add_parser('list', help='list clusters')
    list_cluster.add_argument('cluster', help='cluster name',
                              default=None, nargs='?')
    list_cluster.add_argument('-u', '--unformatted', help='print without formatting',
                              default=False, action='store_true')
    show_cluster = sp_cluster.add_parser('show', help='show cluster')
    show_cluster.add_argument('cluster', help='cluster name')
    add_cluster = sp_cluster.add_parser('add', help='add cluster')
    del_cluster = sp_cluster.add_parser('del', help='del cluster')
    mod_cluster = sp_cluster.add_parser('mod', help='mod cluster')

    e_cmds = sp.add_parser('environment',  help='environment management commands')
    sp_environment = e_cmds.add_subparsers(help="available environment commands",
                                           dest='environment_subcommand')
    list_environment = sp_environment.add_parser('list', help='list environments')
    show_environment = sp_environment.add_parser('show', help='show environment')
    add_environment = sp_environment.add_parser('add', help='add environment')
    del_environment = sp_environment.add_parser('del', help='del environment')
    mod_environment = sp_environment.add_parser('mod', help='mod environment')

    i_cmds = sp.add_parser('instance', help='instance management commands')
    sp_instance = i_cmds.add_subparsers(help="available instance commands",
                                        dest='instance_subcommand')
    list_instance = sp_instance.add_parser('list', help='list instances')
    list_instance.add_argument('instance', help='instance name',
                              default=None, nargs='?')
    list_instance.add_argument('-c', '--cluster', help='cluster name',
                              default=None, nargs='?')
    list_instance.add_argument('-t', '--type', help='instance type',
                               default=None, choices=valid_instances)
    show_instance = sp_instance.add_parser('show', help='show instance')
    show_instance.add_argument('instance', help='name of instance')
    show_instance.add_argument('-c', '--cluster', help='cluster name',
                              default=None, nargs='?')
    show_instance.add_argument('-t', '--type', help='instance type',
                               default=None, choices=valid_instances)
    add_instance = sp_instance.add_parser('add', help='add instance')
    del_instance = sp_instance.add_parser('del', help='delete instance')
    mod_instance = sp_instance.add_parser('mod', help='modify instance')

    a_cmds = sp.add_parser('access', help='access management commands')
    sp_access = a_cmds.add_subparsers(help="available access commands",
                                      dest='access_subcommand')
    list_access = sp_access.add_parser('list', help='list accesss')
    list_access.add_argument('instance', help='instance name')
    list_access.add_argument('-T', '--instance-type', help='instance type',
                               default=None, choices=valid_accesses)
    list_access.add_argument('-c', '--cluster', help='cluster name',
                              default=None, nargs='?')
    list_access.add_argument('-t', '--type', help='access type',
                               default='simple', choices=valid_accesses)
    show_access = sp_access.add_parser('show', help='show access')
    show_access.add_argument('instance', help='instance name',
                              default=None, nargs='?')
    show_access.add_argument('-c', '--cluster', help='cluster name',
                              default=None, nargs='?')
    show_access.add_argument('-t', '--type', help='access type',
                               default='simple', choices=valid_accesses)
    add_access = sp_access.add_parser('add', help='add access')
    del_access = sp_access.add_parser('del', help='delete access')
    mod_access = sp_access.add_parser('mod', help='modify access')

    v_cmds = sp.add_parser('vip', help='vip management commands')
    sp_vip = v_cmds.add_subparsers(help="available vip commands",
                                   dest='vip_subcommand')
    list_vip = sp_vip.add_parser('list', help='list vips')
    show_vip = sp_vip.add_parser('show', help='show vip')
    add_vip = sp_vip.add_parser('add', help='add vip')
    del_vip = sp_vip.add_parser('del', help='delete vip')
    mod_vip = sp_vip.add_parser('mod', help='modify vip')

    check_cmd = sp.add_parser('check', help='run consistency checks')
    check_cmd.add_argument('-i', '--instance', help='instance name',
                           default=None, nargs='?')
    check_cmd.add_argument('-c', '--cluster', help='cluster name',
                           default=None, nargs='?')
    check_cmd.add_argument('-t', '--type', help='instance type',
                           default=None, choices=valid_instances)

    return vars(p.parse_args())

def check_consistency(**args):
    cluster_spec = args.get('cluster', None)
    instance_type = args.get('type', None)
    instance_spec = args.get('instance', None)
    errors = 0
    inventory = DaaSInventory()
    inventory.find_clusters()
    clusters = inventory.get_clusters(cluster_spec)
    for cluster in clusters:
        cluster.find_instances()
        instances = cluster.get_instances(instance_spec, instance_type)
        if len(instances) > 0:
            print(" [o] checking {0}".format(cluster.name))
        for instance in instances:
            print("  `--> {0}".format(instance.name))
            errors += instance.check()
        if len(instances) > 0:
            errors += cluster.check()
    print("\nErrors found: {0}".format(errors))

def list_clusters(**args):
    unformatted_spec = args.get('unformatted', None)
    inventory = DaaSInventory()
    inventory.find_clusters()
    cluster_spec = args.get('cluster', None)
    clusters = inventory.get_clusters(cluster_spec)
    for cluster in clusters:
        if unformatted_spec == None:
            print(" [*] {0}".format(cluster))
        else:
            print(cluster)

def show_clusters(**args):
    cluster_spec = args.get('cluster', None)
    if cluster_spec == None:
        raise Exception("cluster name required")
    inventory = DaaSInventory()
    inventory.find_clusters()
    clusters = inventory.get_clusters(cluster_spec)
    for cluster in clusters:
        cluster.find_instances()
        print(cluster.to_yaml())

def print_instances(cluster, instances):
    mysql_instances = []
    pgsql_instances = []
    for instance in instances:
        if instance.type == 'mysql':
            mysql_instances.append(instance)
        elif instance.type == 'postgresql':
            pgsql_instances.append(instance)
    all_found = len(mysql_instances) + len(pgsql_instances)
    if all_found > 0:
        print("--- {0} ---".format(cluster.name))
    for m in sorted(mysql_instances, key=lambda i: i.name):
        print(" [M] {0}".format(m))
    for p in sorted(pgsql_instances, key=lambda i: i.name):
        print(" [P] {0}".format(p))
    if all_found > 0:
        print

def list_instances(**args):
    cluster_spec = args.get('cluster', None)
    instance_spec = args.get('instance', None)
    instance_type = args.get('type', None)
    inventory = DaaSInventory()
    inventory.find_clusters()
    clusters = inventory.get_clusters(cluster_spec)
    for cluster in clusters:
        cluster.find_instances()
        instances = cluster.get_instances(instance_spec, instance_type)
        print_instances(cluster, instances)

def show_instances(**args):
    cluster_spec = args.get('cluster', None)
    instance_spec = args.get('instance', None)
    instance_type = args.get('type', None)
    inventory = DaaSInventory()
    inventory.find_clusters()
    clusters = inventory.get_clusters(cluster_spec)
    for cluster in clusters:
        cluster.find_instances()
        instances = cluster.get_instances(instance_spec, instance_type)
        for instance in instances:
            print(instance.to_yaml())

def list_accesses(**args):
    cluster_spec = args.get('cluster', None)
    instance_spec = args.get('instance', None)
    instance_type = args.get('instance_type', None)
    access_type = args.get('type', None)
    inventory = DaaSInventory()
    inventory.find_clusters()
    clusters = inventory.get_clusters(cluster_spec)
    for cluster in clusters:
        cluster.find_instances()
        instances = cluster.get_instances(instance_spec, instance_type)
        for instance in instances:
            print(" [*] {0} ==> {1}".format(cluster.name, instance.name))
            if access_type == 'simple' or access_type == 'firewall':
                for ip in sorted(instance.firewall_permitted_src_cidrs):
                    host = lookup_ip(trim_ip(ip))
                    print("    [F] {0:18} ({1})".format(ip, host))
            if access_type == 'simple' or access_type == 'dba':
                for ip in sorted(instance.dba_src_cidrs):
                    host = lookup_ip(trim_ip(ip))
                    print("    [D] {0:18} ({1})".format(ip, host))
            if access_type == 'admin':
                for ip in sorted(instance.admin_redirect_peers):
                    host = lookup_ip(trim_ip(ip))
                    print("    [A] {0:18} ({1})".format(ip, host))
            print


def list_vips(**args):
    cluster_spec = args.get('cluster', None)
    instance_spec = args.get('instance', None)
    instance_type = args.get('instance_type', None)
    access_type = args.get('type', None)
    inventory = DaaSInventory()
    inventory.find_clusters()
    clusters = inventory.get_clusters(cluster_spec)
    for cluster in clusters:
        cluster.find_instances()
        instances = cluster.get_instances(instance_spec, instance_type)
        for instance in instances:
            print(" [*] {0} ==> {1}".format(cluster.name, instance.name))
            if vip_type == 'simple' or vip_type == 'firewall':
                for ip in sorted(instance.firewall_permitted_src_cidrs):
                    host = lookup_ip(trim_ip(ip))
                    print("    [F] {0:18} ({1})".format(ipaddr, host))
            if vip_type == 'simple' or vip_type == 'dba':
                for ip in sorted(instance.dba_src_cidrs):
                    host = lookup_ip(trim_ip(ip))
                    print("    [D] {0:18} ({1})".format(ip, host))
            if access_type == 'admin':
                for ip in sorted(instance.admin_redirect_peers):
                    host = lookup_ip(trim_ip(ip))
                    print("    [A] {0:15} ({1})".format(ipaddr, host))

def trim_ip(ip):
    return re.sub(r'^(.*)[/][0-9]+$', r'\1', ip)

def lookup_ip(ipaddr, method='simple'):
    host = None
    if method == 'simple':
        try:
            host = socket.gethostbyaddr(ipaddr)
            host = host[0]
        except:
            pass
    elif method == 'dns':
        dns_servers = [
            '10.20.8.33', # SNC1
            '10.32.116.4', # SAC1
            '10.8.139.11', # LUP1
            '10.12.188.3', # DUB1
        ]
        for server in dns_servers:
                r = resolver.Resolver()
                r.nameservers = [server]
                try:
                    addr = reversename.from_address(ipaddr)
                except Exception as e:
                    print(e)
                try:
                    host = r.query(addr, "PTR")
                except:
                    continue
                host = host[0]
                return host
    return host

def main():
    args = parse_args()
    action = args.get('subcommand', None)

    if action == 'check':
        check_consistency(**args)
    elif action == 'cluster':
        subaction = args.get('cluster_subcommand')
        if subaction == 'list':
            list_clusters(**args)
        if subaction == 'show':
            show_clusters(**args)
        elif subaction == 'add':
            print("not implemented yet")
        elif subaction == 'del':
            print("not implemented yet")
        elif subaction == 'mod':
            print("not implemented yet")
    elif action == 'instance':
        subaction = args.get('instance_subcommand')
        if subaction == 'list':
            list_instances(**args)
        if subaction == 'show':
            show_instances(**args)
        elif subaction == 'add':
            print("not implemented yet")
        elif subaction == 'del':
            print("not implemented yet")
        elif subaction == 'mod':
            print("not implemented yet")
    elif action == 'access':
        subaction = args.get('access_subcommand')
        if subaction == 'list' or subaction == 'show':
            list_accesses(**args)
        elif subaction == 'add':
            print("not implemented yet")
        elif subaction == 'del':
            print("not implemented yet")
        elif subaction == 'mod':
            print("not implemented yet")
    elif action == 'vip':
        subaction = args.get('vip_subcommand')
        if subaction == 'list' or subaction == 'show':
            list_vips(**args)
        elif subaction == 'add':
            print("not implemented yet")
        elif subaction == 'del':
            print("not implemented yet")
        elif subaction == 'mod':
            print("not implemented yet")


if __name__ == "__main__":
    main()
