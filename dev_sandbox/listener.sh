#!/bin/bash

num=$1
total=$2
round=$3
shared_dir=$4
timeout=$5
loop=0

echo "I'm listening" > "/purple/results/data.txt"
#echo "Again" > "${shared_dir}/results/${round}/dsta${num}.txt"

if [ $num == $total ]; then
	#nc -lk 80 >> "${shared_dir}/results/${round}/net_data${num}.txt"
	nc -lk 80 >> /bin/bash
	#echo "Hi There"
else
	mkfifo backpipe
	echo "172.50.0.$(($num+2))"
	nc -lk 80 <backpipe | nc "172.50.0.$(($num+2))" 80 1>backpipe
fi

#while [ $loop -ne -1 ]
#do
#	nc -lk 80 >> "${shared_dir}/results/${round}/net_data${num}.txt"
#done

