#!/bin/bash

target=$1
i=0

while [ $i -ne -1 ] 
do
	echo "iteration ${i}" >> "/purple/results/rand.txt"
	printf "hostname >> /purple/results/res.txt\n" | nc -N $target 80
	i=$(($i+1))
	#sleep 1 
done

