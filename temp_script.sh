WGET_CMD="wget -qO-"

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
$WGET_CMD http://download.qt.io/official_releases/qt/5.6/5.6.0/qt-opensource-linux-x64-5.6.0.run &> /dev/null

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
$WGET_CMD https://pkg.tox.chat/debian/pkg.gpg.key | sudo apt-key add -
sudo apt-get install apt-transport-https
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX qtox

# See all available packages
# cat /var/lib/apt/lists/pkg.tox.chat* | grep "Package: "

# Set up Clojure with leiningen
cd $MY_BIN_DIR
$WGET_CMD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein &> /dev/null
chmod a+x $MY_BIN_DIR/lein
lein

# Install elixir
cd $MY_DEV_DIR/temp
$WGET_CMD http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc &> /dev/null
sudo apt-key add erlang_solutions.asc
$PKG_REFRESH_PREFIX
$PKG_INSTALL_PREFIX erlang erlang-nox
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
#python < <(curl -s -S -L https://bootstrap.pypa.io/get-pip.py)
$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo -H python
$WGET_CMD https://bootstrap.pypa.io/get-pip.py | sudo -H python3

# Use pip to upgrade setuptools
sudo -H pip install --upgrade setuptools
sudo -H pip3 install --upgrade setuptools

# virtualenv
sudo -H pip install virtualenv
sudo -H pip install virtualenvwrapper

sudo -H pip install youtube-dl coursera-dl pyopenssl requests jupyter numpy scipy matplotlib pandas sympy nose h5py
sudo -H pip3 install youtube-dl coursera-dl pyopenssl requests jupyter numpy scipy matplotlib pandas sympy nose h5py

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
#
deactivate

# Clone and install go-ethereum and cpp-ethereum...
chmod +x "$OLDDIR"/bin_scripts/autobuild_eth.sh
source "$OLDDIR"/bin_scripts/autobuild_eth.sh


