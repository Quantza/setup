#!/bin/bash

pacaur -Qqe | grep -v "$(pacaur -Qqm)" > pacman.lst

