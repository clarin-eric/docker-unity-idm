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
    curl -o ${FILE} --insecure --silent ${URL}
    printf ' Done\n'

    printf "Restarting unity."
    supervisorctl restart unity-idm  > /dev/null 2>&1
    printf " Done\n"
else
    echo "Metadata file [${FILE}] already exists"
fi