#!/bin/bash

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

DEV_DIR="$HOME/dev"
if [ ! -d $DEV_DIR ]; then
    mkdir $DEV_DIR
    mkdir $DEV_DIR/Projects
fi

if [ ! -d $DEV_DIR/temp ]; then
    mkdir $DEV_DIR/temp
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

if [ ! -d $HOME/Projects ]; then
    mkdir $HOME/Projects
fi

if [ ! -d $HOME/courseraDL ]; then
    mkdir $HOME/courseraDL
fi

if [ ! -d $HOME/edxDL ]; then
    mkdir $HOME/edxDL
fi

#Install ruby and set up rvm
rvm reload
rvm install ruby
rvm list
rvm alias create default ruby-2.2.2
sudo gem install bundler

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git curl

# Set up Clojure with leiningen
cd $HOME/bin
wget -q -0 https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x $HOME/bin/lein
lein

# Install Rust
cd $DEV_DIR/temp
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Install Haskell
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:hvr/ghc
sudo apt-get update
sudo apt-get install -y cabal-install-1.20 ghc-7.8.4
cat >> ~/.bashrc <<EOF
export PATH="\$HOME/.cabal/bin:/opt/cabal/1.20/bin:/opt/ghc/7.8.4/bin:\$PATH"
EOF
export PATH=~/.cabal/bin:/opt/cabal/1.20/bin:/opt/ghc/7.8.4/bin:$PATH
cabal update
cabal install alex happy

# Install elixir
cd $DEV_DIR/temp
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install elixir
export PATH="$PATH:$(which elixir)"
cd $DEV_DIR/temp && rm -rf *.deb

# Install python
sudo apt-get install -y python-dev python-pip
# python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
sudo pip install -U pip

# IDLE editor
sudo apt-get install -y idle-python2* idle-python3* python-tk

# virtualenv
sudo -H pip install virtualenv
sudo -H pip install virtualenvwrapper

#http://virtualenvwrapper.readthedocs.org/en/latest/install.html#lazy-loading
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
source /usr/local/bin/virtualenvwrapper_lazy.sh

mkvirtualenv --python=/usr/bin/python2 --no-site-packages venv_python2
pip install -U pip
sudo -H pip install coursera-dl pyopenssl requests
deactivate
mkvirtualenv --python=/usr/bin/python3 --no-site-packages venv_python3
pip install -U pip
sudo -H pip install coursera-dl pyopenssl requests
deactivate

#For lxml
sudo apt-get install libxml2-dev
sudo apt-get install libxslt-dev


sudo add-apt-repository ppa:ubuntu-wine/ppa
sudo apt-get install -y docky wine wine1.7

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

# cpp-ethereum dependencies
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

sudo apt-get -y install build-essential git cmake libboost-all-dev libgmp-dev libleveldb-dev libminiupnpc-dev libreadline-dev libncurses5-dev libcurl4-openssl-dev libcryptopp-dev libjson-rpc-cpp-dev libmicrohttpd-dev libjsoncpp-dev libargtable2-dev llvm-3.8-dev libedit-dev mesa-common-dev ocl-icd-libopencl1 opencl-headers libgoogle-perftools-dev qtbase5-dev qt5-default qtdeclarative5-dev libqt5webkit5-dev libqt5webengine5-dev ocl-icd-dev libv8-dev

# Clone and install go-ethereum and cpp-ethereum...
chmod +x ./autobuild_eth.sh
source ./autobuild_eth.sh

ln -sb $HOME/GitRepos/go-ethereum/build/bin/geth $HOME/bin/geth_dev
ln -sb $HOME/GitRepos/cpp-ethereum/build/eth/eth $HOME/bin/eth_dev
ln -sb $HOME/GitRepos/cpp-ethereum/build/alethzero/alethzero $HOME/bin/alethzero_dev
ln -sb $HOME/GitRepos/cpp-ethereum/build/ethminer/ethminer $HOME/bin/ethminer_dev
ln -sb $HOME/GitRepos/cpp-ethereum/build/ethconsole/ethconsole $HOME/bin/ethconsole_dev

chmod +x $HOME/GitRepos/go-ethereum/build/bin/geth
chmod +x $HOME/GitRepos/cpp-ethereum/build/eth/eth
chmod +x $HOME/GitRepos/cpp-ethereum/build/alethzero/alethzero
chmod +x $HOME/GitRepos/cpp-ethereum/build/ethminer/ethminer
chmod +x $HOME/GitRepos/cpp-ethereum/build/ethconsole/ethconsole

sudo apt-get install -y gparted

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

# Remove old files
CURRENT_TEX_LIVE_VERSION="2015"
TEX_INSTALL_DIR="/usr/local/texlive/""$CURRENT_TEX_LIVE_VERSION"
TEX_USER_DIR="$HOME/.texlive""$CURRENT_TEX_LIVE_VERSION"

if [ ! -d $TEX_INSTALL_DIR ]; then
    rm -rf $TEX_INSTALL_DIR
fi

if [ ! -d $TEX_USER_DIR ]; then
    rm -rf $TEX_USER_DIR
fi

# Setup install
TEX_DIR=$DEV_DIR/texlive
TEX_INSTALL_FILES=$TEX_DIR/install

if [ ! -d $TEX_DIR ]; then
    mkdir $TEX_DIR
fi

if [ ! -d $TEX_INSTALL_FILES ]; then
    mkdir $TEX_INSTALL_FILES
fi

# Get and install tex-live
cd $TEX_INSTALL_FILES

if [ -f install-tl-unx.tar.gz ]; then
    rm install-tl-unx.tar.gz
fi

wget -q -0 http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzvf install-tl-unx.tar.gz
cd install-tl-unx
install-tl -gui text
cd $HOME
#PATH=/usr/local/texlive/2015/bin/i386-linux:$PATH

# Install texworks
sudo add-apt-repository -y ppa:texworks/stable
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install -y texworks

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

#node.js
sudo apt-get install -y nodejs

#WebUpd8 Ubuntu ppas

#Main
sudo add-apt-repository ppa:nilarimogard/webupd8

#Oracle Java ppa
#sudo add-apt-repository ppa:webupd8team/java

sudo add-apt-repository ppa:webupd8team/atom
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get install -y syncthing-gtk sublime-text atom

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
