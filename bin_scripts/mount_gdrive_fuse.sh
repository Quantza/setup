#!/bin/bash

OLDDIR="$PWD"

GDRIVE_FUSE_DIR="$HOME""/grive-fuse"
if [ ! -d $GDRIVE_FUSE_DIR ]; then
    mkdir $GDRIVE_FUSE_DIR
fi

echo "Mounting gdrive OCaml-FUSE filesystem"
google-drive-ocamlfuse "$GDRIVE_FUSE_DIR" -o nonempty
echo "Done"

cd "$OLDDIR"
