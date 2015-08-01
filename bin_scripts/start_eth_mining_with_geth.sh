#!/bin/bash

if [ $# -lt "1" ]
	then
	    echo "Not enough arguments supplied (Provide genesis block). Exiting..."
		exit 1
fi

echo "Using gpu to mine."

geth --genesis "$1" --rpccorsdomain localhost 2>>$HOME/logs/geth_console.log &
ethminer -G 2>>$HOME/logs/eth_mine.log

