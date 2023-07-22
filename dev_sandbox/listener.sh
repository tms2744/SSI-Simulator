#!/bin/bash

num=$1
round=$2
shared_dir=$3

echo "I'm listening" > "/purple/results/data.txt"
nc -lk > "/purple/results/${round}/${num}/data.txt"
