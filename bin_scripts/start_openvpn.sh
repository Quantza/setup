#!/bin/bash

OLDDIR="$PWD"
cd "$HOME"/.vpn && sudo openvpn /etc/openvpn/client.conf
cd "$OLDDIR"

echo "Exited."
