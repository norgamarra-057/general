#!/usr/bin/env python2.7

"""Generates inventory files from ops-config"""

__author__ = "Robert Barabas"
__email__ = "rbarabas@groupon.com"
__version__ = "0.1"

import os
import re
import sys
import yaml

def getfiles(path):
    l = []
    for f in os.listdir(path):
        if os.path.isfile(os.path.join(path, f)):
            l.append(f)
    return l

class autodict(dict):
    """Creates keys automatically if they don't exist"""
    def __getitem__(self, item):
        try:
            return dict.__getitem__(self, item)
        except KeyError:
            value = self[item] = type(self)()
            return value

class OpsConfig(object):
    """Represents the ops-config repo"""
    def __init__(self, **kwargs):
        default_repodir = "{0}/src/ops-config".format(os.path.expanduser('~'))
        self.repodir = kwargs.get('repodir', default_repodir)
        self.hostsdir = "{0}/hosts/".format(self.repodir)
        self.check()
        self.hostfiles = getfiles(self.hostsdir)
        self.hosts = {}

    def check(self):
        if not os.path.isdir(self.repodir):
            m = "could not find ops-config repository under {0}"
            print(m.format(self.repodir))
            sys.exit(2)
        if not os.path.isdir(self.hostsdir):
            m = "could not find hosts under {0}"
            print(m.format(self.hostsdir))
            sys.exit(3)

    def host(self, hostname):
        hostfile = self.hostsdir + hostname + '.yml'
        if not os.path.isfile(hostfile):
            print("host not found")
            sys.exit(1)
        with open(hostfile, 'r') as f:
            d = yaml.load(f)
            return d

    def find_gds_hosts(self):
        gds_host_re = 'gds-(.)+'
        gdshosts = []
        for hostfile in getfiles(self.hostsdir):
            if re.match(gds_host_re, hostfile):
                host = re.sub('(.+)[.]yml', r'\1', hostfile)
                gdshosts.append(host)
        return gdshosts

class Inventory(object):
    def __init__(self, **kwargs):
        self.hosts = kwargs.get('hosts', None)
        self.config = autodict()
        default_rootdir = '{0}/..'.format(os.path.dirname(sys.argv[0]))
        self.rootdir = kwargs.get('rootdir', default_rootdir)
        self.invdir = '{0}/inventory/opsconfig/'.format(self.rootdir)
        self.parsehosts()

    def parsehosts(self):
        grpn_re = r'(?P<hostname>[\w-]+)[.](?P<datacenter>[\w]+)'
        gds_tags = (
            'gds',
            '(?P<datacenter2>[a-z]+[0-9])',
            '(?P<environment>[a-z]+)',
            '(?P<hostname>db[l]?[0-9]+[msgz][0-9]+)',
        )
        gds_re = '-'.join(gds_tags)
        for host in self.hosts:
            m = re.match(grpn_re, host)
            if m == None:
                print("hostname {0} garbled, skipping".format(host))
                continue
            hostname = m.group('hostname')
            datacenter = m.group('datacenter')
            m = re.match(gds_re, hostname)
            if m == None:
                environment = 'support'
            else:
                environment = m.group('environment')
            self.config[datacenter][environment][host]

    def dump(self):
        for datacenter in self.config.keys():
            for environment in self.config[datacenter].keys():
                filename = "{0}-{1}-{2}".format('gds', environment, datacenter)
                hosts = self.config[datacenter][environment].keys()
                hosts.sort()
                with open('{0}/{1}'.format(self.invdir, filename), 'w') as f:
                    print("writing {0}".format(filename))
                    f.write("[{0}]\n".format(filename))
                    f.write("\n".join(hosts))

def main():
    opsc = OpsConfig()
    inventory = Inventory(hosts=opsc.find_gds_hosts())
    inventory.dump()

if __name__ == "__main__":
    main()
