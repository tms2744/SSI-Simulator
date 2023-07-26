#!/usr/bin/python3

import sys
import subprocess
import time
import pexpect
from pexpect import popen_spawn
from pexpect import pxssh
#import paramiko

if len(sys.argv) < 5:
    raise UserWarning("Please use five or more parameters")

device_num = sys.argv[1]
experiment_num = sys.argv[2]
scan_time = sys.argv[3]
devices = sys.argv[4]
action = sys.argv[5]
brk=3

breaks=[]

port=22
s_attacker=30
victimsend=45
target=int(device_num)+1
target_ip="172.50.0."+str(target+1)

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

def http_tunnel(target, experiment_num):
    http = subprocess.Popen("/bin/bash", shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    http.communicate(str("sudo timeout "+scan_time+" bash /opt/net-start.sh "+target+" "+experiment_num).encode())
    #subprocess.run("sudo bash /opt/net-test.sh "+target_ip)

def ssh_tunnel(target, port):
   print("Hello World!") 



#+=======Main method=========+

subprocess.run("service ssh restart", shell=True)
#subprocess.run("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)

#---The following helps to intialize the execution while starting a tcpdump on dev1, it is a bit hacky right now, investiagte
#better soultions as well---"

#print(target)

if int(device_num) == 1 and int(action) != 1:
    subprocess.run("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)
    #isubprocess.run("sudo /bin/bash -c /opt/listener.sh "+device_num+" "+experiment_num+" purple", shell=True)
    tmp = subprocess.Popen("/bin/bash", shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    tmp.communicate(f"python3 /opt/alt_internal.py {device_num} {experiment_num} {scan_time} {devices} 1".encode())
    time.sleep(int(scan_time))
elif int(action) == 1:
    print("New Connection")
    http_tunnel(str(target_ip), experiment_num)
else:
    subprocess.run(f"sudo timeout {scan_time} bash /opt/listener.sh {device_num} {devices} {experiment_num} {brk} purple", shell=True)
    subprocess.run("sudo service restart ssh", shell=True)
    subprocess.run("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)
    if int(device_num) == int(devices):
        with open("/opt/bob", 'w+') as b:
            b.write("This is a secret\n")
        with open("/opt/alice", 'w+') as a:
            a.write("This is another secret\n")
        with open("/opt/eve", 'w+') as e:
            e.write("And rounding out the group\n")
        subprocess.run("ls /opt", shell=True)
    time.sleep(int(scan_time))
