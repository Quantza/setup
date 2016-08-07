#!/bin/bash

OLDDIR="$PWD"
cd "$HOME"/.vpn && sudo openvpn --config "$HOME"/.vpn/client.conf --ca "$1" --crl-verify "$2"
cd "$OLDDIR"

echo "Exited."
