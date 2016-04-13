#!/bin/bash

# Initial Tools

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

PKG_MAN_INSTALL_PREFIX=""
PKG_MAN_REFRESH_PREFIX=""

if (( $("$DISTRO" == "Ubuntu") == 1 )) || (( $(if "$DISTRO" | grep -qi Mint; then echo 1; else echo 0; fi) )); then
	export PKG_MAN_INSTALL_PREFIX="sudo apt-get install -y"
	export PKG_MAN_REFRESH_PREFIX="sudo apt-get update"
fi
elif [ "$DISTRO" == "Arch Linux" ]; then
	export PKG_MAN_INSTALL_PREFIX="sudo pacman -S"
	export PKG_MAN_REFRESH_PREFIX="pacman -Sy"
fi

$PKG_MAN_REFRESH_PREFIX
$PKG_MAN_INSTALL_PREFIX git curl wget
git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

chmod a+x ./bin_scripts/symlink_binaries.sh
source ./bin_scripts/symlink_binaries.sh
