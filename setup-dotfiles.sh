#!/bin/bash
# Simple setup-dotfiles.sh for pulling and configuring dotfiles

# git pull and install dotfiles
cd $HOME
if [ -d ./dotfiles/ ]; then
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

git clone git@github.com:Quantza/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.tmux.conf .
ln -sb dotfiles/.gitmessage.txt .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sb dotfiles/.tools.sh .
ln -sf dotfiles/.emacs.d .
ln -sf dotfiles/.tmux .
ln -sf dotfiles/.tools .
ln -sf dotfiles/.vagrant.d .

chmod -R 0700 ~/dotfiles/.tools/