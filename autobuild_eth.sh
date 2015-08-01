#!/bin/bash

echo Updating and building go-ethereum and cpp-ethereum...

echo ---go-ethereum---
cd $HOME/GitRepos
git clone https://github.com/ethereum/go-ethereum
cd go-ethereum
git checkout release/1.0.0
git pull
make geth
echo ---go-ethereum was compiled successfully---

echo ---cpp-ethereum---
cd $HOME/GitRepos
git clone https://github.com/ethereum/cpp-ethereum
cd cpp-ethereum
git checkout develop
mkdir build
cd build

# Compile enough for normal usage and with support for the full chain explorer
cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUNDLE=user -DFATDB=1 -DETHASHCL=1 

# 4 threads # Full processor(s) == make -j$(nproc)
make -j4

echo ---cpp-ethereum was compiled successfully---
