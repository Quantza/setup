#!/bin/bash

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

if [ ! -d $HOME/go ]; then
    mkdir $HOME/go
fi

if [ ! -d $HOME/logs ]; then
    mkdir $HOME/logs
fi

if [ ! -d $HOME/.ssh ]; then
    mkdir $HOME/.ssh
fi

if [ ! -d $HOME/GitRepos ]; then
    mkdir $HOME/GitRepos
fi

#Install ruby and set up rvm
rvm reload
rvm install ruby
rvm list
rvm alias create default ruby-2.2.2
gem install bundler

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git curl

git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

#See here: https://thepcspy.com/read/making-ssh-secure/
#http://portforward.com/
#Install ssh-server
sudo apt-get install -y openssh-server
# default = 22
sudo ufw allow 22 		
#limit login attempts per time	
sudo apt-get install -y fail2ban

#Clone and install go-ethereum
cd $HOME/GitRepos
git clone https://github.com/ethereum/go-ethereum
sudo apt-get install -y libgmp3-dev
cd go-ethereum
git checkout release/1.0.0
git pull
make geth
echo ---go-ethereum was compiled successfully---
ln -sb $HOME/GitRepos/go-ethereum/build/bin/geth $HOME/bin/geth

#Clone and install cpp-ethereum
sudo apt-get -y update
sudo apt-get -y install language-pack-en-base
sudo dpkg-reconfigure locales
sudo apt-get -y install software-properties-common
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty main"
sudo add-apt-repository -y ppa:ethereum/ethereum-qt
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo add-apt-repository -y ppa:ethereum/ethereum-dev
sudo apt-get -y update
sudo apt-get -y upgrade
 
#Install dependencies
sudo apt-get -y install build-essential git cmake libboost-all-dev libgmp-dev libleveldb-dev libminiupnpc-dev libreadline-dev libncurses5-dev libcurl4-openssl-dev libcryptopp-dev libjson-rpc-cpp-dev libmicrohttpd-dev libjsoncpp-dev libargtable2-dev llvm-3.8-dev libedit-dev mesa-common-dev ocl-icd-libopencl1 opencl-headers libgoogle-perftools-dev qtbase5-dev qt5-default qtdeclarative5-dev libqt5webkit5-dev libqt5webengine5-dev ocl-icd-dev libv8-dev

# Clone and install
cd $HOME/GitRepos
git clone https://github.com/ethereum/cpp-ethereum
cd cpp-ethereum
git checkout develop
mkdir build
cd build

# Compile enough for normal usage and with support for the full chain explorer
cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUNDLE=user -DFATDB=1 -DETHASHCL=1 

# 4 threads
make -j4
#Full processor(s) = make -j$(nproc)

ln -sb $HOME/GitRepos/cpp-ethereum/build/eth/eth $HOME/bin/eth
ln -sb $HOME/GitRepos/cpp-ethereum/build/alethzero/alethzero $HOME/bin/alethzero
ln -sb $HOME/GitRepos/cpp-ethereum/build/ethminer/ethminer $HOME/bin/ethminer

chmod +x $HOME/GitRepos/cpp-ethereum/build/eth/eth
chmod +x $HOME/GitRepos/cpp-ethereum/build/alethzero/alethzero
chmod +x $HOME/GitRepos/cpp-ethereum/build/ethminer/ethminer

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
sudo npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
#--Daily--
sudo add-apt-repository -y ppa:ubuntu-elisp/ppa
#--Build commands--
# http://linuxg.net/how-to-install-emacs-24-4-on-ubuntu-14-10-ubuntu-14-04-and-derivative-systems/
sudo apt-get -qq update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

#Install tmux
sudo apt-get install -y tmux

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

#Install restler, cheerio and commander for node.js

#Rest client
npm install restler

#cmdline in js
npm install commander

#To use jQuery on a server - windows-friendly
npm install cheerio

#Web app framework
npm install -g express

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi

if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi

if [ -d .tmux/ ]; then
    mv .tmux .tmux~
fi

if [ -d .vagrant.d/ ]; then
    mv .vagrant.d .vagrant.d~
fi

if [ -d .tools/ ]; then
    mv .tools .tools.old
fi

if [ -f $HOME/start-agent-trigger ]; then
	rm -rf $HOME/start-agent-trigger
fi

git clone git@github.com:Quantza/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.tmux.conf .
ln -sb dotfiles/.gitmessage.txt .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sb dotfiles/tools.sh .
ln -sf dotfiles/.emacs.d .
ln -sf dotfiles/.tmux .
ln -sf dotfiles/.tools .
ln -sf dotfiles/.vagrant.d .

if [ -d .ssh/ ]
then
    cp -R .ssh .ssh.old
    cp dotfiles/.ssh/config ~/.ssh
else
    cp -R dotfiles/.ssh .
    #chmod -vR 644 ~/.ssh/*.pub
fi

chmod -vR 600 ~/.ssh/config
chmod -R 0700 ~/dotfiles/.tools/
