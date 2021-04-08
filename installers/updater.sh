#!/bin/bash
# By Pytel
# Skript pro automatickou aktualizaci

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/tools/colors.sh

if [ $(whoami) != "root" ]	# kdyz neni root
then
        echo -e "${Red}I nead root privileges!${NC}"
        sudo $0 $1        # znovu zpusti sam sebe ale s pravy roota
        exit 1
fi

# argumenty
arg=""
if [ "$1" == "-y" ]
then
        arg=$1
fi

# aktualizace
echo -e "${Green}Update:${NC}"
apt-get update
echo -e "${Green}Upgrade:${NC}"
apt-get upgrade $arg

exit 0
#END
