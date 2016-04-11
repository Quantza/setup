#!/bin/bash

sudo apt-get install -y git curl wget

#Setup Version Managers
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

# Load nvm and install latest production node
# https://nodejs.org/
source $HOME/.nvm/nvm.sh
nvm install node
nvm install iojs
#Set node version for new shells
# node == latest version (e.g. 5.0, as is currently)
nvm use node
nvm which node

# For system installed node.js
# nvm use system
# nvm run system --version

#Install gvm
sudo apt-get install curl git mercurial make binutils bison gcc build-essential
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm

#Using go language v1.4.x
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.5
gvm use go1.5 --default
gvm list

#Install rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable

