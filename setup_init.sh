#!/bin/bash

# Initial Tools

#http://stackoverflow.com/questions/228544/how-to-tell-if-a-string-is-not-defined-in-a-bash-shell-script

function isVarDefined {
	if [ -z "${VAR+xxx}" ]; then
		return 0;
	else
		return 1;
	fi
}

function isVarEmpty {
	if [ -z "${VAR-}" ] && [ "${VAR+xxx}" = "xxx" ]; then
		return 1;
	else
		return 0;
	fi
}

export -f isVarDefined
export -f isVarEmpty

chmod a+x ./determine_and_configure_linux_distro.sh
source ./determine_and_configure_linux_distro.sh

$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX git curl wget
git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

chmod a+x ./bin_scripts/symlink_binaries.sh
source ./bin_scripts/symlink_binaries.sh
