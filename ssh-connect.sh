#!/bin/bash

target=$1
target_end=$2
round=$3

echo ${target} ${target_end}>> "/purple/results/targets.txt"

ssh -J ${target} ${target_end}

