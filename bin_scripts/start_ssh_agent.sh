#! /bin/bash

if [[ $(isVarDefined "$SSH_KEY_PATH") ]]; then
	eval "$(ssh-agent -s)"
	ssh-add "$SSH_KEY_PATH"
	echo "Started agent, and attempted to add key."
else
	echo "Unable to start agent or add key. Check that "$SSH_KEY_PATH" is defined"
fi


