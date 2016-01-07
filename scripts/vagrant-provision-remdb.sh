#!/bin/bash
echo building remote db configuration of BigFix
# build docker image with the evaluation edition of BigFix server (besserver)
cd /vagrant/besserver/remotedb
# Set version
BES_VERSION=$1
# Set licence type
LICENCE_TYPE=$2
# Set the default response file to auth
BES_INSTALL_FILE="/bes-install-auth.rsp"
# YAML file creation function
function createComposeFile {
    "# Remote database container (service)" > tempCompose.yml
    "remdb" >> tempCompose.yml
    "  image: ibmcom/db2express-c" >> tempCompose.yml
    "  command: db2start" >> tempCompose.yml
    "  container_name: " >> tempCompose.yml
}

if [[ "$LICENCE_TYPE" -e "auth" ]]
then
    # Set to bes-install-auth.rsp
    
elif [[ "$LICENCE_TYPE" -e "prod" ]]
then
    # Set to bes-install-prod.rsp
    
else
    # Abort
    printf "Licence type not recognized, aborting...\n"
    exit
fi

# start a docker container running BigFix server (besserver)
/usr/local/bin/docker-compose up -d