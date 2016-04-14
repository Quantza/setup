#!/bin/bash

function isVarDefined {
	local isVarDefinedResult=0
	if [ -z "${$1+xxx}" ]; then
		$isVarDefinedResult=0;
	else
		$isVarDefinedResult=1;
	fi
}

function isVarEmpty {
	local isVarEmpty=0
	if [ -z "$1" ] && [ "${$1+xxx}" = "xxx" ]; then
		$isVarEmpty=1;
	else
		$isVarEmpty=0;
	fi
}

if [ ! isVarDefined $BIN_DIR ]; then
	BIN_DIR="$HOME/bin";
fi

if [ ! isVarDefined $GIT_REPO_DIR ]; then
	GIT_REPO_DIR="$HOME/GitRepos";
fi

echo Updating and building go-ethereum, cpp-ethereum and mist-wallet...

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

echo ---cpp-ethereum was compiled successfully---

echo ---mist-wallet---
cd $GIT_REPO_DIR
git clone https://github.com/ethereum/mist.git
cd mist
git submodule update --init
npm install

echo ---mist-wallet was compiled successfully---
