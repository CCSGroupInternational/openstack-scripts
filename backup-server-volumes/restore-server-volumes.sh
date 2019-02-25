#!/bin/sh

set -u

SERVER_ID=$1

# Obtain the instance id for the server to be backed up
eval $(openstack server show ${SERVER_ID} -fshell --prefix instance_)

SECONDS=0


function list_available_backups(


[[ ! $SERVER_ID =~ \. ]] && list_available_backups

available_backups=$openstack volume backup list -fvalue|egrep "^\S+\s${instance_id}\S+.0")
[[ sed-4.2.2.tar.bz2 =~ tar.bz2$ ]] 
