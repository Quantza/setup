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

# Install ruby and set up rvm
rvm reload
rvm install 2.2
rvm install 2.3

rvm list
rvm use 2.3 --default
ruby -v
which ruby

gem install bundler

# Base Tools

$PKG_MAN_REFRESH_PREFIX 
$PKG_MAN_INSTALL_PREFIX git curl wget
git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

# Ubuntu ppas

if [ "$DISTRO_ID" == "ubuntu" ]; then
	# WebUpd8
	sudo add-apt-repository ppa:nilarimogard/webupd8
	#sudo add-apt-repository ppa:webupd8team/java
	sudo add-apt-repository ppa:webupd8team/atom
	sudo add-apt-repository ppa:webupd8team/sublime-text-2

	# Yubikey
	sudo apt-add-repository ppa:yubico/stable

	# Emacs Daily
	sudo add-apt-repository -y ppa:ubuntu-elisp/ppa

	# Wine
	sudo add-apt-repository ppa:ubuntu-wine/ppa

	# Texworks
	sudo add-apt-repository -y ppa:texworks/stable

	# Add the release PGP keys:
	curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

	# Add the "release" channel to your APT sources:
	echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list

fi

$PKG_MAN_REFRESH_PREFIX

# See here: https://thepcspy.com/read/making-ssh-secure/
# http://portforward.com/
# Install ssh-server
$PKG_MAN_INSTALL_PREFIX openssh-server
# default = 22
sudo ufw allow 22
# limit login attempts per time
$PKG_MAN_INSTALL_PREFIX fail2ban

#Install docky
$PKG_MAN_INSTALL_PREFIX docky

#Install tmux
$PKG_MAN_INSTALL_PREFIX tmux

# gparted for partioning and tilda terminal.
$PKG_MAN_INSTALL_PREFIX gparted tilda

# Install yubikey software
$PKG_MAN_REFRESH_PREFIX 
$PKG_MAN_INSTALL_PREFIX libpam-yubico yubikey-personalization-gui yubikey-neo-manager

# Install wine
$PKG_MAN_INSTALL_PREFIX wine wine-tricks

# Install emacs24
#--Build commands--
# http://linuxg.net/how-to-install-emacs-24-4-on-ubuntu-14-10-ubuntu-14-04-and-derivative-systems/
sudo apt-get -qq update
$PKG_MAN_INSTALL_PREFIX emacs24 emacs24-el emacs24-common-non-dfsg

# Install pdf readers
$PKG_MAN_INSTALL_PREFIX xpdf okular

# Webupd8
$PKG_MAN_INSTALL_PREFIX sublime-text atom

# Syncthing
$PKG_MAN_INSTALL_PREFIX syncthing

# Development Tools

# NVIDIA CUDA
# Setup install
CUDA75_DIR=$DEV_DIR/cuda7.5

if [ ! -d $CUDA75_DIR ]; then
    mkdir $CUDA75_DIR
fi

cd $CUDA75_DIR

# Install
wget -v http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run
chmod a+x ./cuda_7.5.18_linux.run
sudo ./cuda_7.5.18_linux.run
#$PKG_MAN_INSTALL_PREFIX ocl-icd-opencl-dev nvidia-cuda-toolkit python-pycuda python3-pycuda

$PKG_MAN_INSTALL_PREFIX libopenblas-dev gfortran

# Set up Clojure with leiningen
cd $HOME/bin
wget -q https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x $HOME/bin/lein
lein

# Install Rust
cd $DEV_DIR/temp
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Install Haskell
$PKG_MAN_INSTALL_PREFIX haskell-platform

# Install elixir
cd $DEV_DIR/temp
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
$PKG_MAN_REFRESH_PREFIX 
$PKG_MAN_INSTALL_PREFIX esl-erlang elixir
export PATH="$PATH:$(which elixir)"
cd $DEV_DIR/temp && rm -rf *.deb

# Install python
$PKG_MAN_INSTALL_PREFIX python python-dev python-pip python3 python3-dev python3-pip build-essential
# python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
sudo pip install -U pip
sudo pip3 install -U pip

# IDLE editor
$PKG_MAN_INSTALL_PREFIX idle-python2* idle-python3* python-tk

# Numpy and Scipy
$PKG_MAN_INSTALL_PREFIX python-numpy python-scipy python-matplotlib python-pandas python-sympy python-nose python-h5py
$PKG_MAN_INSTALL_PREFIX python3-numpy python3-scipy python3-matplotlib python3-pandas python3-nose python3-h5py

#For lxml
$PKG_MAN_INSTALL_PREFIX libxml2-dev
$PKG_MAN_INSTALL_PREFIX libxslt-dev

# virtualenv
sudo -H pip install virtualenv
sudo -H pip install virtualenvwrapper

sudo -H pip3 install virtualenv
sudo -H pip3 install virtualenvwrapper

#http://virtualenvwrapper.readthedocs.org/en/latest/install.html#lazy-loading
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
source /usr/local/bin/virtualenvwrapper_lazy.sh

mkvirtualenv --python=/usr/bin/python2 --no-site-packages py2venv
pip install -U pip
sudo -H pip install coursera-dl pyopenssl requests jupyter
deactivate

mkvirtualenv --python=/usr/bin/python3 --no-site-packages py3venv
pip install -U pip
sudo -H pip install coursera-dl pyopenssl requests jupyter
deactivate

# miniconda: http://conda.pydata.org/miniconda.html

#cd $HOME/bin
#wget -q https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
#wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

#chmod +x Miniconda2-latest-Linux-x86_64.sh
#chmod +x Miniconda3-latest-Linux-x86_64.sh
#./Miniconda2-latest-Linux-x86_64.sh
#./Miniconda3-latest-Linux-x86_64.sh

# Texlive
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

wget -q http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzvf install-tl-unx.tar.gz
cd install-tl-*
chmod +x install-tl
sudo ./install-tl -gui text
cd $HOME
#PATH=/usr/local/texlive/2015:$PATH

# Install texworks
sudo apt-get -y update
sudo apt-get -y upgrade
$PKG_MAN_INSTALL_PREFIX texworks

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# cpp-ethereum dependencies
# https://github.com/ethereum/webthree-umbrella

#sudo add-apt-repository ppa:ethereum/ethereum-qt
#sudo add-apt-repository ppa:ethereum/ethereum
#sudo add-apt-repository ppa:ethereum/ethereum-dev
#$PKG_MAN_REFRESH_PREFIX 
#$PKG_MAN_INSTALL_PREFIX cpp-ethereum mix

# Clone and install go-ethereum and cpp-ethereum...
chmod +x ./bin_scripts/autobuild_eth.sh
source ./bin_scripts/autobuild_eth.sh

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
ln -sb dotfiles/.theanorc .
ln -sb dotfiles/.bashrc_custom .
ln -sb dotfiles/site.cfg .
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

unset DISTRO_ID
