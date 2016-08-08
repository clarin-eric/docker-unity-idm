#!/bin/bash
set -e

HOST=${HOST:-"test"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"the!unity"}

CONF_FILE="/opt/unity-server/conf/unityServer.conf"
IDP_CONF_FILE="/opt/unity-server/conf/endpoints/saml-webidp.properties"
LDAP_CONF_FILE="/opt/unity-server/conf/endpoints/ldap.properties"

function replace {
    echo "${1}"
    sed -i "s/${1}=${2}/${1}=${3}/g" ${CONF_FILE}
}


#Update configuration
echo "**************************"
echo "Updating configuration"
echo "**************************"
replace "unityServer.core.httpServer.advertisedHost" "192.168.59.109" "${HOST}"
replace "unityServer.core.initialAdminPassword" "the!unity" "${ADMIN_PASSWORD}"

#Start unity IDM
#/opt/unity-server/bin/unity-idm-server-start-fg
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

