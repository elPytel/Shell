#!/bin/bash
# By Pytel
# Skript pro instalaci:
# git - verzovaci system pro spravu softwaru

#DEBUG="true"
DEBUG="false"

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum

if $DEBUG; then
	echo $user
	echo $path
fi

# colors
source $path/colors.sh

# instalace gitu
apt install git

# configurace
echo -e "${Green}Git config${NC} "
echo -en "${Green}Your email: ${NC} "
read email
echo -en "${Green}Your name: ${NC} "
read name
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# vygenerovani Tokenu
echo -e "${Red}Make your own git token instead of password!${NC}"
echo "https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token"
echo -e "${Green}Press Enter${NC}"
read

# nastavi ukladani hesla
git config --global credential.helper store
# git config credential.helper cache <timeout> # timeout v sec.

exit 0
#END

