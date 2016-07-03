#!/bin/bash

OLDDIR="$PWD"
cd "$HOME"/.vpn && sudo openvpn "$HOME"/.vpn/client.conf
cd "$OLDDIR"

echo "Exited."
