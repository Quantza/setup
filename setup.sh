#!/bin/bash
# Simple setup.sh for configuring Ubuntu 14.04 and derivatives,
# for headless setup.

chmod a+x ./setup_init.sh
source ./setup_init.sh

chmod a+x ./setup_version_managers.sh
source 	./setup_version_managers.sh

chmod a+x ./setup_helper.sh
/bin/bash ./setup_helper.sh


