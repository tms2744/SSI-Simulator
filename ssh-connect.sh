#!/bin/bash

proxy=$1
target=$2
round=$3

echo ${target} ${target_end} ${round}>> "/purple/results/targets.txt"

tmux new -d -s mySession
#tmux split-window -h

tmux send-keys -t mySession.0 "ssh -J ${proxy} ${target} >> /purple/results/${round}/rere.txt" Enter

#tmux a -t mySession
#tmux d -t mySession

i=0

tmux send-keys -t mySession.0 "hostname" Enter

while [ $i -ne -1 ]
do
	sleep_time=$(( $RANDOM % 10 +1 ))
	cmd=$(shuf -n 1 /purple/cmd.txt)
	tmux send-keys -t mySession.0 "$cmd" Enter
	i=$(($i+1))
	sleep $sleep_time
done


#ssh -J ${proxy} ${target}

