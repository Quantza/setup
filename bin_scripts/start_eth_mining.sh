#!/bin/bash

if [ $# -lt "1" ]
	then
	    echo "Not enough arguments supplied (Provide genesis block). Exiting..."
		exit 1
fi

echo "Using gpu to mine."
eth --frontier -b --genesis-json "$1" -i -m on -G 2>>$HOME/logs/eth_mine.log

