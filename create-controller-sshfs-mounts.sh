#!/bin/sh
set -eu

source ~/stackrc

mkdir -p ~/logs

controllers_list=$(nova list | egrep "controller.*Running" | awk '{print $4","$12}')
for controller in $controllers_list; do
    
	name=$(echo $controller|cut -d "," -f1)
        ctl_ip=$(echo $controller|cut -d"," -f2| cut -d"=" -f2)
	echo $name $ctl_ip
        logs_dir=~/logs/$name
        mkdir -p $logs_dir
        sshfs heat-admin@$ctl_ip:/var/log/containers $logs_dir
done
