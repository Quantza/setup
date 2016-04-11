#!/bin/bash

echo Updating and building go-ethereum and cpp-ethereum...

echo ---go-ethereum---
cd $HOME/GitRepos/go-ethereum
make clean
git pull
#git checkout release/1.3.6
make geth
echo ---go-ethereum was compiled successfully---

echo ---cpp-ethereum---
cd $HOME/GitRepos/cpp-ethereum
git pull
git submodule update --init
git checkout develop
#git checkout release
mkdir build
cd build

# Compile enough for normal usage and with support for the full chain explorer
cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUNDLE=user -DFATDB=1 -DETHASHCL=1 

# 4 threads # Full processor(s) == make -j$(nproc)
make -j4

echo ---cpp-ethereum was compiled successfully---
