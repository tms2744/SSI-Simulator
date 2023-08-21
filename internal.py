#!/usr/bin/python3

import sys
import subprocess
import time
import random
import pexpect
from pexpect import popen_spawn
from pexpect import pxssh


if len(sys.argv) < 6:
    raise UserWarning("Please use six or more parameters")

device_num = sys.argv[1]
experiment_num = sys.argv[2]
scan_time = sys.argv[3]
devices = sys.argv[4]
action = sys.argv[5]
#tunnel_type = sys.argv[6]
brk=3

breaks=[]

port=22
target=int(devices)
step=int(device_num)+1
target_ip="172.50.0."+str(step+1)

#print("This is print "+target_ip)
#subprocess.Popen(f"echo This is subprocess {target_ip}", shell=True)

sshtunnel=""

#with open("/opt/config", "w+") as config:
#    for line in config
#    breaks.append(line)

def get_commands(cmdfile):
    cmds=[]
    with open(cmdfile, 'r') as cf:
        for cmd in cf:
            cmds.append(cmd)
    #print(cmds)
    return cmds

def build_tunnel(tunnel_type):
    #For right now aussme the first tunnel is nc

    #For any tunnel of n>=3 i[0]=1, i[1]=2, i[2]=3, even if i[3]=n. A special cases cases will be added later for n=1 and n=2
    
    #This Funtion is currently based on the principle of a nested comd (ssh nc ssh nc) for tunnel interlopability
    #This Funciton specifcally buildislis a string based on agiven array of what protcol each inter-node tunnel will use
    #This string is currently just executed, but there should be a third script to handle feeding commands to it (as SSH ahas no
    #wrapper script
    
    #cmd="sudo /opt/nt.sh dev2 "+experiment_num
    cmd=""
    alt_cmd=""

    #cmd="sudo ssh dev2"
    i=2

    for tunnel in tunnel_type:
        if tunnel == "ssh":
            cmd=cmd+" ssh dev"+str(i)+" -4"
        elif tunnel == "nc":
            cmd=cmd+" ncat dev"+str(i)+" 80"
        else:
            raise UserWarning("please provide appropiately formated sequence")
        i=i+1

    print(cmd)
    tunnel_length=len(tunnel_type)
    with open("/purple/results/prelim", 'w+') as prelim:
        prelim.write(cmd)
        prelim.write(str(alt_cmd))
    subprocess.run(f"sudo timeout {scan_time} /bin/bash /opt/launch.sh {experiment_num} {tunnel_length} {cmd} > /purple/results/{experiment_num}/results.txt", shell=True)

def tunnel_randomizer(tunnel_length, tunnel_types):
    
    c=0
    stages=[]

    while c<tunnel_length:
        stages.append(random.choice(tunnel_types))
        c=c+1
    return stages


#+=======Main method=========+

subprocess.run("service ssh restart", shell=True)
#subprocess.run("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)

#---The following helps to intialize the execution while starting a tcpdump on dev1, it is a bit hacky right now, investiagte
#better soultions as well---"

#print(target)

if int(device_num) == 1 and int(action) != 1:
    subprocess.run("timeout "+scan_time+" tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)
    #isubprocess.run("sudo /bin/bash -c /opt/listener.sh "+device_num+" "+experiment_num+" purple", shell=True)
    tmp = subprocess.Popen("/bin/bash", shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    tmp.communicate(f"python3 /opt/internal.py {device_num} {experiment_num} {scan_time} {devices} 1".encode())
    time.sleep(int(scan_time))
elif int(action) == 1:
    print("New Connection")
    #http_tunnel(str(target_ip), experiment_num)
    tunnel=tunnel_randomizer(4, ["nc", "ssh"])
    build_tunnel(tunnel)
    #build_tunnel(["nc", "ssh", "nc", "ssh"])
else:
    subprocess.run(f"sudo timeout {scan_time} bash /opt/listener.sh {device_num} {devices} {experiment_num} {brk} purple", shell=True)
    subprocess.run("sudo service restart ssh", shell=True)
    subprocess.run("timeout "+scan_time+" tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)
    if int(device_num) == int(devices):
        with open("/opt/bob", 'w+') as b:
            b.write("This is a secret\n")
        with open("/opt/alice", 'w+') as a:
            a.write("This is another secret\n")
        with open("/opt/eve", 'w+') as e:
            e.write("And rounding out the group\n")
        subprocess.run("ls /opt", shell=True)
    time.sleep(int(scan_time))
