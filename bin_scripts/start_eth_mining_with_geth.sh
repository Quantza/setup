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

geth --rpccorsdomain localhost 2>>$HOME/logs/geth_console.log &
ethminer -G 2>>$HOME/logs/eth_mine.log

