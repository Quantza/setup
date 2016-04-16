#!/bin/bash

#cd $HOME

# Setup Version Managers

# Load nvm and install latest production node
# https://nodejs.org/
# Install nvm: node-version manager (for npm)
# https://github.com/creationix/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
source $HOME/.nvm/nvm.sh

# Install nvm
nvm install node
nvm install iojs
# Set node version for new shells
# node == latest version (e.g. 5.0, as is currently)
nvm use node
nvm which node

# For system installed node.js
# nvm use system
# nvm run system --version

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
sudo npm install -g jshint

# Web app framework
sudo npm install -g express

# Install restler, cheerio and commander for node.js

# Rest client
npm install restler

# cmdline in js
npm install commander

# To use jQuery on a server - windows-friendly
npm install cheerio

# node.js
#$PKG_INSTALL_PREFIX nodejs

# Install meteor
curl https://install.meteor.com/ | sh

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
$PKG_INSTALL_PREFIX rlwrap

# Install gvm (for Go)
$PKG_INSTALL_PREFIX curl git mercurial make binutils bison gcc build-essential
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm

# Using go language v1.4.x
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.5
gvm use go1.5 --default
gvm list

# Install rvm (for Ruby)
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable



