#!/bin/bash

target=$1
cmd=$3
round=$2
i=0
#sleep-time=$(( $RANDOM % 10 + 1 ))

echo "Command is: printf '${cmd}\\n' | nc -N ${target} 80" >> "/purple/results/${round}/commands.txt"

printf "${cmd}\n" | nc -N $target 80 >> "/purple/results/${round}/results.txt"


