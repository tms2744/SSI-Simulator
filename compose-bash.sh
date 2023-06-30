#!/bin/bash

# initalize variables
# z=$(($1+2))
z=$(($1))

echo "---compose-bash.sh---"
echo $z

experiment_num=$2
scan_time=$3
subnet=$4
gateway=$5

echo "---scan_time---"
echo ${scan_time}

if [ $6 ]; then
     NETWORK_NAME=$6
else
     NETWORK_NAME="SSID"
fi

SHARED_VOLUME=$(pwd)

START_SSH_PORT=220$z
START_TCP_PORT=999$z
#iaddr=$1+1
ipV4="172.50.0.$(($z+1))"

echo $START_PORT
echo $SHARED_VOLUME
SHARED_VOLUME_HOME=$SHARED_VOLUME:/purple/
OUT=docker-compose.yml

# Create the docker-compose.yml file
echo "version: '3'" > $OUT
echo "services:" >> $OUT

write_entry () {
    echo "  dev$1:" >> $OUT
    echo "    container_name: dev$1" >> $OUT
    echo "    build:" >> $OUT
    echo "      context: ." >> $OUT
    echo "      dockerfile: Dockerfile" >> $OUT
    echo "    ports:" >> $OUT
    # echo '      - "220$1:"' >> docker-compose1.yml
    echo "      - \"${START_SSH_PORT}:22\"" >> $OUT
    echo "      - \"${START_TCP_PORT}:9000\"" >> $OUT
    START_SSH_PORT=$(($START_SSH_PORT-1))
    START_TCP_PORT=$(($START_TCP_PORT-1))
    echo "    networks: " >> $OUT
    echo '       '"${NETWORK_NAME}"':' >> $OUT
    echo "          ipv4_address: 172.50.0.$(($i+1))" >> $OUT
    echo "    hostname: dev$1" >> $OUT
    echo "    volumes:" >> $OUT
    echo '      - '"${SHARED_VOLUME}"':/purple' >> $OUT
    echo '    command: /opt/docker-internal.sh '"${scan_time}"'' >> $OUT
    if [ $2 ]; then
        echo "    depends_on:" >> $OUT
        echo "      - dev$2" >> $OUT
    fi 
    echo "    stdin_open: true" >> $OUT
    echo "    tty: true" >> $OUT
    echo "              " >> $OUT
}

# Write target (victim) host w/ no dependency
write_entry $z
# Write Stepping-stone hosts & attacker (all depending on prior host)
for ((i=z-1; i>0; i--))
do
    j=$(($i+1))   
    write_entry $i $j
done

echo "volumes:" >> $OUT
echo "    purple:" >> $OUT
echo "networks:" >> $OUT
echo '    '"${NETWORK_NAME}"':' >> $OUT
echo "        ipam:" >> $OUT
echo "            driver: default" >> $OUT
echo "            config:" >> $OUT
echo "                - subnet: $subnet" >> $OUT
echo "                  gateway: $gateway" >> $OUT
