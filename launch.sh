#!/bin/bash

round=$1
chain_length=$2
c=0
cc=3
i=0

echo "${cmd}" >> "/purple/results/${round}/cmds.txt"

tmux new -d -s mySession

tmux send-keys -t mySession.0 "/bin/bash -i" Enter

while [ $c -ne $chain_length ]
do
	cmd=${@:$cc:3}
	echo "Round ${c}: cc=${cc}, cc+3=$(($cc+3)): ${cmd}" >> "/purple/results/${round}/exec"
	tmux send-keys -t mySession.0 "${cmd}" Enter
	c=$(($c+1))
	cc=$(($cc+3))
done

sudo tmux send-keys -t mySession.0 "hostname" Enter

tc qdisc add dev eth0 root netem delay 500ms


while [ $i -ne -1 ]
do
	sleep_time=$(( $RANDOM % 10 + 1 ))
	cmd2=$(shuf -n 1 /purple/cmd.txt)
	tmux send-keys -t mySession.0 "${cmd2}" Enter
	echo "${cmd2}"
	i=$(($i+1))
	sleep $sleep_time
done

