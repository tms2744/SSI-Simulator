#!/bin/bash

num=$1
round=$2
shared_dir=$3
timeout=$4
loop=0

echo "I'm listening" > "/purple/results/data.txt"
#echo "Again" > "${shared_dir}/results/${round}/dsta${num}.txt"

echo "thank you" | nc -lk 80  >> "${shared_dir}/results/${round}/net_data${num}.txt"

#while [ $loop -ne -1 ]
#do
#	nc -lk 80 >> "${shared_dir}/results/${round}/net_data${num}.txt"
#done

