#!/bin/bash
# Simple setup-dotfiles.sh for pulling and configuring dotfiles

OLDDIR="$PWD"

cd $HOME

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

MY_DEV_DIR="$HOME/dev"
if [ ! -d $MY_DEV_DIR ]; then
    mkdir $MY_DEV_DIR
    mkdir $MY_DEV_DIR/Projects
fi

if [ ! -d $MY_DEV_DIR/temp ]; then
    mkdir $MY_DEV_DIR/temp
fi

if [ ! -d $HOME/go ]; then
    mkdir $HOME/go
fi

if [ ! -d $HOME/logs ]; then
    mkdir $HOME/logs
fi

if [ ! -d $HOME/.ssh ]; then
    mkdir $HOME/.ssh
fi

if [ ! -d $HOME/GitRepos ]; then
    mkdir $HOME/GitRepos
fi

if [ ! -d $HOME/Projects ]; then
    mkdir $HOME/Projects
fi

if [ ! -d $HOME/courseraDL ]; then
    mkdir $HOME/courseraDL
fi

if [ ! -d $HOME/edxDL ]; then
    mkdir $HOME/edxDL
fi

# git pull and install dotfiles
cd $HOME
if [ -d ./dotfiles/ ]; then
	if [ -d ./dotfiles.old/ ]; then
	   rm -rf ./dotfiles.old/
	fi
    mv dotfiles dotfiles.old
fi

if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi

if [ -d .tmux/ ]; then
    mv .tmux .tmux~
fi

if [ -d .vagrant.d/ ]; then
    mv .vagrant.d .vagrant.d~
fi

if [ -d .tools/ ]; then
    mv .tools .tools.old
fi

if [ -f $HOME/start-agent-trigger ]; then
	rm -rf $HOME/start-agent-trigger
fi

git config --global user.name "Quantza"
git config --global user.email "post2base@outlook.com"

git clone git@github.com:Quantza/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.tmux.conf .
ln -sb dotfiles/.gitmessage.txt .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.theanorc .
ln -sb dotfiles/.bashrc_custom .
ln -sb dotfiles/site.cfg .
ln -sb dotfiles/tools.sh "$MY_BIN_DIR"/tools_menu
ln -sb dotfiles/determine_and_configure_linux_distro.sh "$MY_BIN_DIR"/det_conf_linux_dist
ln -sf dotfiles/.emacs.d .
ln -sf dotfiles/.tmux .
ln -sf dotfiles/.tools .
ln -sf dotfiles/.vagrant.d .

if [ -d .ssh/ ]
then
    cp -R .ssh .ssh.old
    cp dotfiles/.ssh/config ~/.ssh
else
    cp -R dotfiles/.ssh .
    #chmod -vR 644 ~/.ssh/*.pub
fi

chmod -vR 600 $HOME/.ssh/config
chmod -R 0700 $HOME/dotfiles/.tools/

cd "$OLDDIR"
