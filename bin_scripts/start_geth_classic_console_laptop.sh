#!/bin/bash

geth --oppose-dao-fork --datadir "/media/quantza-lab/DATA/Ethereum-Classic" --ipcpath $HOME/.ethereum/geth.ipc console
echo "Exited."
