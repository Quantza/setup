#!/bin/bash

isVarDefined "$MY_BIN_DIR"
if [ $? -eq 0 ]; then
	export MY_BIN_DIR="$HOME/bin";
fi

isVarDefined "$MY_GIT_REPO_DIR"
if [ $? -eq 0 ]; then
        export MY_GIT_REPO_DIR="$HOME/GitRepos";
fi

echo Building go-ethereum, cpp-ethereum and mist-wallet...

if [ "$DISTRO_ID" == "ubuntu" ]; then
    $PKG_ADD_REPO_PREFIX -y ppa:george-edison55/cmake-3.x

    $PKG_REFRESH_PREFIX
    $PKG_INSTALL_PREFIX language-pack-en-base
    sudo dpkg-reconfigure locales
    $PKG_INSTALL_PREFIX software-properties-common

    sudo $PKG_ADD_REPO_PREFIX "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.7 main"
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
    $PKG_REFRESH_PREFIX
    $PKG_INSTALL_PREFIX llvm-3.7-dev

    $PKG_ADD_REPO_PREFIX -y ppa:ethereum/ethereum-qt
    $PKG_ADD_REPO_PREFIX -y ppa:ethereum/ethereum
    $PKG_ADD_REPO_PREFIX -y ppa:ethereum/ethereum-dev
    $PKG_REFRESH_PREFIX
    $PKG_UPGRADE_PREFIX

    $PKG_INSTALL_PREFIX build-essential git cmake libboost-all-dev libgmp-dev \
    libleveldb-dev libminiupnpc-dev libreadline-dev libncurses5-dev \
    libcurl4-openssl-dev libcryptopp-dev libmicrohttpd-dev libjsoncpp-dev \
    libargtable2-dev libedit-dev mesa-common-dev ocl-icd-libopencl1 opencl-headers\
    libgoogle-perftools-dev qtbase5-dev qt5-default qtdeclarative5-dev \
    libqt5webkit5-dev libqt5webengine5-dev ocl-icd-dev libv8-dev libz-dev

    $PKG_INSTALL_PREFIX libjson-rpc-cpp-dev
    $PKG_INSTALL_PREFIX qml-module-qtquick-controls qml-module-qtwebengine
elif [ "$DISTRO_ID" == "arch" ]; then
    $PKG_REFRESH_PREFIX git base-devel cmake boost crypto++ leveldb llvm miniupnpc libcl opencl-headers libmicrohttpd qt5-base qt5-webengine

    "$YAOURT_INSTALL_PREFIX"y libjson-rpc-cpp
fi

echo ---cpp-ethereum---
cd $MY_GIT_REPO_DIR

git clone --recursive https://github.com/ethereum/webthree-umbrella.git cpp-ethereum
#git clone --recursive https://github.com/ethereum/cpp-ethereum.git

cd cpp-ethereum

git checkout develop
#git checkout release

# make a build folder and enter into it
mkdir -p build && cd build


if [ "$DISTRO_ID" == "arch" ]; then
    # create build files and specify Ethereum installation folder
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/eth
else
    # create build files
    cmake ..
fi

# 4 threads # Processor with 4 cores == make -j$(nproc)
make -j 4

# install the resulting binaries, shared libraries and header files into /opt
sudo make install

if [ "$DISTRO_ID" == "arch" ]; then
    # Add the folder containing Ethereum shared libraries into LD_LIBRARY_PATH environmental variable:
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/eth/lib" >> ~/.bashrc
    source ~/.bashrc
fi
echo ---cpp-ethereum was compiled successfully---

echo ---go-ethereum---
$PKG_INSTALL_PREFIX build-essential libgmp3-dev golang
cd $MY_GIT_REPO_DIR
git clone https://github.com/ethereum/go-ethereum
cd go-ethereum
git checkout master
#git checkout develop
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
curl https://install.meteor.com/ | sh
npm install -g electron-prebuilt@0.37.2
npm install -g gulp

cd $MY_GIT_REPO_DIR
git clone https://github.com/ethereum/mist.git
cd mist
#git checkout master
git checkout develop
git submodule update --init
npm install
gulp update-nodes

echo ---mist-wallet was compiled successfully---
