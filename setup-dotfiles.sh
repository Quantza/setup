#!/bin/bash
# Simple setup-dotfiles.sh for pulling and configuring dotfiles

OLDDIR="$PWD"

echo "OLDDIR 3 IS HERE: $OLDDIR"

cd "$HOME"

if [ "$DISTRO_ID" == "arch" ]; then
	mkdir "$HOME"/Downloads
	mkdir "$HOME"/Documents
fi

MY_BIN_DIR="$HOME""/bin"
if [ ! -d $MY_BIN_DIR ]; then
    mkdir $MY_BIN_DIR
fi

MY_DEV_DIR="$HOME""/dev"
if [ ! -d $MY_DEV_DIR ]; then
    mkdir $MY_DEV_DIR
fi

if [ ! -d $MY_DEV_DIR/temp ]; then
    mkdir $MY_DEV_DIR/temp
fi

if [ ! -d "$HOME/"go ]; then
    mkdir "$HOME/"go
fi

if [ ! -d "$HOME/"logs ]; then
    mkdir "$HOME/"logs
fi

if [ ! -d "$HOME/".ssh ]; then
    mkdir "$HOME/".ssh
fi

MY_GIT_REPO_DIR="$HOME/GitRepos"
if [ ! -d $MY_GIT_REPO_DIR ]; then
    mkdir $MY_GIT_REPO_DIR
fi

if [ ! -d "$HOME/"Projects ]; then
    mkdir "$HOME/"Projects
fi

if [ ! -d "$HOME/"courseraDL ]; then
    mkdir "$HOME/"courseraDL
fi

if [ ! -d "$HOME/"edxDL ]; then
    mkdir "$HOME/"edxDL
fi

# git pull and install dotfiles
cd "$HOME"
if [ -d ./dotfiles/ ]; then
    if [ -d ./dotfiles~/ ]; then
        rm -rf ./dotfiles~/
    fi
    mv dotfiles dotfiles~
fi

if [ ! -d .config/ ]; then
    mkdir .config
fi

CONFIG_DIR="$HOME""/.config"
cd "$CONFIG_DIR"
if [ -d ./matplotlib/ ]; then
    if [ -d ./matplotlib~/ ]; then
        rm -rf ./matplotlib~/
    fi
    mv matplotlib matplotlib~
fi

cd "$HOME"

if [ -d ./.emacs.d/ ]; then
    if [ -d ./.emacs.d~/ ]; then
        rm -rf ./.emacs.d~/
    fi
    mv .emacs.d .emacs.d~
fi

if [ -d .tmux/ ]; then
    if [ -d ./tmux~/ ]; then
        rm -rf ./tmux~/
    fi
    mv .tmux .tmux~
fi

if [ -d .vagrant.d/ ]; then
    if [ -d ./.vagrant.d~/ ]; then
        rm -rf ./.vagrant.d~/
    fi
    mv .vagrant.d .vagrant.d~
fi

if [ -d .tools/ ]; then
    if [ -d ./tools~/ ]; then
        rm -rf ./tools~/
    fi
    mv .tools .tools~
fi

if [ -f "$HOME/"cygwin-trigger ]; then
	rm -rf "$HOME/"cygwin-trigger
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
ln -sb "$HOME/"dotfiles/tools.sh "$MY_BIN_DIR"/tools_menu
ln -sb "$HOME/"dotfiles/determine_and_configure_linux_distro.sh "$MY_BIN_DIR"/det_conf_linux_dist
ln -sf dotfiles/.emacs.d .
ln -sf dotfiles/matplotlib ./.config/matplotlib
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

chmod -vR 600 "$HOME/".ssh/config
chmod -R 0700 "$HOME/"dotfiles/.tools/

cd "$OLDDIR"
