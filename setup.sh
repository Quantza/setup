#!/bin/bash
# Simple setup.sh for configuring Ubuntu 14.04 and derivatives,
# for headless setup.

#Source: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
# Checks that current directory name and working directory are equivalent
# One liner: DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

chmod a+x ./bin_scripts/symlink_binaries.sh
source ./bin_scripts/symlink_binaries.sh

chmod a+x ./setup_version_managers.sh
source 	./setup_version_managers.sh

chmod a+x ./setup_helper.sh
/bin/bash ./setup_helper.sh


