#!/bin/bash

# Initial Tools

sudo apt-get update
sudo apt-get install -y git curl wget
git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

chmod a+x ./bin_scripts/symlink_binaries.sh
source ./bin_scripts/symlink_binaries.sh
