#!/bin/bash

THREAD_COUNT=1

#num of input arguments
# $1 = path to genesis block
# $2 = number of threads to use for mining.

if [ $# -lt "1" ]
	then
	    echo "Not enough arguments supplied. Exiting..."
		exit 1
elif [ $# -eq "1" ]
	then
	    echo "Using 1 thread to mine."
else
	THREAD_COUNT="$2"
	echo "Using ""$THREAD_COUNT"" threads to mine."
fi

geth --genesis "$1" --mine --minerthreads="$THREAD_COUNT" 2>>~/logs/geth_mining.log

