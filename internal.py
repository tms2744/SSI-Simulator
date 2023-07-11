#!/usr/bin/python3

import sys
import subprocess
import time
import pexpect
from pexpect import popen_spawn
from pexpect import pxssh
#import paramiko

if len(sys.argv) < 5:
    raise UserWarning("Please use two or more parameters")

device_num = sys.argv[1]
experiment_num = sys.argv[2]
scan_time = sys.argv[3]
devices = sys.argv[4]
action = sys.argv[5]


port=22
s_attacker=30
victimsend=45
target=int(device_num)+1
target_ip="172.50.0."+str(target+1)

print(target_ip)

sshtunnel=""

def get_commands(cmdfile):
    cmds=[]
    with open(cmdfile, 'r') as cf:
        for cmd in cf:
            cmds.append(cmd)
    #print(cmds)
    return cmds

def ssh_tunnel(target, port):
    if int(target) <= int(devices):
        #tunnel=subprocess.Popen(f"ssh -A -t -p 22 dev{target}", shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        #tunnel.communicate(f"python3 /opt/internal.py {target} {experiment_num} {scan_time} {devices} 1".encode())
        #tunnel=pexpect.spawn(f"/usr/bin/ssh -A -t -p 22 dev{target}")
        #tunnel.sendline(f"/usr/bin/python3 /opt/internal.py {target} {experiment_num} {scan_time} {devices} 1")
        #tunnel = pxssh.pxssh(options={
        #    "Hostname": "172.50.0."+str(target)+"",
        #    "StrictHostKeyChecking": "no",
        #    "IdentityFile": "~/.ssh/id_rsa",
        #    "UserKnownHostsFile": "/dev/null",
        #    "User": "root"})
        #tunnel = pxssh.pxssh()
        #tunnel.login(target_ip, "root")
        #tunnel.sendline(f"python3 /opt/internal.py {target} {experiment_num} {scan_time} {devices} 1")
        #tunnel.sendline("hostname")
        #tunnel.prompt()
        #print(tunnel.before)
        #tunnel.expect("\n", pexpect.EOF)
        #print("Ito Vera")
        #tunnel.stdin.write(f"python3 /opt/internal.py {target} {experiment_num} {scan_time} {devices} 1".encode())
        proxy=""
        t=int(target)
        while t < int(devices):
            if t == int(devices)-1:
                proxy=proxy+"root@dev"+str(t)
            else:
                proxy=proxy+"root@dev"+str(t)+", "
            t=t+1
        #subprocess.Popen("ssh -A -t -p 22 root@172.50.0.6", shell=True)

        if int(device_num) == 1:
            #tunnel=subprocess.Popen("ssh -J root@dev2,root@dev3,root@dev4 root@dev5", shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
            #tunnel.communicate("hostname".encode())
        #    tunnel=pxssh.pxssh(options={
        #        "Hostname": "172.50.0.2",
        #        "StrictHostKeyChecking": "no",
        #        "IdentityFile": "~/.ssh/id_rsa",
        #        "UserKnownHostsFile": "/dev/null",
        #        "User": "root",
        #        "ProxyJump": "root@172.50.0.3,root@172.50.0.4,root@172.50.0.5"})
        #    tunnel=pxssh.pxssh()
        #    try:
        #        tunnel.login("172.50.0.6", "root")
        #    except pexpect.pxssh.ExceptionPxssh:
        #        pass
            tunnel = pexpect.popen_spawn.PopenSpawn("ssh -J root@dev2,root@dev3,root@dev4 root@dev5")
            tunnel.sendline("cp /opt/bob /purple/results/bob")
            #tunnel.expect("\n")
            tunnel.sendline("cp /opt/alice /purple/results/alice")
            #tunnel.expect("\n")
            tunnel.sendline("cp /opt/eve /purple/results/eve")
            #tunnel.sendline(f"hostname")
            #tunnel.prompt()
            #data = tunnel.before
            #with open ("/purple/results", 'w+') as results:
            #    results.write(data.decode())
        #    subprocess.run(f"echo {data}", shell=True)
        #    subprocess.run("echo SENT", shell=True)
            
        #    cmds=get_commands("/opt/cmd.txt")
            #for cmd in cmds:
                #tunnel.stdin.write(cmd.encode())
                #print(str(res[0]))

#Main method----

subprocess.run("service ssh restart", shell=True)
#subprocess.run("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)

#---The following helps to intialize the execution while starting a tcpdump on dev1, it is a bit hacky right now, investiagte
#better soultions as well---"

print(target)

if int(device_num) == 1 and int(action) != 1:
    subprocess.run("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)
    #subprocess.Popen(["ls", "/"])
    #subprocess.Popen(["ls", "/opt"])
    tmp = subprocess.Popen("/bin/bash", shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    tmp.communicate(f"python3 /opt/internal.py {device_num} {experiment_num} {scan_time} {devices} 1".encode())
    time.sleep(int(scan_time))
    #subprocess.run(["python3", "/opt/internal.py", str(target), str(experiment_num), str(scan_time), str(devices), "1"], shell=True)
    #subprocess.Popen("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)
elif int(action) == 1:
    ssh_tunnel(str(target), 22)
else:
    subprocess.run("sudo service restart ssh", shell=True)
    subprocess.run("timeout 10 tcpdump -i eth0 -U -w /purple/tcpdump/"+experiment_num+"/dev"+device_num+".pcap &", shell=True)
    if int(device_num) == int(devices):
        with open("/opt/bob", 'w+') as b:
            b.write("This is a secret")
        with open("/opt/alice", 'w+') as a:
            a.write("This is another secret")
        with open("/opt/eve", 'w+') as e:
            e.write("And rounding out the group")
        subprocess.run("ls /opt", shell=True)
    time.sleep(int(scan_time))

