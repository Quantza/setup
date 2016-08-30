#!/bin/bash

isVarDefined "$MY_BIN_DIR"
if [ $? -eq 0 ]; then
	export MY_BIN_DIR="$HOME/bin";
fi

isVarDefined "$MY_GIT_REPO_DIR"
if [ $? -eq 0 ]; then
        export MY_GIT_REPO_DIR="$HOME/GitRepos";
fi

echo Updating and building go-ethereum, cpp-ethereum and mist-wallet...

echo ---cpp-ethereum---
cd $MY_GIT_REPO_DIR/cpp-ethereum
git pull
git submodule update --init
git checkout develop
#git checkout release
mkdir -p build && cd build

if [ "$DISTRO_ID" == "arch" ]; then
    # create build files and specify Ethereum installation folder
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/eth
else
    # create build files
    cmake ..
fi

# 4 threads # Full processor(s) == make -j$(nproc)
make -j4

sudo make install
echo ---cpp-ethereum was compiled successfully---

echo ---go-ethereum---
cd $MY_GIT_REPO_DIR/go-ethereum
make clean
git pull
git checkout master
#git checkout develop
git pull
make geth
echo ---go-ethereum was compiled successfully---

GETH_SUFFIX=go-ethereum/build/bin/geth
ETH_SUFFIX=cpp-ethereum/build/eth/eth
ALETH_SUFFIX=cpp-ethereum/build/alethzero/alethzero
ETHMINER_SUFFIX=cpp-ethereum/build/libethereum/ethminer

ln -sb "$MY_GIT_REPO_DIR"/"$GETH_SUFFIX" "$MY_BIN_DIR"/geth
ln -sb "$MY_GIT_REPO_DIR"/"$ETH_SUFFIX" "$MY_BIN_DIR"/eth
ln -sb "$MY_GIT_REPO_DIR"/"$ALETH_SUFFIX" "$MY_BIN_DIR"/alethzero
ln -sb "$MY_GIT_REPO_DIR"/"$ETHMINER_SUFFIX" "$MY_BIN_DIR"/ethminer

chmod +x "$MY_GIT_REPO_DIR"/"$GETH_SUFFIX"
chmod +x "$MY_GIT_REPO_DIR"/"$ETH_SUFFIX"
#chmod +x "$MY_GIT_REPO_DIR"/"$ALETH_SUFFIX"
chmod +x "$MY_GIT_REPO_DIR"/"$ETHMINER_SUFFIX"
echo ---finished creating symlinks---

echo ---mist-wallet---
# Source: https://github.com/ethereum/mist
cd $HOME
# Need this, if not installed: #curl https://install.meteor.com/ | sh
npm install -g electron-prebuilt@0.37.2

cd $MY_GIT_REPO_DIR
cd mist
git pull
git checkout master
#git checkout develop
git pull && git submodule update
npm install
gulp update-nodes

echo ---mist-wallet was compiled successfully---
