#!/bin/bash
# By Pytel
# Skript pro instalaci mych oblibenych aplikaci

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

python_dependencies="pip-dependencies.txt"
apt_dependencies="apt-dependencies.txt"
snap_dependencies="snap-dependencies.txt"

if [ $(whoami) != "root" ]
then
	echo -e "${RED}I need root privileges!${NC}"
	exec sudo "$0" "$@"		# znovu zpusti sam sebe ale s pravy roota
	echo "Error: failed to execute sudo" >&2
	exit 1
fi

# aktualizace
. ../updater.sh -y

# dalsi
./check_and_install_packages.sh $apt_dependencies

# instalace snap
apt install snapd -y

# instalace tpadu
./install_snap_packages.sh $snap_dependencies

# grub customizer
add-apt-repository ppa:danielrichter2007/grub-customizer
apt install grub-customizer

# Vim
./vim.sh

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

# ShellCheck
./ShellCheck.sh

# at
./at.sh

# dalsi
#apt install w3m	# WWW browsable pager with excellent tables/frames support
#apt install feh 	# feh is an X11 image viewer aimed mostly at console users

exit
#END
