#!/bin/bash

<< comment

This is a simple script for cleaning up folders& docker containers after experiemts
Helpful before a push to github to reduce unneeded data

comment


sudo rm -rf $(pwd)/tcpdump
sudo rm -rf $(pwd)/results
mkdir $(pwd)/tcpdump
mkdir $(pwd)/results



# docker ps -qa|xargs docker rm -f
