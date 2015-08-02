if [ $# -lt "1" ]
	then
	    echo "Not enough arguments supplied (Provide course list). Exiting..."
		exit 1
fi

workon venv_python2
pip install -U coursera-dl

echo Starting...
coursera-dl -u post2base@hotmail.co.uk -p phoenix13 -d $HOME/courseraDL/ $1
deactivate
echo Done!


