#!/bin/bash

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
PKG_INSTALL_SRC_PREFIX=""
DISTRO_ID=""

if (( $("$DISTRO" == "Ubuntu") == 1 )) || (( $(if "$DISTRO" | grep -qi Mint; then echo 1; else echo 0; fi) )); then
	export PKG_INSTALL_PREFIX="sudo apt-get install -y"
	export PKG_REFRESH_PREFIX="sudo apt-get update"
	export DISTRO_ID="ubuntu"
fi
elif [ "$DISTRO" == "Arch Linux" ]; then
	export PKG_INSTALL_PREFIX="sudo pacman -S"
	export PKG_REFRESH_PREFIX="sudo pacman -Sy"
	export DISTRO_ID="arch"
	export PKG_INSTALL_SRC_PREFIX="sudo pacman -U"
fi
