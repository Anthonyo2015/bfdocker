#!/bin/bash
printf "Building remote db configuration of BigFix\n"
# build docker image with the evaluation edition of BigFix server (besserver)
cd /vagrant/besserver/remotedb
# Set version
BES_VERSION=$1
# Set licence type
LICENSE_TYPE=$2
# Set the default response file to auth
BES_INSTALL_FILE="/bes-install-auth.rsp"
# Docker compose file name
dockerComposeFile="docker-compose.yml"
# YAML file creation function
function createComposeFile {
    echo "# Remote database container (service)" > $dockerComposeFile
    echo "remdb:" >> $dockerComposeFile
    echo "  image: ibmcom/db2express-c" >> $dockerComposeFile
    echo "  command: db2start" >> $dockerComposeFile
    echo "  container_name: remdb.mybigfix.com" >> $dockerComposeFile
    echo "  environment:" >> $dockerComposeFile
    echo "    DB2INST1_PASSWORD: BigFix1t4Me" >> $dockerComposeFile
    echo "    LICENSE: accept" >> $dockerComposeFile
    echo "  ports:" >> $dockerComposeFile
    echo "    - \"50000:50000\"" >> $dockerComposeFile
    printf "\n#BigFix server\n" >> $dockerComposeFile
    echo "besserver:" >> $dockerComposeFile
    echo "  build: ." >> $dockerComposeFile
    echo "  command: /bes-start.sh" >> $dockerComposeFile
    echo "  container_name: eval.mybigfix.com" >> $dockerComposeFile
    echo "  environment:" >> $dockerComposeFile
    echo "    DB2INST1_PASSWORD: BigFix1t4Me" >> $dockerComposeFile
    echo "    LICENSE: accept" >> $dockerComposeFile
    echo "    BES_INSTALL_FILE: $BES_INSTALL_FILE" >> $dockerComposeFile
    echo "  hostname: eval" >> $dockerComposeFile
    echo "  domainname: mybigfix.com" >> $dockerComposeFile
    echo "  links:" >> $dockerComposeFile
    echo "    - remdb:remdb.mybigfix.com" >> $dockerComposeFile
    echo "  ports:" >> $dockerComposeFile
    echo "    - \"52311:52311\"" >> $dockerComposeFile
    echo "    - \"52311:52311/udp\"" >> $dockerComposeFile
    echo "    - \"8080:8080\"" >> $dockerComposeFile
}

printf "License Type: $LICENSE_TYPE\n"
if [[ "$LICENSE_TYPE" == "auth" ]]
then
    # Set to bes-install-auth.rsp
    BES_INSTALL_FILE="/bes-install-auth.rsp"
    createComposeFile
elif [[ "$LICENSE_TYPE" == "prod" ]]
then
    # Set to bes-install-prod.rsp
    BES_INSTALL_FILE="/bes-install-prod.rsp"
    createComposeFile
else
    # Abort
    printf "Licence type not recognized, aborting...\n"
    exit
fi

# start a docker container running BigFix server (besserver)
/usr/local/bin/docker-compose up -d