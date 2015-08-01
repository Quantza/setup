#!/bin/bash

# num of input arguments
if [ $# -eq 0 ]
	then
	    echo "No arguments supplied. Exiting..."
		exit 1
else
	geth --genesis "$1" console 2>>~/logs/geth_console.log
fi



