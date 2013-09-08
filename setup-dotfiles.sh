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
git clone git@github.com:Quantza/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.tmux .
ln -sb dotfiles/.emacs .
ln -sb dotfiles/.gitmessage.txt .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sf dotfiles/.emacs.d .
ln -sf dotfiles/.tmux .

