#!/bin/bash
set -x

HOST=${HOST:-"test"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"the!unity"}

CONF_FILE="/opt/unity-server/conf/unityServer.conf"

function replace() {
    echo "${1}"
    sed -i "s/${1}=${2}/${1}=${3}/g" ${CONF_FILE}
}


#Update configuration
echo "**************************"
echo "Updating configuration"
echo "**************************"
replace "unityServer.core.httpServer.advertisedHost" "192.168.59.109" ${HOST}
replace "unityServer.core.initialAdminPassword" "the!unity" ${ADMIN_PASSWORD}

#Start unity IDM
/opt/unity-server/bin/unity-idm-server-start-fg

