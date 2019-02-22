#!/bin/sh

eval $(openstack server image create -fshell --prefix boot_volume --name ${SERVER_ID}_backup ${SERVER_ID})
eval $(openstack image show ${instance_id} -fshell -c properties)

snapshot_list=$(echo ${properties} | grep -oP 'snapshot_id": "\K[^"]+')

for snapshot_id in ${snapshot_list}; do
    eval $(openstack volume snapshot show ${snapshot_id} -fshell -c volume_id -c size)

    # https://access.redhat.com/solutions/2885001
    #cinder create --snapshot-id ${snapshot_id} ${size}
    #openstack volume backup create --force ${volume_id}
done
