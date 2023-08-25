# SSID-Docker

This project is an improvement of previous works on Stepping Stone Intrusion Detection (SSID). Automation is the focus to mantain flexibilty as well as seemless experiment integrity for each round of samples. Using Docker, this project simulates network activity as if there were stepping stone attacks occuring, all while collecting network traffic samples. 

This project can be used to create data sets on SSID to be using for machine learning applications.

# Documentation

##IMPORTANT NOTE

**THIS IS THE DEV BRANCH OF THE PROJECT AT ANY GIVEN MOMENT THE CODE MAY NOT BE FUNCTIONING AND THE DOCUMENTATION MAY BE INCOMPLETE

USE WITH CAUTION

This README is often out of date while in devlopment**


## Running

requirements:
* docker daemon running
* venv environment set up with scapy installed
* change value in /SSH_MODEL/.env to YOUR repo dir

terminal:
$ chmod 700 docker-external.sh  
$ sudo ./docker-external.sh  
** enter prompt values**
program takes care of everything else!

## Triggering Structure
(1) docker-external.sh -->   
(2) compose-bash.sh & ssh-config.sh -->  
(3) docker-compose.yml -->  
(4) internal.py-->  
(5) listener.sh & launch.sh   


## Files & Uses
docker-external.sh : 
* takes user input for devices, rounds, and scan time
* Manages experiment loop and docker container management

compose-bash.sh : 
* generates a dynamic docker-compose.yml based on configured options for each experiment
* Takes the following parameters "compose-batch.sh $devices $round $scan_time $subnet $gateway $network_name

ssh-config.sh
* generates dynamic ssh config file for each docker container for each experiment

internal.py
* Manges internal functions for each container
* Starts tcpdump on every host, start listener.sh on all but the first contianer, and starts launch.sh on the first container

listener.sh
* A simple script to start a ncat listener.
* Can be expended in the future for other commands and ports

launch.sh
* Handels builidng the tunnel, and sending data through it
* Uses a tmux loop to construct the tunnel by laaunching new connections as shells in the next hop opern'
* Uses tmux again to send commands at random intervals through the tunnel to the target for an indefinte period of time

## Available Models

Available protocols for tunnel segments:

- SSH
    * ssh $target -4: a simple ipv4 ssh tunnel to the given target, resvolved with confimration information on every system.
- NCAT
    * Uses the ncat to utility to create a connection to port 80 as quasi-http traffic

Future:
    - ncat on other ports
    - Realistic HTTP, DNS traffic


## Management Commands

To see currently running containers:
docker ps

To see all containers:
docker ps -a

To enter any container within instance:
    docker exec -it <container ID> bash

To rebuild all instances with updated Dockerfile: 
    docker-compose up --build

To stop docker containers:
docker stop <container ID>

To remove docker containers:
docker rm <container ID>
