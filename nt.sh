#!/bin/bash

target=$1
round=$2
id=$3
cmd=${@:4}
i=0
#sleep-time=$(( $RANDOM % 10 + 1 ))


#The basic premise is that a perisistnat ncat conneciton is made and commands are randmomly selected and then feed into the first
#node(If ncat is the first tunnel). THere are alot proprms with this however, while nestting works the persistanc edoes not, and
#it is unclear if this due to the "client" or the "server". AS mentioned in alt_internal.py command feeding will bprobably be
#handled by a third script in the near future.

echo "ID is: $id, Command is: printf \"${cmd}\\n\" | nc -N ${target} 80" >> "/purple/results/${round}/commands.txt"

if [ "${id}" == "0" ]; then
	tmux new -d -s mySession
	tmux send-keys -t mySession.0 "printf \"${cmd}\\n\" | ncat -o \"/purple/results/${round}/$HOSTNAME.txt\" ${target} 80" Enter
	tmux send-keys -t mySession.0 "hostname" Enter
	while [ $i -ne -1 ]
	do
		sleep_time=$(( $RANDOM % 10 + 1 ))
		cmd2=$(shuf -n 1 /purple/cmd.txt)
		echo $cmd2 >> "/purple/results/${round}/cmds"
		tmux send-keys -t mySession.0 "$cmd2" Enter
		i=$(($i+1))
		sleep $sleep_time
	done
else
	printf "${cmd}\n" | ncat -o "/purple/results/${round}/$HOSTNAME.txt" $target 80
fi
#printf "${cmd}\n" | nc -N $target 80 >> "/purple/results/${round}/results.txt"


