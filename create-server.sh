#!/bin/sh

set -eu

SERVER_IMAGE="CentOS-7-x86_64-GenericCloud-1809.qcow2"
SERVER_FLAVOR="m1.tiny"

echo Creating bootable volume for server ${SERVER_ID}
eval $(openstack volume create -fshell --prefix boot_volume_ --image ${SERVER_IMAGE} ${SERVER_ID}_boot --size 10 --bootable)

echo Creating server ${SERVER_ID}
eval $(openstack server create -fshell --prefix instance_ --flavor ${SERVER_FLAVOR} --volume ${boot_volume_id} ${SERVER_ID})

openstack server show ${instance_id}
