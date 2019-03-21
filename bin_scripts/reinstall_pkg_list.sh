#!/bin/bash

pacaur -S --needed --noconfirm $(pacaur -Qqe | grep -v "$(pacaur -Qqm)")
