#!/bin/bash

# num of input arguments
if [ $# -eq 0 ]
	then
	    echo "No arguments supplied (Provide genesis block). Exiting..."
		exit 1
else
	geth --genesis "$1" console 2>>$HOME/logs/geth_console.log
fi



