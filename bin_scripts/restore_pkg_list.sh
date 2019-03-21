#!/bin/bash

cat pacman.lst | xargs pacaur -S --needed --noconfirm --noconfirm
