#!/bin/bash

GIT_REPO_DIR="$HOME/GitRepos"

echo Updating and building go-ethereum and cpp-ethereum...

echo ---go-ethereum---
cd $GIT_REPO_DIR/go-ethereum
make clean
git pull
#git checkout release/1.3.6
make geth
echo ---go-ethereum was compiled successfully---

echo ---cpp-ethereum---
cd $GIT_REPO_DIR/cpp-ethereum
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

echo ---cpp-ethereum was compiled successfully---

ln -sb $GIT_REPO_DIR/go-ethereum/build/bin/geth $HOME/bin/geth_dev
ln -sb $GIT_REPO_DIR/cpp-ethereum/build/eth/eth $HOME/bin/eth_dev
ln -sb $GIT_REPO_DIR/cpp-ethereum/build/alethzero/alethzero $HOME/bin/alethzero_dev
ln -sb $GIT_REPO_DIR/cpp-ethereum/build/ethminer/ethminer $HOME/bin/ethminer_dev
ln -sb $GIT_REPO_DIR/cpp-ethereum/build/ethconsole/ethconsole $HOME/bin/ethconsole_dev

chmod +x $GIT_REPO_DIR/go-ethereum/build/bin/geth
chmod +x $GIT_REPO_DIR/cpp-ethereum/build/eth/eth
chmod +x $GIT_REPO_DIR/cpp-ethereum/build/alethzero/alethzero
chmod +x $GIT_REPO_DIR/cpp-ethereum/build/ethminer/ethminer
chmod +x $GIT_REPO_DIR/cpp-ethereum/build/ethconsole/ethconsole
