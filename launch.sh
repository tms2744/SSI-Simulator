#!/bin/bash

round=$1
#alt_cmd=$2
chain_length=$2
#cmds= ${@:3}
params=${@:3}
cmds=( $params)
c=0
cc=3
i=0

#echo "${alt_cmd}" >> "/purple/results/${round}/alt_cmds.txt"
echo "${cmd}" >> "/purple/results/${round}/cmds.txt"

tmux new -d -s mySession

tmux send-keys -t mySession.0 "/bin/bash -i" Enter

tmux send-keys -t mySession.0 "${cmds}" Enter

while [ $c -ne $chain_length ]
do
	cmd=${@:$cc:3}
	echo "Round ${c}: cc=${cc}, cc+3=$(($cc+3)): ${cmd}" >> "/purple/results/${round}/exec"
	tmux send-keys -t mySession.0 "${cmd}" Enter
	c=$(($c+1))
	cc=$(($cc+3))
done

sudo tmux send-keys -t mySession.0 "hostname" Enter

#tc qdisc add dev eth0 root netem delay 100ms


while [ $i -ne -1 ]
do
#	sudo tc qdisc add dev eth0 root netem delay 100ms
	sleep_time=$(( $RANDOM % 10 + 1 ))
	cmd2=$(shuf -n 1 /purple/cmd.txt)
	tmux send-keys -t mySession.0 "${cmd2}" Enter
	echo "${cmd2}"
	i=$(($i+1))
	sleep $sleep_time
done
#| sudo bash -i ${cmd}

