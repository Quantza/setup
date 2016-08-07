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
	bleachbit gnome-terminal firefox unzip unrar p7zip pidgin skype deluge \
	smplayer qmmp gimp xfburn thunderbird gedit gnome-system-monitor

	$PKG_INSTALL_PREFIX synaptic pepperflashplugin-nonfree chromium-bsu vlc browser-plugin-vlc inkscape qbittorrent aria2 \
	mint-meta-codecs mint-backgrounds-*
	sudo dpkg-reconfigure pepperflashplugin-nonfree

	$PKG_ADD_REPO_PREFIX ppa:ravefinity-project/ppa -y
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX ambiance-flat-colors radiance-flat-colors

	$PKG_ADD_REPO_PREFIX ppa:snwh/pulp -y
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX paper-icon-theme paper-gtk-theme

	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
	wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
	sudo apt-key add - < Release.key

	sudo apt-get install arc-theme

	# Webupd8
	$PKG_INSTALL_PREFIX sublime-text atom

	# Install pdf readers
	$PKG_INSTALL_PREFIX xpdf okular cups cups-pdf

	# Install Haskell
	$PKG_INSTALL_PREFIX haskell-platform

	# Install open-jdk
	# http://askubuntu.com/questions/464755/how-to-install-openjdk-8-on-14-04-lts

	# For Ubuntu 14.10 and later
	# $PKG_INSTALL_PREFIX openjdk-8-jre

	$PKG_ADD_REPO_PREFIX ppa:webupd8team/java -y
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX oracle-java8-installer oracle-java8-set-default

	# Install jabref
	#https://github.com/JabRef/jabref/wiki/Guidelines-for-setting-up-a-local-workspace
	#http://www.fosshub.com/JabRef.html

	# Outdated v2.x, rather than 3.x
	#$PKG_INSTALL_PREFIX jabref

	# Install latest jabref (for now...)
	JABREF_VER="3.3"
	JABREFJAR_NAME="jabref.jar"
	$WGET_CMD http://www.fosshub.com/JabRef.html/JabRef-"$JABREF_VER"".jar" -O "$MY_BIN_DIR""/""$JABREFJAR_NAME"
	java -jar "$MY_BIN_DIR""/""$JABREFJAR_NAME"

	# Install texworks
	$PKG_ADD_REPO_PREFIX ppa:texworks/stable
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX texmacs texworks

	# ADD Texlive!

	# Install TexStudio
	# http://texstudio.sourceforge.net/#download

	ARCH_TMP="amd64"
	TEXSTUDIO_ARCH_TMP="xUbuntu_16.04/""$ARCH_TMP"
	TEXSTUDIO_VER="texstudio_2.11.0-1.1"
	TEXSTUDIOWEBPKG_NAME="$TEXSTUDIO_VER""_""$ARCH_TMP"".deb"
	TEXSTUDIOPKG_NAME="texstudio-latest.deb"
	$WGET_CMD http://download.opensuse.org/repositories/home:/jsundermeyer/"$TEXSTUDIO_ARCH_TMP""/""$TEXSTUDIOWEBPKG_NAME" "$MY_DEV_DIR""/""$TEXSTUDIOPKG_NAME" &> /dev/null
	$PKG_INSTALL_PREFIX qt5-default qt5-image-formats-plugins qt5-doc qt5-doc-html qtbase5-dev qtbase5-dev-tools libqt5core5a
	$PKG_INSTALL_DEB_PREFIX "$MY_DEV_DIR""/""$TEXSTUDIOPKG_NAME"

	MENDELEYPKG_NAME="mendeleydesktop-latest.deb"
	$WGET_CMD https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest "$MY_DEV_DIR""/""$MENDELEYPKG_NAME" &> /dev/null
	$PKG_INSTALL_DEB_PREFIX "$MY_DEV_DIR""/""$MENDELEYPKG_NAME"
	$PKG_REFRESH_PREFIX

  # Install virtualbox -->  change number to match current version - e.g. 5.0

  # Oracle

  #sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add - && sudo apt-get update && sudo apt-get install virtualbox-5.0

  # Ubuntu
  $PKG_INSTALL_PREFIX virtualbox-qt virtualbox-dkms linux-headers-generic

  cd "$MY_DEV_DIR"
  mkdir vbox
  cd vbox

  VBOX_EXT_PACK_NAME="Oracle_VM_VirtualBox_Extension_Pack-5.0.18-106667.vbox-extpack"
  $WGET_CMD http://download.virtualbox.org/virtualbox/5.0.18/"$VBOX_EXT_PACK_NAME"  &> /dev/null
  sudo VBoxManage extpack install "$VBOX_EXT_PACK_NAME"

	PW_SAFE_VERSION="0.99"
	PW_SAFE_VERSION_EXT="0.99.0-BETA.amd64"
	PW_SAFE_LINUX_DIR="Linux-BETA"
	PW_SAFE_DISTRO_VER="xubuntu16"
	PW_SAFE_DEB_FILE="passwordsafe-""$PW_SAFE_DISTRO_VER""-""$PW_SAFE_VERSION_EXT"".deb"
	$WGET_CMD http://downloads.sourceforge.net/project/passwordsafe/"$PW_SAFE_LINUX_DIR"/"$PW_SAFE_VERSION"/"$PW_SAFE_DEB_FILE"
	$PKG_INSTALL_DEB_PREFIX "$PW_SAFE_DEB_FILE"

	cd "$MY_DEV_DIR"
	sudo apt-get install libxerces-c

	# Install boost
	$PKG_INSTALL_PREFIX build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libboost-all-dev

	# For GLFW and SFML
	$PKG_INSTALL_PREFIX libevent-pthreads-2.0.5 doxygen xorg-dev libglu1-mesa-dev mesa-common-dev

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

	# codeblocks
	$PKG_INSTALL_PREFIX codeblocks

	# Qt
	# http://wiki.qt.io/Install_Qt_5_on_Ubuntu

	cd $MY_DEV_DIR"/temp"
	$WGET_CMD http://download.qt.io/official_releases/qt/5.6/5.6.0/qt-opensource-linux-x64-5.6.0.run  &> /dev/null

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
	$WGET_CMD https://pkg.tox.chat/debian/pkg.gpg.key | sudo apt-key add -
	sudo apt-get install apt-transport-https
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX qtox

	# See all available packages
	# cat /var/lib/apt/lists/pkg.tox.chat* | grep "Package: "
	$PKG_ADD_REPO_PREFIX ppa:nilarimogard/webupd8
	$PKG_ADD_REPO_PREFIX ppa:alessandro-strada/ppa
	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX grive google-drive-ocamlfuse

elif [ "$DISTRO_ID" == "arch" ]; then

	# Install other related things...
	$YAOURT_INSTALL_PREFIX gdm3setup ntfs-config

	# calculators
	$YAOURT_INSTALL_PREFIX gnome-calculator libqalculate qalculate-gtk

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
	# libreoffice
	sudo $PKG_INSTALL_PREFIX libreoffice

	# Themes
	sudo $PKG_INSTALL_PREFIX faenza-icon-theme numix-themes

	# Install pdf readers
	$PKG_INSTALL_PREFIX evince kdegraphics-okular

	# Texlive, editors, and calibre
	$PKG_INSTALL_PREFIX texlive-most texmacs auctex texstudio calibre
	$YAOURT_INSTALL_PREFIX texworks jabref gedit-latex

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

	#SFML_INSTALL_SUFFIX="sfml"
	#GLFW_INSTALL_SUFFIX="glfw"

	#cd $MY_GIT_REPO_DIR
	#git clone --recursive https://github.com/glfw/glfw.git glfw
	#git clone --recursive https://github.com/SFML/SFML.git sfml

	#mkdir $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
	#mkdir $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"

	# GLFW

	#cd $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
	#cmake $MY_GIT_REPO_DIR/"$GLFW_INSTALL_SUFFIX"

	# SFML

	#cd $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"
	#cmake $MY_GIT_REPO_DIR/"$SFML_INSTALL_SUFFIX"

	$PKG_INSTALL_PREFIX --needed glfw sfml

	# Qt
	# https://wiki.archlinux.org/index.php/Qt
	$PKG_INSTALL_PREFIX qt5-base qt5-doc qt4 qt4-doc qtchooser

	# Google Drive: grive2 and google-drive-ocamlfuse
	$YAOURT_INSTALL_PREFIX grive
	$YAOURT_INSTALL_PREFIX google-drive-ocamlfuse

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

	$WGET_CMD http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz &> /dev/null
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
$WGET_CMD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein &> /dev/null
chmod a+x $MY_BIN_DIR/lein
lein

# Install Rust
cd $MY_DEV_DIR/temp
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Install elixir
cd $MY_DEV_DIR/temp
$WGET_CMD http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc &> /dev/null
sudo apt-key add erlang_solutions.asc
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX erlang erlang-nox
$PKG_INSTALL_PREFIX elixir
export PATH="$PATH:$(which elixir)"
cd $MY_DEV_DIR/temp && rm -rf *.deb

# Install python
if [ "$DISTRO_ID" == "ubuntu" ]; then
	$PKG_INSTALL_PREFIX python python-dev python3 python3-dev build-essential

	# Python IDLE editor
	$PKG_INSTALL_PREFIX idle-python2* idle-python3* python-tk

	#For lxml
	$PKG_INSTALL_PREFIX libxml2-dev libxslt-dev

elif [ "$DISTRO_ID" == "arch" ]; then
	$PKG_INSTALL_PREFIX python2 python
	$PKG_INSTALL_PREFIX"g" --needed build-devel

	# For lxml
	$PKG_INSTALL_PREFIX libx32-libxml2 lib32-libxslt
fi

PIP_PACKAGES="pyopenssl requests youtube-dl coursera-dl pyopenssl requests jupyter numpy scipy matplotlib pandas sympy nose h5py seaborn"

# Install python
if [ "$DISTRO_ID" == "ubuntu" ]; then
	# Download the latest pip package from source
	#python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
	$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo -H python
	$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo -H python3

	# Use pip to upgrade setuptools
	sudo -H pip2 install --upgrade setuptools
	sudo -H pip3 install --upgrade setuptools

	sudo -H pip2 install --upgrade pip
	sudo -H pip3 install --upgrade pip

	# virtualenv - python2
	sudo -H pip2 install virtualenv virtualenvwrapper

	sudo -H pip2 install pyopenssl requests youtube-dl coursera-dl pyopenssl requests jupyter numpy scipy matplotlib pandas sympy nose h5py seaborn boto jinja2
	sudo -H pip3 install pyopenssl requests youtube-dl pyopenssl requests jupyter numpy scipy matplotlib pandas sympy nose h5py seaborn boto3 jinja2

elif [ "$DISTRO_ID" == "arch" ]; then
	# Download the latest pip package from source
	#python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
	$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo -H python2
	$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo -H python

	# Use pip to upgrade setuptools
	sudo -H pip2 install --upgrade setuptools
	sudo -H pip install --upgrade setuptools

	sudo -H pip2 install --upgrade pip
	sudo -H pip install --upgrade pip

	# virtualenv - python2
	sudo -H pip2 install virtualenv virtualenvwrapper

	sudo -H pip2 install pyopenssl requests youtube-dl coursera-dl pyopenssl requests jupyter numpy scipy matplotlib pandas sympy nose h5py seaborn boto jinja2
	sudo -H pip install pyopenssl requests youtube-dl pyopenssl requests jupyter numpy scipy matplotlib pandas sympy nose h5py seaborn boto3 jinja2

fi

export WORKON_HOME="$HOME"/.virtualenvs
export PROJECT_HOME="$HOME"/Projects
VIRTUALENVWRAPPER_PREFIX="/usr/bin/virtualenvwrapper"

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
#cd $MY_GIT_REPO_DIR
#git clone https://github.com/xybu/onedrive-d.git
#cd onedrive-d

if [ "$DISTRO_ID" == "ubuntu" ]; then

	# Onedrive-d cont...
	#python3 setup.py build
	#sudo python3 setup.py install

	cd "$HOME"

	mkvirtualenv --python=/usr/bin/python2 --no-site-packages py2venv
	pip install -U pip
	sudo -H pip install coursera-dl pyopenssl requests jupyter
	deactivate

	# Clone and install go-ethereum and cpp-ethereum...
	chmod +x "$OLDDIR"/bin_scripts/autobuild_eth.sh
	source "$OLDDIR"/bin_scripts/autobuild_eth.sh

	#chmod +x "$OLDDIR"/bin_scripts/autoinstall_cuda.sh
	#source "$OLDDIR"/bin_scripts/autoinstall_cuda.sh

	# Download and install CUDA...
	$PKG_INSTALL_PREFIX nvidia-cuda-toolkit

elif [ "$DISTRO_ID" == "arch" ]; then

	# Onedrive-d cont...
	#python setup.py build
	#sudo python setup.py install

	cd "$HOME"

	virtualenv --python=/usr/bin/python2 --no-site-packages py2venv
	pip install -U pip
	sudo -H pip install coursera-dl pyopenssl requests jupyter
	deactivate

	# Download and install CUDA...
	$PKG_INSTALL_PREFIX nvidia-cuda-toolkit
fi

# miniconda: http://conda.pydata.org/miniconda.html

#cd $MY_BIN_DIR
#$WGET_CMD https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh &> /dev/null
#$WGET_CMD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh &> /dev/null

#chmod +x Miniconda2-latest-Linux-x86_64.sh
#chmod +x Miniconda3-latest-Linux-x86_64.sh
#./Miniconda2-latest-Linux-x86_64.sh
#./Miniconda3-latest-Linux-x86_64.sh

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
$WGET_CMD https://toolbelt.heroku.com/install-ubuntu.sh | sh

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
