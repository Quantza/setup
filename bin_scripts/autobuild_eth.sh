#!/bin/bash

if [ ! $(isVarDefined $MY_BIN_DIR) ]; then
	MY_BIN_DIR="$HOME/bin";
fi

if [ ! $(isVarDefined $MY_GIT_REPO_DIR) ]; then
	MY_GIT_REPO_DIR="$HOME/GitRepos";
fi

echo Building go-ethereum, cpp-ethereum and mist-wallet...

sudo apt-add-repository ppa:george-edison55/cmake-3.x

sudo apt-get -y update
sudo apt-get -y install language-pack-en-base
sudo dpkg-reconfigure locales
sudo apt-get -y install software-properties-common

sudo add-apt-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.7 main"
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-get -y update
sudo apt-get -y install llvm-3.7-dev

sudo add-apt-repository -y ppa:ethereum/ethereum-qt
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo add-apt-repository -y ppa:ethereum/ethereum-dev
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install build-essential git cmake libboost-all-dev libgmp-dev \
    libleveldb-dev libminiupnpc-dev libreadline-dev libncurses5-dev \
    libcurl4-openssl-dev libcryptopp-dev libmicrohttpd-dev libjsoncpp-dev \
    libargtable2-dev libedit-dev mesa-common-dev ocl-icd-libopencl1 opencl-headers \
    libgoogle-perftools-dev qtbase5-dev qt5-default qtdeclarative5-dev \
    libqt5webkit5-dev libqt5webengine5-dev ocl-icd-dev libv8-dev libz-dev

sudo apt-get -y install libjson-rpc-cpp-dev
sudo apt-get -y install qml-module-qtquick-controls qml-module-qtwebengine

echo ---go-ethereum---
sudo apt-get install -y build-essential libgmp3-dev golang
cd $MY_GIT_REPO_DIR
git clone https://github.com/ethereum/go-ethereum
cd go-ethereum
#git checkout release/1.3.6
make geth
echo ---go-ethereum was compiled successfully---

echo ---cpp-ethereum---
cd $MY_GIT_REPO_DIR
git clone --recursive https://github.com/ethereum/webthree-umbrella.git cpp-ethereum
cd cpp-ethereum
git checkout develop
#git checkout release
mkdir build
cd build

# Compile enough for normal usage and with support for the full chain explorer
cmake ..
#cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUNDLE=user -DFATDB=1 -DETHASHCL=1 

# 4 threads # Full processor(s) == make -j$(nproc)
make -j4

ln -sb $MY_GIT_REPO_DIR/go-ethereum/build/bin/geth $MY_BIN_DIR/geth_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/eth/eth $MY_BIN_DIR/eth_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/alethzero/alethzero $MY_BIN_DIR/alethzero_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/ethminer/ethminer $MY_BIN_DIR/ethminer_dev
ln -sb $MY_GIT_REPO_DIR/cpp-ethereum/build/ethconsole/ethconsole $MY_BIN_DIR/ethconsole_dev

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
