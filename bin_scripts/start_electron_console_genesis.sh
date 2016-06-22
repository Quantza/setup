#!/bin/bash

OLDDIR="$PWD"
MIST_DIR="$HOME""/GitRepos/mist"
cd "$MIST_DIR"

# num of input arguments
if [ $# -eq 0 ]
	then
	    echo "No arguments supplied (Provide genesis block). Exiting..."
		exit 1
else
	electron . --mode mist -- --genesis "$1" console 2>>$HOME/logs/geth_console.log
fi

cd "$OLDDIR"
