#!/bin/bash

# https://gist.github.com/jpswade/b5907dbb7210812d941040b3ebfbc504
# http://xkcd.com/1654/
# http://webcache.googleusercontent.com/search?q=cache:b4rsDCg1gCAJ:www.ocsmag.com/2016/04/16/universal-install-script-by-xkcd-combat-test/&num=1&hl=en&gl=us&strip=1&vwsrc=0

pip install "$1" 2>/dev/null
easy_install "$1" 2>/dev/null
brew install "$1" 2>/dev/null
npm install "$1" 2>/dev/null
yum install "$1" 2>/dev/null
dnf install "$1" 2>/dev/null
docker run "$1" 2>/dev/null
pkg install "$1" 2>/dev/null
apt-get install "$1" 2>/dev/null
apk add “$1” 2>/dev/null # alpine
xbps-install -S “$1” 2>/dev/null # void
pacman -S “$1” 2>/dev/null # arch
emerge “$1” 2>/dev/null # gentoo
urpmi “$1” 2>/dev/null # mandriva
choco install “$1” 2>/dev/null # :)
install-package “$1” 2>/dev/null # :(
steamcmd +app_update "$1" validate 2>/dev/null
#git clone https://github.com/"$1"/"$1" $1 2>/dev/null
[ -d "$1" ] && bash -c 'cd "$1" ./configure; make; make install 2>/dev/null'
curl "$1" | bash 2>/dev/null

exit 0
