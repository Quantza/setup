#!/bin/bash

OLDDIR="$PWD"
cd "$HOME"/.vpn && sudo openvpn --config "$HOME"/.vpn/client.conf --ca "$HOME"/.vpn/ca.crt --crl-verify "$HOME"/.vpn/crl.pem
cd "$OLDDIR"

echo "Exited."
