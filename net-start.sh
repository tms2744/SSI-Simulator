#!/bin/bash

target=$1
round=$2
i=0
#sleep-time=$(( $RANDOM % 10 + 1 ))

while [ $i -ne -1 ] 
do
	sleep_time=$(( $RANDOM % 10 + 1 ))
	echo "iteration ${i}, round ${round}" >> "/purple/results/iter.txt"
	cmd=$(shuf -n 1 /purple/cmd.txt)
	printf "${cmd}\n" | nc -N $target 80 >> "/purple/results/${round}/results.txt"
	i=$(($i+1))
	sleep $sleep_time
done

