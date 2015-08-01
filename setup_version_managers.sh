#!/bin/bash

#Setup Version Managers
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash

# Load nvm and install latest production node
# https://nodejs.org/
source $HOME/.nvm/nvm.sh
nvm install v0.12.7
nvm use v0.12.7

#Set node version for new shells
nvm alias default 0.12.7

#Install gvm
sudo apt-get install -y mercurial make binutils bison gcc build-essential
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm

#Using go language v1.4.2
gvm install go1.4.2
gvm use go1.4.2 --default

#Install rvm
curl -sSL https://get.rvm.io | bash -s stable
sudo apt-get install -y ruby

