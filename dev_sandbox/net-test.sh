#!/bin/bash

target=$1
i=0

while [ $i -ne -1 ] 
do
	printf "This is test #${i}\n" | nc $target 80
done

