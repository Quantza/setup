#!/bin/bash
# Simple setup.sh for configuring Ubuntu 14.04 and derivatives,
# for headless setup.

#Source: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
# Checks that current directory name and working directory are equivalent
# One liner: DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

chmod a+x ./setup_version_managers.sh
source 	./setup_version_managers.sh

chmod a+x ./setup_helper.sh
/bin/bash ./setup_helper.sh

# For handling symlinks
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ln -sb $DIR/autobuild_eth.sh $HOME/bin/autobuild_eth 	



