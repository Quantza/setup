#!/bin/bash

isVarDefined "$OLDDIR"
if [ $? -eq 1 ]; then
	OLDDIR="$PWD";
fi

# Source: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
# Checks that current directory name and working directory are equivalent
# One liner: DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

isVarDefined "$MY_BIN_DIR"
if [ $? -eq 0 ]; then
	export MY_BIN_DIR="$HOME/bin";
fi

SYMLINKDIR="$MY_BIN_DIR"

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

symlink_binary_execs () {
	
	# Only one argument at a time
	if [ ! $# -eq "1" ]; then
		exit 1
	fi
	
	FILE_DIR="$DIR/$1"

	if [ -f $SYMLINKDIR/$1 ]; then
		rm -rf $SYMLINKDIR/$1
	fi

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

cd "$OLDDIR"
