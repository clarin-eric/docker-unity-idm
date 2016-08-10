#!/bin/bash
set -e

URL="https://shibboleth-sp/Shibboleth.sso/Metadata"
FILE="/data/metadata/sp-metadata.xml"

if [ ! -f ${FILE} ]; then
    printf "Waiting for SP."
    until $(curl --output /dev/null --silent --head --fail --insecure ${URL}); do
        printf '.'
        sleep 1
    done
    printf " Done\n"

    printf "Downloading metadata."
    curl -o ${FILE}.tmp --insecure --silent ${URL}
    echo '<?xml version="1.0" encoding="UTF-8"?>' >> ${FILE}
    echo '<md:EntitiesDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mdattr="urn:oasis:names:tc:SAML:metadata:attribute" xmlns:mdrpi="urn:oasis:names:tc:SAML:metadata:rpi" xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" xmlns:shibmd="urn:mace:shibboleth:metadata:1.0" xmlns:xrd="http://docs.oasis-open.org/ns/xri/xrd-1.0">' >> ${FILE}
    cat ${FILE}.tmp >> ${FILE}
    echo '</md:EntitiesDescriptor>' >> ${FILE}
    printf ' Done\n'

    printf "Restarting unity."
    supervisorctl restart unity-idm  > /dev/null 2>&1
    printf " Done\n"
else
    echo "Metadata file [${FILE}] already exists"
fi