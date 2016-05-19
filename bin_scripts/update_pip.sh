#!/bin/bash
sudo -H pip freeze --local | tee "$HOME"/before_pip3_upgrade.txt | grep -v '^\-e' | cut -d = -f 1 | sudo -H xargs -n1 pip install -U
