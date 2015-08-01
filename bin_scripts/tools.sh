#!/bin/bash
#
# Script to perform some common system operations
#
COMMAND_END_TEXT="Done. Type in 'q' and press Enter to quit."
EXIT_STATUS=-1

function quitTools {
    if [ "$EXIT_STATUS" = 'q' ]; then
	exit 0
    fi
}

#Function to add an ssh keys
function addKey {
     SSHPATH=$HOME/.ssh/

     if [ ! -d "$SSHPATH" ]; then
	 mkdir $SSHPATH
     fi

     if [ ! -z "$2" ]; then
	 SSHPATH=$S2
     fi	 

     chmod 0400 $SSHPATH$1 &&
     ssh-add $SSHPATH$1 &&
     echo "Added key... Type in 'q' and press Enter to quit."
     read EXIT_STATUS

     quitTools
}

function sshConnect {
    name=$1
    keypath=$2

    if [ -z "$1" ]; then
	 echo "Please enter a hostname or IP address:";
	 read name 
    fi

    if [ -z "$2" ]; then
	echo "(Optional) Please enter a key path:";
	read keypath
    fi	

    if [ -z "$name" ]; then
        echo "You must state a hostname or IP address.";
        exit
    elif [ -z "$keypath" ]; then
	echo "Using previously stored key..."
        ssh $name
    fi
    
    ssh -i $name $keypath
}

function gitClone { 
    username=$1
    repo=$2
    location=$3

    if [ -z "$1" ]; then
         echo "Please enter a github username:";
         read username
    fi

    if [ -z "$2" ]; then
        echo "Please enter the name of a github repository:";
        read repo
    fi
    
    if [ -z "$3" ]; then
        echo "(Optional) Enter a location for the cloned github repository to be stored:";
        read location
    fi

    if [ -z "$username" ]; then
        echo "You must provide a github username.";
        exit
    elif [ -z "$repo" ]; then
        echo "You must provide a github repository name.";
        exit
    fi
 
    if [ -z "$location" ]; then
        echo "Setting cloned repository location to "$HOME"/"$repo"/";
	location=$HOME
    fi

    cd $location

    if [ -d ./$repo/ ]; then
	mv $repo $repo.old
    fi
    
    git clone git@github.com:$username/$repo.git && echo "Cloned "$repo" in "$location" ... Type in 'q' and press Enter to quit.";
    read EXIT_STATUS

    quitTools
}

while :
do
	clear
	if [ "$EXIT_STATUS" = "q" ]; then
		exit 0
	fi
	echo "************************"
	echo "* My tools *"
	echo "************************"
	echo "* [1] Add github key "
	echo "* [2] Add Koding VM key "
	echo "* [3] Add Nitrous VM key"
	echo "* [4] Add AWS VM key"
	echo "* [5] Add an SSH key "
	echo "* ----------------------- "
	echo "* [k] Connect to Koding VM "
	echo "* [n] Connect to Nitrous VM "
	echo "* [a] Connect to AWS VM "
	echo "* [g] Generic SSH "
	echo "* ----------------------- "
	echo "* [d] Clone dotfiles repo "
	echo "* [s] Clone setup repo "
	echo "* [c] Clone a github repo "
	echo "* [z] Set up SSH agent "
	echo "* [x] Fix .ssh group issue"
	echo "* [0] Exit "
	echo "************************"
	echo -n "Enter your menu choice [choice]: "
	read yourch
	echo
	case $yourch in
		1)  
                   addKey "id_rsa_g";;
		2) 
		   addKey "ko-dev";;
		3) 
		   addKey "web-dev";;
		4) 
		   addKey "ubuntu-dev.pem";;
	        5)
		   echo "Please enter a key path:";
                   read keypath && ssh-add $keypath;;
		k) sshConnect "vm-0.clumsyassassin.koding.kd.io";;
		n) sshConnect "action@euw1.actionbox.io -p 14954";;
		a) 
		   echo "Please enter an ip address or hostname:";
		   read host && ssh -i $HOME/.ssh/ubuntu-dev.pem $host;;
	        g) sshConnect;;
		d) gitClone "Quantza" "dotfiles";;
		s) gitClone "Quantza" "setup";;
		c) gitClone;;
	        z) 	
		#eval `ssh-agent -s`;
		SSHAGENT=/usr/bin/ssh-agent
		SSHAGENTARGS="-s"
		if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
			eval `$SSHAGENT $SSHAGENTARGS`
			trap "kill $SSH_AGENT_PID" 0
		fi;
			echo $COMMAND_END_TEXT ; read EXIT_STATUS;;
		x) 	cd $HOME/.ssh && chgrp Users *;
			echo $COMMAND_END_TEXT ; read EXIT_STATUS;;
		0) exit 0;;
		*) echo "Oops! Please select a valid option.";
	echo "Press Enter to continue..." ; read ;;
	esac
done
