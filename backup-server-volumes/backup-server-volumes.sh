#!/bin/sh

set -u

# Obtain the instance id for the server to be backed up
eval $(openstack server show ${SERVER_ID} -fshell --prefix instance_)

# Creating an image backup  "server image create" will:
#    1. Attempt to quiesce the server I/O
#    2. Perform a snapshot of every volume attached to the server
#    3. Attempt to unquiesce the server I/O
SECONDS=0
eval $(openstack server image create -fshell --prefix backup_image_ --name ${SERVER_ID}_backup ${instance_id})
echo Snapshot time: ${SECONDS}s

# Identify the list of snapshots that are attached to the backup image
eval $(openstack image show ${backup_image_id} -fshell -c properties)
snapshot_list=$(echo ${properties} | grep -oP 'snapshot_id": "\K[^"]+')
backup_timestamp=$(date -Ihours)

# The backup image is no longer needed
openstack image delete ${backup_image_id}


# Loop the volumes, creating a backup and then deleting
SECONDS=0
number=0
for snapshot_id in ${snapshot_list}; do
    backup_name="${instance_id}.${backup_timestamp}.${number}"
    eval $(openstack volume snapshot show ${snapshot_id} -fshell -c volume_id -c size)
    eval $(openstack volume backup create -fshell --prefix backup_ --force \
    	--snapshot ${snapshot_id} ${volume_id} --name "${backup_name}" \
	--description "Vol.${number}")
   
    # Wait for the backup status to make sure we backup the metadata
    available=0
    echo "Waiting for the backup status to be available"
    while [ $available == 0 ]; do
	available=$(openstack volume backup show ${backup_id} -fshell -c status|grep -c "available")
        sleep 10
    done
    cinder backup-export ${backup_id} > ${backup_name}.${number}.meta
    number=$(expr ${number} + 1)
done
echo "Backup time: ${SECONDS}s"
