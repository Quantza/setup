#!/bin/bash

THREAD_COUNT=1

#num of input arguments
# $1 = path to genesis block
# $2 = number of threads to use for mining.

if [ $# -lt "1" ]
	then
	    echo "Not enough arguments supplied (Provide genesis block). Exiting..."
		exit 1
elif [ $# -eq "1" ]
	then
	    echo "Using 1 thread to mine."
else
	THREAD_COUNT="$2"
	echo "Using ""$THREAD_COUNT"" threads to mine."
fi

#geth_dev --genesis "$1" --datadir "/media/quantza-lab/DATA/Ethereum" --mine --minerthreads="$THREAD_COUNT" 2>>~/logs/geth_mining.log
geth_dev --datadir "/media/quantza-lab/DATA/Ethereum" --mine --minerthreads="$THREAD_COUNT" 2>>~/logs/geth_mining.log
