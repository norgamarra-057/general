#!/usr/bin/env python3

# How to use this script, run the below command.
# ./resolve_my_ip.py <ip-address>
# 
# example:
# ./resolve_my_ip.py 10.228.80.212
# 
# 10.228.80.212 prod-eu-west-1_con_cidrs_eu-west-1c 10.228.80.0/20

import requests  # pip3 install requests
import hcl2      # pip3 install python-hcl2
import io
import ipcalc    # pip3 install ipcalc
import pprint
import json 
import os 
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("ip")
args = parser.parse_args()
# print(args.ip)

def create_index():
    user = "production-fabric"
    repo = "AWSLandingZone"

    url = f"https://api.github.groupondev.com/repos/{user}/{repo}/git/trees/master?recursive=1"
    r = requests.get(url)
    res = r.json()

    git_links=[]
    for file in res["tree"]:
        data1=file["path"]
        if(data1.endswith('region.hcl')):
            git_links.append(f"https://raw.github.groupondev.com/{user}/{repo}/master/{data1}")
            #print(f"https://raw.github.groupondev.com/{user}/{repo}/master/" + data1)


    ip_index_dictionary={}

    for lnk in git_links:   # TESTING slice this list [:10] <=====
        env1=lnk.replace('https://raw.github.groupondev.com/production-fabric/AWSLandingZone/master/terraform/envs/','').replace('/region.hcl','').replace('/','-')
        response=requests.get(lnk)

        file_like_io=io.StringIO(response.text)
        dict_tf = hcl2.load(file_like_io)
        for x in dict_tf.keys():
            if(x.endswith('cidrs')):
                data=dict_tf[x]
                if(isinstance(data,dict)):
                    for x1 in data.keys():
                        if(data[x1]!=""):
                            ip_index_dictionary.update({'_'.join([env1,x,x1]) : data[x1]})
                        # print(env1,x,x1,data[x1])
                if(isinstance(data,list)):
                    for x2 in range(len(data)):
                        for x2a in data[x2].keys():
                            if(data[x2][x2a]!=""):
                                ip_index_dictionary.update({'_'.join([env1,x,x2a]) : data[x2][x2a]})
                            # print(env1,x,x2a,data[x2][x2a])

    #pprint.pprint(ip_index_dictionary)
    ip_index_dictionary.update({"snc1_1": "10.20.0.0/14"})
    ip_index_dictionary.update({"snc1_2": "10.24.0.0/15"})
    ip_index_dictionary.update({"sac1": "10.32.0.0/14"})
    ip_index_dictionary.update({"dub1": "10.12.0.0/14"})
    ip_index_dictionary.update({"VPN-SNC1": "10.60.0.0/16"})
    ip_index_dictionary.update({"VPN-SAC1": "10.36.0.0/16"})
    ip_index_dictionary.update({"VPN-DUB1": "10.37.0.0/16"})

    with open('my_aws_ip_index_dictionary.json', 'w') as fp:
        json.dump(ip_index_dictionary, fp, sort_keys=True, indent=4)


def query_ip(input_ip):

    with open("my_aws_ip_index_dictionary.json", "r") as readfile:
        ip_index_dictionary=json.load(readfile)
        for ip1 in ip_index_dictionary.keys():
            if(input_ip in ipcalc.Network(ip_index_dictionary[ip1])):
                print(input_ip,ip1,ip_index_dictionary[ip1])




def main():
    if(not os.path.isfile('my_aws_ip_index_dictionary.json')):
        create_index()
    query_ip(args.ip)

if __name__ == '__main__':
    main()
