#!/bin/bash
# By Pytel
# Skript pro upravu chybejicich balicku

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source "$BASEDIR"/tools/colors.sh

if [ "$(whoami)" != "root" ]	# kdyz neni root
then
	echo -e "${Red}I nead root privileges!${NC}"
	sudo "$0" "$1"        # znovu zpusti sam sebe ale s pravy roota
	exit 1
fi

# argumenty
arg=""
if [ "$1" == "-y" ]
then
	arg=$1
fi

# list broken packages
echo -e "${Green}List broken:${NC}"
dpkg -l | grep ^..r

# fix missing packages
echo -e "${Green}Fix missing:${NC}"

# check for missing packages
apt-get update --fix-missing

# install missing packages
echo -e "${Green}Install missing:${NC}"
apt-get install -f

# configure broken allready installed packages
echo -e "${Green}Configure broken:${NC}"
dpkg --configure -a

echo -e "${Green}Done${NC}"
exit 0
#END