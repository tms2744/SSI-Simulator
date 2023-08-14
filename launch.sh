#!/bin/bash

round=$1
cmd= ${@:2}
i=0

echo "${cmd}" >> "/purple/results/${round}/cmds.txt"

tmux new -d -s mySession

#tmux send-keys -t mySession.0 "/bin/bash -i" Enter

#tmux send-keys -t mySession.0 "${cmd}" Enter

while [ $i -ne -1 ]
do
	sleep_time=$(( $RANDOM % 10 + 1 ))
	cmd2=$(shuf -n 1 /purple/cmd.txt)
	#tmux send-keys -t mySession.0 "${cmd2}" Enter
	echo "${cmd2}"
	i=$(($i+1))
	sleep $sleep_time
done | sudo bash -i ${cmd}

