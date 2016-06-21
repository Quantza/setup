#!/bin/bash

OLDDIR="$PWD"

GDRIVE_GRIVE_DIR="$HOME""/grive"
if [ ! -d $GDRIVE_GRIVE_DIR ]; then
    mkdir $GDRIVE_GRIVE_DIR
fi

echo "Updating gdrive"
cd "$GDRIVE_GRIVE_DIR"
grive -a
echo "Done"

cd "$OLDDIR"
