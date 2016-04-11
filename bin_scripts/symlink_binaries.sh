#!/bin/bash

SYMLINKDIR="$HOME/bin"

if [ ! -d $SYMLINKDIR ]; then
    mkdir $SYMLINKDIR
fi

# For handling symlinks
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#ln -sb $DIR/autobuild_eth.sh $HOME/bin/autobuild_eth
#ln -sb $DIR/autoupdate_eth.sh $HOME/bin/autoupdate_eth

symlink_binary_execs () {
	
	# Only one argument at a time
	if [ ! $# -eq "1" ]; then
		exit 1
	fi
	
	FILE_DIR="$DIR/$1"

	if file --mime-type "$1" | grep -q "sh"; then
		echo "sh: $1"
		ln -sb $FILE_DIR $SYMLINKDIR/$1
	elif file --mime-type "$1" | grep -q "py"; then
		echo "py: $1"
		ln -sb $FILE_DIR $SYMLINKDIR/$1
	fi

}

# perform command='cmd' on all files in directory
ls -f $DIR | while read -r file; do symlink_binary_execs $file; done

echo "---Finished symlinking!---"
