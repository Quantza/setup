#!/bin/bash

OLDDIR="$PWD"
MIST_DIR="$HOME""/GitRepos/mist"
cd "$MIST_DIR"

electron . --mode mist -- --datadir "/media/quantza-lab/OS/Users/Quantza/AppData/Roaming/Ethereum" console
echo "Exited."

cd "$OLDDIR"
