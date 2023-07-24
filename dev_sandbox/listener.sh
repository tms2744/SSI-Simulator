#!/bin/bash

num=$1
round=$2
shared_dir=$3
timeout=$4

echo "I'm listening" > "/purple/results/data.txt"
#echo "Again" > "${shared_dir}/results/${round}/dsta${num}.txt"
nc -lk 80  > "${shared_dir}/results/${round}/net_data${num}.txt"



