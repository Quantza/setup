#!/bin/bash

OLDDIR="$PWD"

GDRIVE_FUSE_DIR="$HOME""/grive-fuse"
if [ ! -d $GDRIVE_FUSE_DIR ]; then
    mkdir $GDRIVE_FUSE_DIR
fi

echo "Un-mounting gdrive OCaml-FUSE filesystem"
fusermount -u "$GDRIVE_FUSE_DIR"
echo "Done"

cd "$OLDDIR"
