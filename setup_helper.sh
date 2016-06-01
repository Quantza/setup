#!/bin/bash

isVarDefined "$OLDDIR"
if [ $? -gt 0 ]; then
	OLDDIR="$PWD";
fi

cd "$HOME"

# Install ruby and set up rvm
rvm reload
rvm install 2.2
rvm install 2.3

rvm list
rvm use 2.3 --default
ruby -v
which ruby

gem install bundler

WGET_CMD="wget -qO-"

# rootkit scanners
$PKG_INSTALL_PREFIX chkrootkit rkhunter

# Install docky, tmux, tilda
$PKG_INSTALL_PREFIX docky tmux tilda

# Install yubikey software
$PKG_INSTALL_PREFIX libpam-yubico yubikey-personalization-gui yubikey-neo-manager

# Install wine
$PKG_INSTALL_PREFIX wine winetricks

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

	$PKG_INSTALL_PREFIX  gcc gdb automake cmake cmake-qt-gui libmagick++-dev libgtk2.0-dev \
	libxft-dev libgnutls-dev libdbus-1-dev libgif-dev texinfo libxpm-dev libacl1 libacl1-dev build-essential aptitude
	#$PKG_INSTALL_PREFIX build-dep build-essential

	EMACS_DEV_DIR="$MY_GIT_REPO_DIR"/emacs
	if [ ! -d $EMACS_DEV_DIR ]; then
	    cd $MY_GIT_REPO_DIR
	    git clone git://git.savannah.gnu.org/emacs.git
		cd emacs
	else
	    cd $EMACS_DEV_DIR
	    git pull
	fi

	GIT_COMMON_DIR=$MY_GIT_REPO_DIR/emacs
	make
	sudo ./src/emacs &
	ln -sb $MY_GIT_REPO_DIR/emacs $MY_BIN_DIR/emacs
	sudo make install
	unset GIT_COMMON_DIR

	# libgtop for system monitoring, and other apps
	$PKG_INSTALL_PREFIX gir1.2-gtop-2.0 pulseaudio pavucontrol \
	gnome-terminal firefox vlc unzip unrar p7zip pidgin skype deluge \
	smplayer qmmp gimp xfburn thunderbird gedit gnome-system-monitor

	# Webupd8
	$PKG_INSTALL_PREFIX sublime-text atom

	# Install pdf readers
	$PKG_INSTALL_PREFIX xpdf okular cups cups-pdf

	# Install Haskell
	$PKG_INSTALL_PREFIX haskell-platform

	# Install jabref
	#https://github.com/JabRef/jabref/wiki/Guidelines-for-setting-up-a-local-workspace
	#http://www.fosshub.com/JabRef.html

	# Outdated v2.x, rather than 3.x
	#$PKG_INSTALL_PREFIX jabref

	# Install latest jabref (for now...)
	JABREF_VER="3.3"
	JABREFJAR_NAME = "jabref.jar"
	wget -q http://www.fosshub.com/JabRef.html/JabRef-"$JABREF_VER"".jar" -O "$MY_BIN_DIR""/""$JABREFJAR_NAME"
	java -jar "$MY_BIN_DIR""/""$JABREFJAR_NAME"

	# Install texworks
	$PKG_ADD_REPO_PREFIX ppa:texworks/stable
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX texlive texmacs texworks

	# Install TexStudio
	# http://texstudio.sourceforge.net/#download

	ARCH_TMP="amd64"
	TEXSTUDIO_ARCH_TMP="xUbuntu_14.04/""$ARCH_TMP"
	TEXSTUDIO_VER="texstudio_2.11.0-1.1"
	TEXSTUDIOWEBPKG_NAME="$TEXSTUDIO_VER""_""$ARCH_TMP"".deb"
	TEXSTUDIOPKG_NAME="texstudio-latest.deb"
	wget -q http://download.opensuse.org/repositories/home:/jsundermeyer/"$TEXSTUDIO_ARCH_TMP""/""$TEXSTUDIOWEBPKG_NAME" -O "$MY_DEV_DIR""/""$TEXSTUDIOPKG_NAME"
	$PKG_INSTALL_PREFIX qt5-default qt5-image-formats-plugins qt5-doc qt5-doc-html qtbase5-dev qtbase5-dev-tools libqt5core5a
	$PKG_INSTALL_DEB_PREFIX "$MY_DEV_DIR""/""$TEXSTUDIOPKG_NAME"

	MENDELEYPKG_NAME="mendeleydesktop-latest.deb"
	wget -q https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest -O "$MY_DEV_DIR""/""$MENDELEYPKG_NAME"
	$PKG_INSTALL_DEB_PREFIX "$MY_DEV_DIR""/""$MENDELEYPKG_NAME"
	$PKG_REFRESH_PREFIX

  # Install virtualbox -->  change number to match current version - e.g. 5.0

  #Oracle
  '''
  sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add - && sudo apt-get update && sudo apt-get install virtualbox-5.0
  '''

  #Ubuntu
  $PKG_INSTALL_PREFIX virtualbox-qt virtualbox-dkms linux-headers-generic

  cd "$MY_DEV_DIR"
  mkdir vbox
  cd vbox

  VBOX_EXT_PACK_NAME="Oracle_VM_VirtualBox_Extension_Pack-5.0.18-106667.vbox-extpack"
  $WGET_CMD http://download.virtualbox.org/virtualbox/5.0.18/"$VBOX_EXT_PACK_NAME"

  sudo VBoxManage extpack install "$VBOX_EXT_PACK_NAME"


	# Install boost
	$PKG_INSTALL_PREFIX build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libboost-all-dev

	# For GLFW and SFML
	$PKG_INSTALL_PREFIX libevent-pthreads-2.0.5 doxygen xorg-dev libglu1-mesa-dev mesa-common-dev

	'''
	SFML_INSTALL_SUFFIX="sfml"
	GLFW_INSTALL_SUFFIX="glfw"

	cd $MY_GIT_REPO_DIR
	git clone --recursive https://github.com/glfw/glfw.git glfw
	git clone --recursive https://github.com/SFML/SFML.git sfml

	mkdir $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
	mkdir $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"

	# GLFW

	cd $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
	cmake $MY_GIT_REPO_DIR/"$GLFW_INSTALL_SUFFIX"

	# SFML

	cd $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"
	cmake $MY_GIT_REPO_DIR/"$SFML_INSTALL_SUFFIX"
	'''

	$PKG_INSTALL_PREFIX glfw sfml glm glew

	# codeblocks
	$PKG_INSTALL_PREFIX codeblocks

	# Qt
	# http://wiki.qt.io/Install_Qt_5_on_Ubuntu

	cd $MY_DEV_DIR"/temp"
	$WGET_CMD -qO- http://download.qt.io/official_releases/qt/5.6/5.6.0/qt-opensource-linux-x64-5.6.0.run

	chmod +x qt-opensource-linux*
	sudo ./qt-opensource-linux-x64-5.6.0.run
	rm -rf qt-opensource-linux*

	QT_CREATOR_SHORTCUT_NAME="Qt-Creator.desktop"
	export QT_CREATOR_SHORTCUT_LOCATION="$HOME""/Desktop/""$QT_CREATOR_SHORTCUT_NAME"

	touch $QT_CREATOR_SHORTCUT_LOCATION

	bash -c 'echo "[Desktop Entry]
Version=1.0
Encoding=UTF-8
Type=Application
Name=QtCreator
Comment=QtCreator
NoDsiplay=true
Exec=(Install folder of QT)/Tools/QtCreator/bin/qtcreator %f
Icon=(Install folder of QT)/5.4/Src/qtdoc/doc/images/landing/icon_QtCreator_78x78px.png
Name[en_US]=Qt-Creator">>"$QT_CREATOR_SHORTCUT_LOCATION"'

	'''

	QT_CREATOR_DIR="$HOME/.local/share/applications"

	cp $QT_CREATOR_SHORTCUT_LOCATION "$QT_CREATOR_DIR"/"$QT_CREATOR_SHORTCUT_NAME"

	export QT_DEFAULTS_LIST="$QT_CREATOR_DIR"/"defaults.list"

	touch "$QT_DEFAULTS_LIST"

	'''

	#bash -c ' echo "text/qtcreator=Qt-Creator.desktop;">>"$DEFAULTS_LIST"'
	#unset DEFAULTS_LIST

	#unset QT_CREATOR_SHORTCUT_LOCATION

	#echo "From here manually continue and add 'application/vnd.nokia.qt.qmakeprofile=qtcreator.desktop', under [Associations], if it is not present"

	#sudo nano $QT_DEFAULTS_LIST

	#sudo update-mime-database /usr/share/mime

	# qTox

	echo "deb https://pkg.tox.chat/debian nightly $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/tox.list
	wget -qO - https://pkg.tox.chat/debian/pkg.gpg.key | sudo apt-key add -
	sudo apt-get install apt-transport-https
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX qtox

	# See all available packages
	# cat /var/lib/apt/lists/pkg.tox.chat* | grep "Package: "

elif [ "$DISTRO_ID" == "arch" ]; then

	# Install other related things...
	$YAOURT_INSTALL_PREFIX gdm3setup ntfs-config

	# emacs
	$PKG_INSTALL_PREFIX --needed build-devel emacs
	# emacs-nox (without X11 support)

	# For gparted
	$PKG_INSTALL_PREFIX --needed gparted part mtools btrfs-progs exfat-utils dosfstools ntfs-3g

	# For system monitoring
	$PKG_INSTALL_PREFIX libgtop networkmanager util-linux conky
	sudo usermod -aG log "$USER"

	# Conky with Lua and NVIDIA support
	# https://wiki.archlinux.org/index.php/Conky
	# $YAOURT_INSTALL_PREFIX conky-lua-nv

	# For emulators
	$YAOURT_INSTALL_PREFIX lib32-ncurses
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
	$PKG_INSTALL_PREFIX evince kdegraphics-okular

	# Texlive, editors, and calibre
	$PKG_INSTALL_PREFIX texlive-most texmacs auctex texworks texstudio calibre
	$YAOURT_INSTALL_PREFIX jabref gedit-latex

	# emacs org-mode
	$YAOURT_INSTALL_PREFIX emacs-org-mode

	# codeblocks
	$PKG_INSTALL_PREFIX codeblocks

	# intellij
	$PKG_INSTALL_PREFIX intellij-idea-libs intellij-idea-community-edition

	# Visual studio code
	$YAOURT_INSTALL_PREFIX visual-studio-code acroread

	# OCR tools
	$PKG_INSTALL_PREFIX tesseract tesseract-data-eng
	$YAOURT_INSTALL_PREFIX gimagereader ocropy

	# qTox
	$PKG_INSTALL_PREFIX qtox

	'''
	$PKG_INSTALL_PREFIX texlive-core texlive-bibtexextra texlive-fontsextra texlive-formatsextra \
	texlive-games texlive-genericextra texlive-htmlxml texlive-humanities texlive-latexextra \
	texlive-music texlive-pictures texlive-plainextra texlive-pstricks texlive-publishers texlive-science
	'''

  #Install virtualbox
  $PKG_INSTALL_PREFIX qt4 virtualbox virtualbox-host-dkms linux-headers net-tools

  sudo dkms autoinstall

  sudo dkms install vboxhost/$(pacman -Q virtualbox|awk '{print $2}'|sed 's/\-.\+//') -k $(uname -rm|sed 's/\ /\//')

  sudo gpasswd -a "$USER" vboxusers

  $PKG_INSTALL_PREFIX virtualbox-guest-iso

  $YAOURT_INSTALL_PREFIX virtualbox-ext-oracle

	# Install boost
	$PKG_INSTALL_PREFIX boost

	# For GLFW and SFML

	$PKG_INSTALL_PREFIX --needed libevent doxygen xorg-server-dev glu mesa glew glm openal libsndfile xrandr libjpg-turbo freetype2

	'''
	SFML_INSTALL_SUFFIX="sfml"
	GLFW_INSTALL_SUFFIX="glfw"

	cd $MY_GIT_REPO_DIR
	git clone --recursive https://github.com/glfw/glfw.git glfw
	git clone --recursive https://github.com/SFML/SFML.git sfml

	mkdir $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
	mkdir $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"

	# GLFW

	cd $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
	cmake $MY_GIT_REPO_DIR/"$GLFW_INSTALL_SUFFIX"

	# SFML

	cd $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"
	cmake $MY_GIT_REPO_DIR/"$SFML_INSTALL_SUFFIX"
	'''

	$PKG_INSTALL_PREFIX --needed glfw sfml

	# Qt
	# https://wiki.archlinux.org/index.php/Qt
	$PKG_INSTALL_PREFIX qt5-base qt5-doc qt4 qt4-doc qtchooser

else
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

	$WGET_CMD http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
	tar -xzvf install-tl-unx.tar.gz
	cd install-tl-*
	chmod +x install-tl
	sudo ./install-tl -gui text

	cd "$HOME"
	#PATH=/usr/local/texlive/2015:$PATH
fi

# OpenSSH, OpenPGP and rsync
$PKG_INSTALL_PREFIX openssh pssh rsync seahorse nemo-seahorse gnupg

# Syncthing
$PKG_INSTALL_PREFIX syncthing syncthing-gtk

# Development Tools
$PKG_INSTALL_PREFIX libopenblas-dev gfortran

# Set up Clojure with leiningen
cd $MY_BIN_DIR
$WGET_CMD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x $MY_BIN_DIR/lein
lein

# Install Rust
cd $MY_DEV_DIR/temp
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Install elixir
cd $MY_DEV_DIR/temp
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX esl-erlang
$PKG_INSTALL_PREFIX elixir
export PATH="$PATH:$(which elixir)"
cd $MY_DEV_DIR/temp && rm -rf *.deb

# Install python
if [ "$DISTRO_ID" == "ubuntu" ]; then
	$PKG_INSTALL_PREFIX python python-dev python-pip python3 python3-dev python3-pip build-essential

	# python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
	sudo -H pip install --upgrade pip
	sudo -H pip3 install --upgrade pip

	# Python IDLE editor
	$PKG_INSTALL_PREFIX idle-python2* idle-python3* python-tk

	#For lxml
	$PKG_INSTALL_PREFIX libxml2-dev
	$PKG_INSTALL_PREFIX libxslt-dev

	# Download the latest pip package from source
	$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo python3

	# Use pip to upgrade setuptools
	sudo -H pip install --upgrade setuptools
	sudo -H pip3 install --upgrade setuptools

	# virtualenv
	sudo -H pip install virtualenv
	sudo -H pip install virtualenvwrapper

	sudo -H pip3 install virtualenv
	sudo -H pip3 install virtualenvwrapper

	sudo -H pip install jupyter
	sudo -H pip3 install jupyter

	#http://virtualenvwrapper.readthedocs.org/en/latest/install.html#lazy-loading
	export WORKON_HOME="$HOME"/.virtualenvs
	export PROJECT_HOME="$HOME"/Projects
	VIRTUALENVWRAPPER_PREFIX="/usr/local/bin/virtualenvwrapper"

elif [ "$DISTRO_ID" == "arch" ]; then
	$PKG_INSTALL_PREFIX python2 python-pip2 python python-pip3 python2-pandas python2-seaborn python-pandas python-seaborn
	$PKG_INSTALL_PREFIX"g" --needed build-devel

	# python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
	sudo pip2 install --upgrade pip
	sudo pip install --upgrade pip

	# For lxml
	$PKG_INSTALL_PREFIX libx32-libxml2 lib32-libxslt

	# Download the latest pip package from source
	$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo python

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

isVarDefined "$VIRTUALENVWRAPPER_PREFIX"
if [ $? -eq 0 ]; then
	if [ -f "$VIRTUALENVWRAPPER_PREFIX"_lazy.sh  ]; then
		export VIRTUALENVWRAPPER_SCRIPT="$VIRTUALENVWRAPPER_PREFIX""_lazy.sh"
		source "$VIRTUALENVWRAPPER_SCRIPT"
	elif [ -f "$VIRTUALENVWRAPPER_PREFIX".sh ]; then
		export VIRTUALENVWRAPPER_SCRIPT="$VIRTUALENVWRAPPER_PREFIX"".sh"
		source "$VIRTUALENVWRAPPER_SCRIPT"
	fi
fi

# Onedrive-d
cd $MY_GIT_REPO_DIR
git clone https://github.com/xybu/onedrive-d.git
cd onedrive-d

if [ "$DISTRO_ID" == "ubuntu" ]; then

	# Onedrive-d cont...
	python3 setup.py build
	sudo python3 setup.py install

	cd "$HOME"

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

	# Clone and install go-ethereum and cpp-ethereum...
	chmod +x "$OLDDIR"/bin_scripts/autobuild_eth.sh
	source "$OLDDIR"/bin_scripts/autobuild_eth.sh

	# Download and install CUDA...
	chmod +x "$OLDDIR"/bin_scripts/autoinstall_cuda.sh
	source "$OLDDIR"/bin_scripts/autoinstall_cuda.sh

elif [ "$DISTRO_ID" == "arch" ]; then

	# Onedrive-d cont...
	python setup.py build
	sudo python setup.py install

	cd "$HOME"

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
#$WGET_CMD https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
#$WGET_CMD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

#chmod +x Miniconda2-latest-Linux-x86_64.sh
#chmod +x Miniconda3-latest-Linux-x86_64.sh
#./Miniconda2-latest-Linux-x86_64.sh
#./Miniconda3-latest-Linux-x86_64.sh

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# cpp-ethereum dependencies
# https://github.com/ethereum/webthree-umbrella

#sudo $PKG_ADD_REPO_PREFIX ppa:ethereum/ethereum-qt
#sudo $PKG_ADD_REPO_PREFIX ppa:ethereum/ethereum
#sudo $PKG_ADD_REPO_PREFIX ppa:ethereum/ethereum-dev
#$PKG_REFRESH_PREFIX
#$PKG_INSTALL_PREFIX cpp-ethereum mix

# Clone and install go-ethereum and cpp-ethereum...
#chmod +x "$OLDDIR"/bin_scripts/autobuild_eth.sh
#source "$OLDDIR"/bin_scripts/autobuild_eth.sh

# Download and install CUDA...
#chmod +x "$OLDDIR"/bin_scripts/autoinstall_cuda.sh
#source "$OLDDIR"/bin_scripts/autoinstall_cuda.sh

#unset DISTRO_ID
