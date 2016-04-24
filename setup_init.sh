#!/bin/bash

# Initial Tools

#http://stackoverflow.com/questions/228544/how-to-tell-if-a-string-is-not-defined-in-a-bash-shell-script

function isVarDefined {
	local result=0
	if [ -z "${1+xxx}" ]; then
		result=1
	fi
	return $result
}

function isVarEmpty {
	local result=0
	if [ -z "${1-}" ] && [ "${1+xxx}" = "xxx" ]; then
		result=1
	fi
	return $result
}

export -f isVarDefined
export -f isVarEmpty

isVarDefined "$OLDDIR"
if [ $? -gt 0 ]; then
	OLDDIR="$PWD";
fi

cd $HOME

chmod a+x "$OLDDIR"/determine_and_configure_linux_distro.sh
source "$OLDDIR"/determine_and_configure_linux_distro.sh

# Ubuntu ppas, and Arch config/repos

if [ "$DISTRO_ID" == "ubuntu" ]; then

	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX git curl wget
	git config --global user.name "Quantza"
	git config --global user.email "post2base@outlook.com"

	chmod a+x "$OLDDIR"/bin_scripts/symlink_binaries.sh
	source "$OLDDIR"/bin_scripts/symlink_binaries.sh

	# git pull and install dotfiles
	chmod +x "$OLDDIR"/setup-dotfiles.sh
	source "$OLDDIR"/setup-dotfiles.sh

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

	$PKG_REFRESH_PREFIX
	$PKG_INSTALL_PREFIX git curl wget
	git config --global user.name "Quantza"
	git config --global user.email "post2base@outlook.com"

	chmod a+x "$OLDDIR"/bin_scripts/symlink_binaries.sh
	source "$OLDDIR"/bin_scripts/symlink_binaries.sh

	# git pull and install dotfiles
	chmod +x "$OLDDIR"/setup-dotfiles.sh
	source "$OLDDIR"/setup-dotfiles.sh

	echo "Enable multilib repository, by uncommenting the [multilib] section in '/etc/pacman.conf' (BOTH LINES!!)"
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
	$PKG_INSTALL_PREFIX --needed wget ncurses cmake yajl
	
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

elif [ "$DISTRO_ID" == "cygwin" ]; then
	# Install apt-cyg (OLD: https://github.com/kou1okada/apt-cyg)
	# https://github.com/pi0/cyg
	CYG_REPO_NAME="cyg"
	MY_GIT_REPO_DIR="$HOME"
	CYG_REPO_DIR="$MY_GIT_REPO_DIR"/"$CYG_REPO_NAME"
	if [ ! -d $CYG_REPO_DIR ]; then
	    cd $MY_GIT_REPO_DIR
	    git clone https://github.com/pi0/cyg.git "$CYG_REPO_NAME"
	    ln -s "$("$CYG_REPO_DIR"/"cyg")" /usr/local/bin/
	else
	    cd $CYG_REPO_DIR
	    git pull
	fi
fi

cd "$OLDDIR"

