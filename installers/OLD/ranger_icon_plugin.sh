#!/bin/bash
# By Pytel
# Skrip pro instalaci:
# plugin ikony pro ranger

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=pytel
#su - $user -c ""
plugin=ranger_icon_plugin
if [ ! -d $plugin/ ]
then
        git clone https://github.com/LinXueyuanStdio/$plugin
fi
#make --makefile=$plugin/Makefile install
cd $plugin
if [ $1 == "install" ]
then
	make install
elif [ $1 == "uninstall" ]
then
	make uninstall
fi

if [ $BASEDIR == "." ]
then
	cd ..
else
	cd $BASEDIR
fi

# clear
sudo rm -r $plugin

exit 0
#END
