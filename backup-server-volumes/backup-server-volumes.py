#!/bin/python
from __future__ import print_function
import os
from sys import stderr
from osauth import os_session, VERSION
from novaclient import client
from pprint import pprint
import argparse

# osvolbackup

def args_parse():
    parser = argparse.ArgumentParser(description='OpenStack Server Volumes Backup')

    parser.add_argument("-s", dest="server_name", required=True)
    return parser.parse_args()

def main():
    args = args_parse()
    nova = client.Client(VERSION, session=os_session)
    server = nova.servers.list(search_opts={"name": args.server_name}, limit=10)
    if len(server) == 0:
        print("No server found with name: %s" % args.server_name, file=stderr)
        exit(1)
    if len(server) > 1:
        print("More than one server with name: %s\nPlease provide and id" % args.server_name, file=stderr)
        exit(1)

    # Check if server contains volumes
    server = server[0]
    server_info = server.to_dict()
    pprint(server_info)
    volume_list = server_info.get('os-extended-volumes:volumes_attached')
    if len(volume_list) == 0:
        print("Server has no volumes attached!")
        exit(2)

    # Create server image
    server_backup_name = server_info['id'] + "_backup"
    server_backup_image_id = server.create_image(server_backup_name)

    for volume in volume_list:
        print(volume['id'])


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        raise