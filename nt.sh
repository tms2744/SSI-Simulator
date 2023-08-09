#!/bin/bash

target=$1
cmd=${@:3}
round=$2
id=$4
i=0
#sleep-time=$(( $RANDOM % 10 + 1 ))

echo "Command is: printf '${cmd}\\n' | nc -N ${target} 80" >> "/purple/results/${round}/commands.txt"

if [ "${id}" == "0" ]; then
	tmux new -d -s mySession
	tmyx send-keys -t mySession.0 'printf "${cmd}\n" | ncat -o "/purple/results/${round}/$HOSTNAME.txt" target 80'
	tmux send-keys -t mySession.0 "hostname" Enter
	while [ $i -ne -1 ]
	do
		sleep_time=$(( $RANDOM % 10 + 1 ))
		cmd2=$(shuf -n 1 /purple/cmd.txt)
		tmux send-keys -t mySession.0 "$cmd2" Enter
		i=$(($i+1))
		sleep $sleep_time
	done
else
	printf "${cmd}\n" | ncat -o "/purple/results/${round}/$HOSTNAME.txt" $target 80
fi
#printf "${cmd}\n" | nc -N $target 80 >> "/purple/results/${round}/results.txt"


