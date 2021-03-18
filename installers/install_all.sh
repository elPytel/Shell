#!/bin/bash
# By Pytel
# Skript pro instalaci mych oblibenych aplikaci

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

if [ $(whoami) != "root" ]
then
	echo -e "${RED}I nead root privileges!${NC}"
	exec sudo "$0" "$@"		# znovu zpusti sam sebe ale s pravy roota
	echo "Error: failed to execute sudo" >&2
	exit 1
fi

# aktualizace
./updater.sh

# instalace snap
apt install snapd

# instalace tpadu
snap install tpad

# grub customizer
add-apt-repository ppa:danielrichter2007/grub-customizer
apt install grub-customizer

# curl
apt install curl

# python
./python.sh

# git
./git.sh

# trash-cli
./trash.sh

# tty-clock
./clock.sh

# WordGrinder
./wordgrinder.sh

# LSDelux
./lsd.sh

# Bat-cat
./bat.sh

# Htop
./htop.sh

# ueberzug
./ueberzug.sh

# Ranger
./ranger.sh

# dalsi
apt install terminator
apt install odt2txt	# open dokument to txt

#apt install w3m	# WWW browsable pager with excellent tables/frames support
#apt install feh 	# feh is an X11 image viewer aimed mostly at console users

exit
#END
