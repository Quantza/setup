#!/bin/bash

if [ ! $(isVarDefined $MY_BIN_DIR) ]; then
	MY_BIN_DIR="$HOME/bin";
fi

if [ ! $(isVarDefined $MY_GIT_REPO_DIR) ]; then
	MY_GIT_REPO_DIR="$HOME/GitRepos";
fi

echo Updating and building go-ethereum, cpp-ethereum and mist-wallet...

echo ---go-ethereum---
cd $MY_GIT_REPO_DIR/go-ethereum
make clean
git pull
#git checkout release/1.3.6
make geth
echo ---go-ethereum was compiled successfully---

echo ---cpp-ethereum---
cd $MY_GIT_REPO_DIR/cpp-ethereum
git pull
git submodule update --init
git checkout develop
#git checkout release
mkdir build
cd build

# Compile enough for normal usage and with support for the full chain explorer
cmake ..
#cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUNDLE=user -DFATDB=1 -DETHASHCL=1 

# 4 threads # Full processor(s) == make -j$(nproc)
make -j4

ln -sb $MY_GIT_REPO_DIR/go-ethereum/build/bin/geth $HOME/bin/geth_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/eth/eth $HOME/bin/eth_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/alethzero/alethzero $HOME/bin/alethzero_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/ethminer/ethminer $HOME/bin/ethminer_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/ethconsole/ethconsole $HOME/bin/ethconsole_dev

chmod +x $MY_GIT_REPO_DIR/go-ethereum/build/bin/geth
chmod +x $MY_GIT_REPO_DIR/cpp-ethereum/build/eth/eth
chmod +x $MY_GIT_REPO_DIR/cpp-ethereum/build/alethzero/alethzero
chmod +x $MY_GIT_REPO_DIR/cpp-ethereum/build/ethminer/ethminer
chmod +x $MY_GIT_REPO_DIR/cpp-ethereum/build/ethconsole/ethconsole

echo ---cpp-ethereum was compiled successfully---

echo ---mist-wallet---
cd $MY_GIT_REPO_DIR
git clone https://github.com/ethereum/mist.git
cd mist
git submodule update --init
npm install

echo ---mist-wallet was compiled successfully---
