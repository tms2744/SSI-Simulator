#!/bin/bash

target=$1
round=$2
#id=$3
cmd=${@:3}
i=0
#sleep-time=$(( $RANDOM % 10 + 1 ))

echo "ID is: $id, Command is: printf \"${cmd}\\n\" | nc -N ${target} 80" >> "/purple/results/${round}/commands.txt"

#printf "${cmd}\n" | ncat $target 80

printf "${cmd}\n" | ncat -o "/purple/results/${round}/$HOSTNAME.txt" $target 80

#printf "${cmd}\n" | nc -N $target 80 >> "/purple/results/${round}/results.txt"


