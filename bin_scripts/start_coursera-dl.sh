#!/bin/bash

if [ $# -lt "2" ]
	then
	    echo "Not enough arguments supplied (Provide password, then course list). Exiting..."
		exit 1
fi

workon venv_python2
pip install -U coursera-dl

echo Starting...
coursera-dl -u post2base@hotmail.co.uk -p "$1" -d $HOME/courseraDL/ "$2"
deactivate
echo Done!


