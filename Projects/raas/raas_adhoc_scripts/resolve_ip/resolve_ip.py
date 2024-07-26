import argparse
import socket

parser = argparse.ArgumentParser()
parser.add_argument("ip")
args = parser.parse_args()


socket.gethostbyaddr(args.ip)[0]


try:
    socket.gethostbyaddr(ip)[0]
except socket.herror as e:
    print(ip)
