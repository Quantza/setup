
EMACS_DEV_DIR="$MY_GIT_REPO_DIR"/emacs
if [ ! -d $EMACS_DEV_DIR ]; then
    cd $MY_GIT_REPO_DIR
    git clone git://git.savannah.gnu.org/emacs.git
	cd emacs
else
    cd $EMACS_DEV_DIR
    git pull
fi

GIT_COMMON_DIR=$MY_GIT_REPO_DIR/emacs
make
sudo ./src/emacs &
ln -sb $MY_GIT_REPO_DIR/emacs $MY_BIN_DIR/emacs
sudo make install
unset GIT_COMMON_DIR

# libgtop for system monitoring, and other apps
$PKG_INSTALL_PREFIX gir1.2-gtop-2.0 pulseaudio pavucontrol \
gnome-terminal firefox vlc unzip unrar p7zip pidgin skype deluge \
smplayer qmmp gimp xfburn thunderbird gedit gnome-system-monitor

# Webupd8
$PKG_INSTALL_PREFIX sublime-text atom

# Install pdf readers
$PKG_INSTALL_PREFIX xpdf okular cups cups-pdf

# Install Haskell
$PKG_INSTALL_PREFIX haskell-platform

# Install open-jdk
# http://askubuntu.com/questions/464755/how-to-install-openjdk-8-on-14-04-lts

# For Ubuntu 14.10 and later
# $PKG_INSTALL_PREFIX openjdk-8-jre

$PKG_ADD_REPO_PREFIX ppa:webupd8team/java -y
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX oracle-java8-installer oracle-java8-set-default

# Install jabref
#https://github.com/JabRef/jabref/wiki/Guidelines-for-setting-up-a-local-workspace
#http://www.fosshub.com/JabRef.html

# Outdated v2.x, rather than 3.x
#$PKG_INSTALL_PREFIX jabref

# Install latest jabref (for now...)
JABREF_VER="3.3"
JABREFJAR_NAME="jabref.jar"
wget -q http://www.fosshub.com/JabRef.html/JabRef-"$JABREF_VER"".jar" -O "$MY_BIN_DIR""/""$JABREFJAR_NAME"
java -jar "$MY_BIN_DIR""/""$JABREFJAR_NAME"

# Install texworks
$PKG_ADD_REPO_PREFIX ppa:texworks/stable
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX texmacs texworks

# ADD Texlive!

# Install TexStudio
# http://texstudio.sourceforge.net/#download

ARCH_TMP="amd64"
TEXSTUDIO_ARCH_TMP="xUbuntu_16.04/""$ARCH_TMP"
TEXSTUDIO_VER="texstudio_2.11.0-1.1"
TEXSTUDIOWEBPKG_NAME="$TEXSTUDIO_VER""_""$ARCH_TMP"".deb"
TEXSTUDIOPKG_NAME="texstudio-latest.deb"
wget -q http://download.opensuse.org/repositories/home:/jsundermeyer/"$TEXSTUDIO_ARCH_TMP""/""$TEXSTUDIOWEBPKG_NAME" -O "$MY_DEV_DIR""/""$TEXSTUDIOPKG_NAME"
$PKG_INSTALL_PREFIX qt5-default qt5-image-formats-plugins qt5-doc qt5-doc-html qtbase5-dev qtbase5-dev-tools libqt5core5a
$PKG_INSTALL_DEB_PREFIX "$MY_DEV_DIR""/""$TEXSTUDIOPKG_NAME"

MENDELEYPKG_NAME="mendeleydesktop-latest.deb"
wget -q https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest -O "$MY_DEV_DIR""/""$MENDELEYPKG_NAME"
$PKG_INSTALL_DEB_PREFIX "$MY_DEV_DIR""/""$MENDELEYPKG_NAME"
$PKG_REFRESH_PREFIX

# For GLFW and SFML
$PKG_INSTALL_PREFIX libevent-pthreads-2.0.5 doxygen xorg-dev libglu1-mesa-dev mesa-common-dev

'''
SFML_INSTALL_SUFFIX="sfml"
GLFW_INSTALL_SUFFIX="glfw"

cd $MY_GIT_REPO_DIR
git clone --recursive https://github.com/glfw/glfw.git glfw
git clone --recursive https://github.com/SFML/SFML.git sfml

mkdir $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
mkdir $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"

# GLFW

cd $MY_DEV_DIR/"$GLFW_INSTALL_SUFFIX"
cmake $MY_GIT_REPO_DIR/"$GLFW_INSTALL_SUFFIX"

# SFML

cd $MY_DEV_DIR/"$SFML_INSTALL_SUFFIX"
cmake $MY_GIT_REPO_DIR/"$SFML_INSTALL_SUFFIX"
'''

$PKG_INSTALL_PREFIX glfw sfml glm glew

# codeblocks
$PKG_INSTALL_PREFIX codeblocks

# Qt
# http://wiki.qt.io/Install_Qt_5_on_Ubuntu

cd $MY_DEV_DIR"/temp"
$WGET_CMD -qO- http://download.qt.io/official_releases/qt/5.6/5.6.0/qt-opensource-linux-x64-5.6.0.run

chmod +x qt-opensource-linux*
sudo ./qt-opensource-linux-x64-5.6.0.run
rm -rf qt-opensource-linux*

QT_CREATOR_SHORTCUT_NAME="Qt-Creator.desktop"
export QT_CREATOR_SHORTCUT_LOCATION="$HOME""/Desktop/""$QT_CREATOR_SHORTCUT_NAME"

touch $QT_CREATOR_SHORTCUT_LOCATION

bash -c 'echo "[Desktop Entry]
Version=1.0
Encoding=UTF-8
Type=Application
Name=QtCreator
Comment=QtCreator
NoDsiplay=true
Exec=(Install folder of QT)/Tools/QtCreator/bin/qtcreator %f
Icon=(Install folder of QT)/5.4/Src/qtdoc/doc/images/landing/icon_QtCreator_78x78px.png
Name[en_US]=Qt-Creator">>"$QT_CREATOR_SHORTCUT_LOCATION"'

'''

QT_CREATOR_DIR="$HOME/.local/share/applications"

cp $QT_CREATOR_SHORTCUT_LOCATION "$QT_CREATOR_DIR"/"$QT_CREATOR_SHORTCUT_NAME"

export QT_DEFAULTS_LIST="$QT_CREATOR_DIR"/"defaults.list"

touch "$QT_DEFAULTS_LIST"

'''

#bash -c ' echo "text/qtcreator=Qt-Creator.desktop;">>"$DEFAULTS_LIST"'
#unset DEFAULTS_LIST

#unset QT_CREATOR_SHORTCUT_LOCATION

#echo "From here manually continue and add 'application/vnd.nokia.qt.qmakeprofile=qtcreator.desktop', under [Associations], if it is not present"

#sudo nano $QT_DEFAULTS_LIST

#sudo update-mime-database /usr/share/mime

# qTox

echo "deb https://pkg.tox.chat/debian nightly $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/tox.list
wget -qO - https://pkg.tox.chat/debian/pkg.gpg.key | sudo apt-key add -
sudo apt-get install apt-transport-https
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX qtox

# See all available packages
# cat /var/lib/apt/lists/pkg.tox.chat* | grep "Package: "

# Set up Clojure with leiningen
cd $MY_BIN_DIR
$WGET_CMD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x $MY_BIN_DIR/lein
lein

# Install Rust
cd $MY_DEV_DIR/temp
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Install elixir
cd $MY_DEV_DIR/temp
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX esl-erlang
$PKG_INSTALL_PREFIX elixir
export PATH="$PATH:$(which elixir)"
cd $MY_DEV_DIR/temp && rm -rf *.deb

$PKG_INSTALL_PREFIX python python-dev python3 python3-dev build-essential

# Python IDLE editor
$PKG_INSTALL_PREFIX idle-python2* idle-python3* python-tk

#For lxml
$PKG_INSTALL_PREFIX libxml2-dev
$PKG_INSTALL_PREFIX libxslt-dev

# Download the latest pip package from source
python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo -H python3

# Use pip to upgrade setuptools
sudo -H pip install --upgrade setuptools
sudo -H pip3 install --upgrade setuptools

# virtualenv
sudo -H pip install virtualenv
sudo -H pip install virtualenvwrapper

sudo -H pip install jupyter
sudo -H pip3 install jupyter

#http://virtualenvwrapper.readthedocs.org/en/latest/install.html#lazy-loading
export WORKON_HOME="$HOME"/.virtualenvs
export PROJECT_HOME="$HOME"/Projects
VIRTUALENVWRAPPER_PREFIX="/usr/local/bin/virtualenvwrapper"

isVarDefined "$VIRTUALENVWRAPPER_PREFIX"
if [ $? -eq 0 ]; then
	if [ -f "$VIRTUALENVWRAPPER_PREFIX"_lazy.sh  ]; then
		export VIRTUALENVWRAPPER_SCRIPT="$VIRTUALENVWRAPPER_PREFIX""_lazy.sh"
		source "$VIRTUALENVWRAPPER_SCRIPT"
	elif [ -f "$VIRTUALENVWRAPPER_PREFIX".sh ]; then
		export VIRTUALENVWRAPPER_SCRIPT="$VIRTUALENVWRAPPER_PREFIX"".sh"
		source "$VIRTUALENVWRAPPER_SCRIPT"
	fi
fi

cd "$HOME"

mkvirtualenv --python=/usr/bin/python2 --no-site-packages py2venv
pip install -U pip
sudo -H pip install coursera-dl pyopenssl requests jupyter
deactivate

# Numpy and Scipy
$PKG_INSTALL_PREFIX python-numpy python-scipy python-matplotlib python-pandas python-sympy python-nose python-h5py
$PKG_INSTALL_PREFIX python3-numpy python3-scipy python3-matplotlib python3-pandas python3-nose python3-h5py

# Clone and install go-ethereum and cpp-ethereum...
chmod +x "$OLDDIR"/bin_scripts/autobuild_eth.sh
source "$OLDDIR"/bin_scripts/autobuild_eth.sh


