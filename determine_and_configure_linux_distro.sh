#!/bin/bash

isVarDefined "$OLDDIR"
if [ $? -eq 1 ]; then
	OLDDIR="$PWD";
fi

# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
	# If available, use LSB to identify distribution
	if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
	    export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
	# Otherwise, use release info file
	else
	    export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
	fi
fi
# For everything else (or if above failed), just use generic identifier
[ "$DISTRO" == "" ] && export DISTRO=$UNAME
unset UNAME

PKG_INSTALL_PREFIX=""
PKG_REFRESH_PREFIX=""
DISTRO_ID=""

echo "$DISTRO" | grep -qi "Mint"
IS_LINUX_MINT=$?
# $(if echo "$DISTRO" | grep -qi Mint; then echo 1; else echo 0; fi)

echo "$DISTRO" | grep -qi "Arch"
IS_ARCH=$?

echo "$DISTRO" | grep -qi "Ubuntu"
IS_UBUNTU=$?

if (( $IS_UBUNTU == 0 )) || (( $IS_LINUX_MINT == 0 )); then
	export PKG_INSTALL_PREFIX="sudo apt-get install -y"
	export PKG_REFRESH_PREFIX="sudo apt-get update"
	export PKG_INSTALL_DEB_PREFIX="sudo gebi"
	export DISTRO_ID="ubuntu"
elif (( $IS_ARCH == 0 )); then
	export PKG_INSTALL_PREFIX="sudo pacman -S"
	export PKG_REFRESH_PREFIX="sudo pacman -Sy"
	export PKG_FIND_PREFIX="sudo pacman -Ss"
	export DISTRO_ID="arch"
	export PKG_INSTALL_SRC_PREFIX="sudo pacman -U"
	export YAOURT_INSTALL_PREFIX="sudo yaourt -S"
elif [ -f "$HOME"/"cygwin-trigger" ]; then
	# cygwin
	export PKG_INSTALL_PREFIX="apt-cyg install"
	export PKG_REFRESH_PREFIX="apt-cyg update"
	export PKG_FIND_PREFIX="apt-cyg find"
    export DISTRO_ID="cygwin"
fi

cd "$OLDDIR"
