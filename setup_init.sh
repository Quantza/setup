#!/bin/bash

# Initial Tools

chmod a+x ./determine_and_configure_linux_distro.sh
source ./determine_and_configure_linux_distro.sh

$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX git curl wget
git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

chmod a+x ./bin_scripts/symlink_binaries.sh
source ./bin_scripts/symlink_binaries.sh
