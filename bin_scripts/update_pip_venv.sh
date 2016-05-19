#!/bin/bash
# Source: http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip

pip freeze --local | tee "$HOME"/before_pip3_upgrade.txt | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
