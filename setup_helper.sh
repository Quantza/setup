#!/bin/bash

OLDDIR="$PWD"

cd "$HOME"

MY_BIN_DIR="$HOME/bin"
if [ ! -d $MY_BIN_DIR ]; then
    mkdir $MY_BIN_DIR
fi

MY_DEV_DIR="$HOME/dev"
if [ ! -d $MY_DEV_DIR ]; then
    mkdir $MY_DEV_DIR
    mkdir $MY_DEV_DIR/Projects
fi

if [ ! -d $MY_DEV_DIR/temp ]; then
    mkdir $MY_DEV_DIR/temp
fi

if [ ! -d "$HOME"/go ]; then
    mkdir "$HOME"/go
fi

if [ ! -d "$HOME"/logs ]; then
    mkdir "$HOME"/logs
fi

if [ ! -d "$HOME"/.ssh ]; then
    mkdir "$HOME"/.ssh
fi

MY_GIT_REPO_DIR="$HOME/GitRepos"
if [ ! -d $MY_GIT_REPO_DIR ]; then
    mkdir $MY_GIT_REPO_DIR
fi

if [ ! -d "$HOME"/Projects ]; then
    mkdir "$HOME"/Projects
fi

if [ ! -d "$HOME"/courseraDL ]; then
    mkdir "$HOME"/courseraDL
fi

if [ ! -d "$HOME"/edxDL ]; then
    mkdir "$HOME"/edxDL
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

$PKG_REFRESH_PREFIX 
$PKG_INSTALL_PREFIX git curl wget
git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

if [ "$DISTRO_ID" == "arch" ]; then
	mkdir "$HOME"/Downloads
	mkdir "$HOME"/Documents
fi

if [ ! -d "$HOME"/bin ]; then
    mkdir "$HOME"/bin
fi

DEV_DIR="$HOME/dev"
if [ ! -d $MY_DEV_DIR ]; then
    mkdir $MY_DEV_DIR
    mkdir $MY_DEV_DIR/Projects
fi

if [ ! -d $MY_DEV_DIR/temp ]; then
    mkdir $MY_DEV_DIR/temp
fi

if [ ! -d "$HOME"/go ]; then
    mkdir "$HOME"/go
fi

if [ ! -d "$HOME"/logs ]; then
    mkdir "$HOME"/logs
fi

if [ ! -d "$HOME"/.ssh ]; then
    mkdir "$HOME"/.ssh
fi

if [ ! -d "$HOME"/GitRepos ]; then
    mkdir "$HOME"/GitRepos
fi

if [ ! -d "$HOME"/Projects ]; then
    mkdir "$HOME"/Projects
fi

if [ ! -d "$HOME"/courseraDL ]; then
    mkdir "$HOME"/courseraDL
fi

if [ ! -d "$HOME"/edxDL ]; then
    mkdir "$HOME"/edxDL
fi

# git pull and install dotfiles
chmod +x "$OLDDIR"/setup-dotfiles.sh
source "$OLDDIR"/setup-dotfiles.sh

# Ubuntu ppas, and Arch config/repos

if [ "$DISTRO_ID" == "ubuntu" ]; then
	sudo bash -c 'echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list'

	# WebUpd8
	sudo add-apt-repository ppa:nilarimogard/webupd8
	sudo add-apt-repository ppa:webupd8team/atom
	sudo add-apt-repository ppa:webupd8team/sublime-text-2
	#sudo add-apt-repository ppa:webupd8team/java

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

	$PKG_REFRESH_PREFIX

elif [ "$DISTRO_ID" == "arch" ]; then
	echo "Enable multilib repository, by uncommenting the multilib] section in '/etc/pacman.conf' (BOTH LINES!!)"
	sudo nano "/etc/pacman.conf"

	# Locale
	localectl set-locale LANG=en_GB.UTF-8
	localectl set-keymap uk
	sudo locale-gen "en_GB.UTF-8"
	
	# sudo update-locale LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8
	
	#echo "export LANGUAGE=en_US.UTF-8
#export LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8">>~/.bashrc_custom

	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX"yu"
	$PKG_INSTALL_PREFIX bash-completion

	# Build and Install yaourt
	$PKG_INSTALL_PREFIX"g" --needed base-devel gcc-libs
	$PKG_INSTALL_PREFIX --needed wget yajl
	
	mkdir -p $MY_DEV_DIR/AUR/ && cd $MY_DEV_DIR/AUR/

	# Install package-query
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz  # download source tarball
	tar xfz package-query.tar.gz  # unpack tarball
	cd package-query && makepkg  # cd and create package from source
	$PKG_INSTALL_SRC_PREFIX package-query*.pkg.tar.xz  # install package - need root privileges

	# Install yaourt
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
	tar xzf yaourt.tar.gz
	cd yaourt && makepkg
	sudo pacman -U yaourt*.pkg.tar.xz

	# List drivers
	
	## Nvidia ##
	sudo $PKG_INSTALL_PREFIX"s" | grep nvidia

	## AMD/ATI ##
	sudo $PKG_INSTALL_PREFIX"s" | grep ATI
	sudo $PKG_INSTALL_PREFIX"s" | grep AMD
		
	## Intel ##
	sudo $PKG_INSTALL_PREFIX"s" | grep intel
	sudo $PKG_INSTALL_PREFIX"s" | grep Intel

	##MULTILIB##

	## Nvidia ##
	sudo $PKG_INSTALL_PREFIX"s" | grep lib32-nvidia

	## AMD/ATI ##
	sudo $PKG_INSTALL_PREFIX"s" | grep lib32-ati
		
	## Intel ##
	sudo $PKG_INSTALL_PREFIX"s" | grep lib32-intel	
	
fi

# Install docky, tmux, tilda
$PKG_INSTALL_PREFIX docky, tmux, tilda

# Install yubikey software
$PKG_INSTALL_PREFIX libpam-yubico yubikey-personalization-gui yubikey-neo-manager

# Install wine
$PKG_INSTALL_PREFIX wine wine-tricks

# limit login attempts per attempt - ssh
$PKG_INSTALL_PREFIX fail2ban

if [ "$DISTRO_ID" == "ubuntu" ]; then

	# See here: https://thepcspy.com/read/making-ssh-secure/
	# http://portforward.com/
	# Install ssh-server
	$PKG_INSTALL_PREFIX openssh-server
	# default = 22
	sudo ufw allow 22

	# Install emacs24.x
	#--Build commands for ubuntu--
	# https://lars.ingebrigtsen.no/2014/11/13/welcome-new-emacs-developers/
	
	$PKG_INSTALL_PREFIX  gcc automake libmagick++-dev libgtk2.0-dev \
	libxft-dev libgnutls-dev libdbus-1-dev libgif-dev texinfo libxpm-dev libacl1 libacl1-dev build-essential
	#$PKG_INSTALL_PREFIX build-dep build-essential
	cd $MY_GIT_REPO_DIR
	git clone git://git.savannah.gnu.org/emacs.git
	cd emacs
	GIT_COMMON_DIR=$MY_GIT_REPO_DIR/emacs
	make
	sudo ./src/emacs &
	ln -sb $MY_GIT_REPO_DIR/emacs $MY_BIN_DIR/emacs
	unset GIT_COMMON_DIR

	# libgtop for system monitoring, and other apps
	$PKG_INSTALL_PREFIX gir1.2-gtop-2.0 pulseaudio pavucontrol \
	gnome-terminal firefox vlc unzip unrar p7zip pidgin skype deluge \
	smplayer qmmp gimp xfburn thunderbird gedit gnome-system-monitor

	# Webupd8
	$PKG_INSTALL_PREFIX sublime-text atom

	# Install pdf readers
	$PKG_INSTALL_PREFIX xpdf okular

	# Install Haskell
	$PKG_INSTALL_PREFIX haskell-platform

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
	TEX_DIR=$MY_DEV_DIR"/texlive"
	TEX_INSTALL_FILES=$TEX_DIR"/install"

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

	wget -qO- http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
	tar -xzvf install-tl-unx.tar.gz
	cd install-tl-*
	chmod +x install-tl
	sudo ./install-tl -gui text

	cd "$HOME"
	#PATH=/usr/local/texlive/2015:$PATH

	# Install texworks
	$PKG_INSTALL_PREFIX texworks

elif [ "$DISTRO_ID" == "arch" ]; then

	# Install other related things...
	sudo yaourt -S gdm3setup ntfs-config

	# emacs
	$PKG_INSTALL_PREFIX --needed build-devel emacs
	
	# For gparted
	$PKG_INSTALL_SRC_PREFIX --needed gparted part mtools btrfs-progs exfat-utils dosfstools ntfs-3g

	# For system monitoring
	$PKG_INSTALL_PREFIX libgtop networkmanager

	# For emulators
	sudo yaourt -S lib32-ncurses
	sudo usermod -a -G games $USER

	# Install Haskell
	$PKG_INSTALL_PREFIX ghc cabal-install haddock happy alex
	
	# For cinnamon
	$PKG_INSTALL_PREFIX xorg-server xorg-xinit xorg-utils xorg-server-utils mesa xorg-twm xterm xorg-xclock

	# cinnamon
	sudo $PKG_INSTALL_PREFIX cinnamon nemo-fileroller

	# nettools (includes ifconfig)
	sudo $PKG_INSTALL_PREFIX net-tools

	# Basic software
	sudo $PKG_INSTALL_PREFIX pulseaudio pulseaudio-alsa pavucontrol \
	gnome-terminal firefox flashplugin vlc chromium unzip unrar p7zip pidgin \
	skype deluge smplayer audacious qmmp gimp xfburn thunderbird gedit gnome-system-monitor

	# Codecs
	sudo $PKG_INSTALL_PREFIX a52dec faac faad2 flac jasper lame libdca libdv \
	libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins
	
	# libreoffice
	sudo $PKG_INSTALL_PREFIX libreoffice

	# Themes
	sudo $PKG_INSTALL_PREFIX faenza-icon-theme numix-themes

	# Install pdf readers
	$PKG_INSTALL_PREFIX evince epdfview

	# Texlive
	$PKG_INSTALL_PREFIX texlive-core texlive-bibtexextra texlive-fontsextra texlive-formatsextra \
	texlive-games texlive-genericextra texlive-htmlxml texlive-humanities texlive-latexextra \
	texlive-music texlive-pictures texlive-plainextra texlive-pstricks texlive-publishers texlive-science
	
	# For GLFW 
	$PKG_INSTALL_SRC_PREFIX --needed libevent-pthreads-2.0.5 doxygen xorg-dev libglu1-mesa-dev
fi

# OpenSSH, OpenPGP and rsync
$PKG_INSTALL_PREFIX openssh pssh rsync seahorse nemo-seahorse gnupg

# Syncthing
$PKG_INSTALL_PREFIX syncthing syncthing-gtk

# Development Tools
$PKG_INSTALL_PREFIX libopenblas-dev gfortran

# Set up Clojure with leiningen
cd $MY_BIN_DIR
wget -qO- https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x $MY_BIN_DIR/lein
lein

# Install Rust
cd $MY_DEV_DIR/temp
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Install elixir
cd $MY_DEV_DIR/temp
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
$PKG_REFRESH_PREFIX 
$PKG_INSTALL_PREFIX esl-erlang elixir
export PATH="$PATH:$(which elixir)"
cd $MY_DEV_DIR/temp && rm -rf *.deb

# Install python
if [ "$DISTRO_ID" == "ubuntu" ]; then
	$PKG_INSTALL_PREFIX python python-dev python-pip python3 python3-dev python3-pip build-essential
	
	# python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
	sudo pip install --upgrade pip
	sudo pip3 install --upgrade pip

	# Python IDLE editor
	$PKG_INSTALL_PREFIX idle-python2* idle-python3* python-tk

	#For lxml
	$PKG_INSTALL_PREFIX libxml2-dev
	$PKG_INSTALL_PREFIX libxslt-dev

	# Download the latest pip package from source
	wget -qO- https://bootstrap.pypa.io/get-pip.py | sudo python3

	# Use pip to upgrade setuptools
	sudo pip install --upgrade setuptools
	sudo pip3 install --upgrade setuptools

	# virtualenv
	sudo -H pip install virtualenv
	sudo -H pip install virtualenvwrapper

	sudo -H pip3 install virtualenv
	sudo -H pip3 install virtualenvwrapper

	sudo pip install jupyter
	sudo pip3 install jupyter

	#http://virtualenvwrapper.readthedocs.org/en/latest/install.html#lazy-loading
	export WORKON_HOME="$HOME"/.virtualenvs
	export PROJECT_HOME="$HOME"/Projects
	VIRTUALENVWRAPPER_PREFIX="/usr/local/bin/virtualenvwrapper"
	
elif [ "$DISTRO_ID" == "arch" ]; then
	$PKG_INSTALL_PREFIX python2 python-pip2 python python-pip3
	$PKG_INSTALL_PREFIX"g" --needed build-devel

	# python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
	sudo pip2 install --upgrade pip
	sudo pip install --upgrade pip

	# For lxml
	$PKG_INSTALL_PREFIX libx32-libxml2 lib32-libxslt

	# Download the latest pip package from source
	wget -qO- https://bootstrap.pypa.io/get-pip.py | sudo python

	# Use pip to upgrade setuptools
	sudo pip2 install --upgrade setuptools
	sudo pip install --upgrade setuptools

	# virtualenv
	$PKG_INSTALL_PREFIX python2-virtualenv python-virtualenv python-virtualenvwrapper python2-virtualenvwrapper
	sudo -H pip2 install virtualenvwrapper
	sudo -H pip install virtualenvwrapper

	sudo pip2 install jupyter
	sudo pip install jupyter

	export WORKON_HOME="$HOME"/.virtualenvs
	export PROJECT_HOME="$HOME"/Projects
	VIRTUALENVWRAPPER_PREFIX="/usr/bin/virtualenvwrapper"

fi

if [ $(isVarDefined "$VIRTUALENVWRAPPER_PREFIX") ] then
	if [ -f "$VIRTUALENVWRAPPER_PREFIX"_lazy.sh  ] then
		export VIRTUALENVWRAPPER_SCRIPT="$VIRTUALENVWRAPPER_PREFIX""_lazy.sh"
		source "$VIRTUALENVWRAPPER_SCRIPT"
	else
		if [ -f "$VIRTUALENVWRAPPER_PREFIX".sh ]; then
			export VIRTUALENVWRAPPER_SCRIPT="$VIRTUALENVWRAPPER_PREFIX"".sh"
			source "$VIRTUALENVWRAPPER_SCRIPT"
		fi
	fi
fi

if [ "$DISTRO_ID" == "ubuntu" ]; then
	mkvirtualenv --python=/usr/bin/python2 --no-site-packages py2venv
	pip install -U pip
	sudo -H pip install coursera-dl pyopenssl requests jupyter
	deactivate
	mkvirtualenv --python=/usr/bin/python3 --no-site-packages py3venv
	pip install -U pip
	sudo -H pip install coursera-dl pyopenssl requests jupyter
	deactivate
	$PKG_INSTALL_PREFIX python python-dev python-pip python3 python3-dev python3-pip build-essential
	
	# Numpy and Scipy
	$PKG_INSTALL_PREFIX python-numpy python-scipy python-matplotlib python-pandas python-sympy python-nose python-h5py
	$PKG_INSTALL_PREFIX python3-numpy python3-scipy python3-matplotlib python3-pandas python3-nose python3-h5py
elif [ "$DISTRO_ID" == "arch" ]; then
	virtualenv --python=/usr/bin/python2 --no-site-packages py2venv
	pip install -U pip
	sudo -H pip install coursera-dl pyopenssl requests jupyter
	deactivate
	virtualenv --python=/usr/bin/python --no-site-packages py3venv
	pip install -U pip
	sudo -H pip install coursera-dl pyopenssl requests jupyter
	deactivate

	# Numpy and Scipy + jupyter or ipython
	$PKG_INSTALL_PREFIX python2-numpy python2-scipy python2-matplotlib python2-pandas python2-nose python2-h5py ipython2-notebook
	$PKG_INSTALL_PREFIX python-numpy python-scipy python-matplotlib python-pandas python-sympy python-nose python-h5py jupyter-notebook
fi

# miniconda: http://conda.pydata.org/miniconda.html

#cd $MY_BIN_DIR
#wget -qO- https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
#wget -qO- https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

#chmod +x Miniconda2-latest-Linux-x86_64.sh
#chmod +x Miniconda3-latest-Linux-x86_64.sh
#./Miniconda2-latest-Linux-x86_64.sh
#./Miniconda3-latest-Linux-x86_64.sh

# Onedrive-d
cd $MY_GIT_REPO_DIR
git clone https://github.com/xybu/onedrive-d.git
cd onedrive-d
python3 setup.py build
sudo python3 setup.py install

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# cpp-ethereum dependencies
# https://github.com/ethereum/webthree-umbrella

#sudo add-apt-repository ppa:ethereum/ethereum-qt
#sudo add-apt-repository ppa:ethereum/ethereum
#sudo add-apt-repository ppa:ethereum/ethereum-dev
#$PKG_REFRESH_PREFIX 
#$PKG_INSTALL_PREFIX cpp-ethereum mix

# Clone and install go-ethereum and cpp-ethereum...
chmod +x "$OLDDIR"/bin_scripts/autobuild_eth.sh
source "$OLDDIR"/bin_scripts/autobuild_eth.sh

# Download and install CUDA...
chmod +x "$OLDDIR"/bin_scripts/autoinstall_cuda.sh
source "$OLDDIR"/bin_scripts/autoinstall_cuda.sh

#unset DISTRO_ID
