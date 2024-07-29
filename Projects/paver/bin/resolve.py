#!/usr/bin/env python2.7

""" Resolver ... because every broken DNS deserves a resolver hack! :) """

__author__ = "Robert Barabas"
__email__ = "rbarabas@groupon.com"
__version__ = "0.1"

import re
import sys
from dns import resolver, reversename

def is_ip(token):
    """ simple but incomplete pattern match """
    if re.match(r'([0-9]{1,3}[.]){3}([0-9]{1,3})', token):
        return True
    else:
        return False

def trim_prefix(addr):
    """ trims prefix """
    return re.sub(r'^(.*)[/][0-9]+$', r'\1', addr)

def lookup_host(host, method='dns'):
    ipaddr = None
    if method == 'simple':
        try:
            ipaddr = socket.gethostbyname(host)
            ipaddr = ipaddr[0]
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
                    ipaddr = r.query(host, "A")
                except:
                    continue
                ipaddr = ipaddr[0]
                return ipaddr
    return ipaddr


def lookup_ip(ipaddr, method='dns'):
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

def parseargs():
    """ Coming next season... """
    pass

def main():
    for token in sys.argv[1:]:
        if is_ip(token):
            print( " [*] {0} -> {1}".format(token, lookup_ip(token)))
        else:
            print( " [*] {0} -> {1}".format(token, lookup_host(token)))

if __name__ == "__main__":
    main()
