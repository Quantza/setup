#!/bin/bash

# num of input arguments
if [ $# -eq 0 ]
	then
	    echo "No arguments supplied (Provide genesis block). Exiting..."
		exit 1
else
	ethconsole --frontier -b --genesis "$1" -i -m on --G 2>>$HOME/logs/eth_mine.log
fi



