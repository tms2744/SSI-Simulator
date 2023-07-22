#!/bin/bash 

# hard-coded params
FALL_BACK_SCAN_TIME=500
RT_DIR="purple/SSH_TCP_MODEL"
TCP_DIR="/purple/tcpdump"
experiment_num=$(cat purple/round.txt)

echo "---docker-internal.sh---"

if [ $1 ]
then
    scan_time=$1
else
    scan_time=$FALL_BACK_SCAN_TIME   # default scantime
fi

dev_num=$(cat purple/dev-num.txt)
echo $dev_num

tmux new -d -s listner

# Split the window horizontally into two panes
tmux split-window -h

service ssh restart
# echo "alias dev: dev$dev_num"

# netem starting with a random dely between 15 and 35
sudo tc qdisc add dev eth0 root handle 1:0 netem delay 25ms 10ms

echo "---scan_time---"
echo ${scan_time}

cp "~/.ssh/id_rsa" "/purple/$HOSTNAME.ssh"

if [ "$HOSTNAME" == "dev1" ]; then
    echo " [*] Running tmux.sh on $HOSTNAME"
    timeout $scan_time /opt/tmux.sh $experiment_num $scan_time
elif [ "$HOSTNAME" == "dev$dev_num" ]; then
    echo 'alias a="for ((c=1; c<=n-1; c ++)); do echo -n '1'; done; echo hi"' >> ~/.bashrc
    echo " [*] Running tcpdump on $HOSTNAME"
    #timeout $scan_time ping 127.0.0.1
    #tmux send-keys -t listner.0 "nc -lnvp 9000" Enter
    tmux send-keys -t listner.0 "timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/$experiment_num/$HOSTNAME.pcap" Enter
    sleep $scan_time
    tmux kill-session -t listner
    #timeout $scan_time tcpdump -i eth0 -U -w "/purple/tcpdump/$experiment_num/$HOSTNAME.pcap"
    #echo "---- EOL elif----"
else
    echo " [*] Running tcpdump on $HOSTNAME"
    #tmux send-keys -t listner.0 "nc -lnvp 9000" Enter
    tmux send-keys -t listner.0 "timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/$experiment_num/$HOSTNAME.pcap" Enter
    sleep $scan_time
    tmux kill-session -t listner
    #timeout $scan_time tcpdump -i eth0 -U -w "/purple/tcpdump/$experiment_num/$HOSTNAME.pcap"
    #timeout 10 tcpdump  -i eth0 -U -w $TCP_DIR/$experiment_num/$HOSTNAME.pcap
    #echo "----EOL else----"
fi

#tmux kill-session -t listner

