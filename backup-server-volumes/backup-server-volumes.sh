#!/bin/sh

set -eu

# Obtain the instance id for the server to be backed up
eval $(openstack server show ${SERVER_ID} -fshell --prefix instance_)

# Creatng an image backup  "server image create" will
#    a) Attempt to quiesce the server I/O
#    b) Perform a snapshot of every volume attached to the server
#    c) Attempt to unquiesce the server I/O
eval $(openstack server image create -fshell --prefix backup_image_ --name ${SERVER_ID}_backup ${instance_id})

# Identify the list of snapshots attached to the backup image
eval $(openstack image show ${backup_image_id} -fshell -c properties)
snapshot_list=$(echo ${properties} | grep -oP 'snapshot_id": "\K[^"]+')

# Loop the volumes, creating a backup and then deleting
number=0
for snapshot_id in ${snapshot_list}; do
    eval $(openstack volume snapshot show ${snapshot_id} -fshell -c volume_id -c size)
    backup_name="${instance_id} ${number} $(date -Ihours)"
    eval $(openstack volume backup create -fshell --prefix backup_ --force ${volume_id} --name "${backup_name}")
    openstack volume snapshot delete ${snapshot_id}
    number=$(expr ${number} + 1)
done

# The backup image is no longer needed
openstack image delete ${backup_image_id}
