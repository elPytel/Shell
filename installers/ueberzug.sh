#!/bin/bash
# By Pytel
# Skript pro instalaci:
# Überzug is a command line util which allows to draw images on terminals by using child windows.

#DEBUG="true"
DEBUG="false"

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
# $USERNAME - nefunguje na roota
user=$(. $BASEDIR/get_curent_user.sh)
if [ $? != 0 ]; then
	[ $DEBUG ] && echo $user
        echo -e "Unable to parse user!"
        exit 2
fi

user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum


# colors
source $path/colors.sh


echo -e "${Green}Installing ueberzug: ${NC}"
pip3 install ueberzug
# pip install ueberzug
echo "Done"

echo -en "${Green}One time path export: ${NC}"
export PATH=/home/$user/.local/bin:$PATH
echo "Done"

exit
#END
