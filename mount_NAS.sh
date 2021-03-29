#!/bin/bash
# By Pytel
# Skript pro praci s gio na pripojovani sitovych disku

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptui
user=$(. $BASEDIR/installers/get_curent_user.sh)
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/colors.sh

# zadal validni argumenty?
if [ $# -eq 0 ]
then
	echo -e "${Green}Valid arguments: ${NC} -m --mount | -u --unmount | -l --list"
        exit 2
elif [ $# -eq 1 ]
then
        arg=$1
else
        echo -e "${Red}Invalid options: $@${NC}"
        exit 1
fi


config=".mount.conf"
line=$(cat -n $config | grep "SMB" | cut -f1 | tr -d " ")
NUM=$(( line + 1 ))
name=$(sed "${NUM}q;d" $config | cut -d"=" -f2)
NUM=$(( line + 2 ))
path=$(sed "${NUM}q;d" $config | cut -d"=" -f2)

if $DEBUG; then
	echo "Name: $name"
	echo "Path: $path"
fi

#"/media/$user/$name"

case $arg in
	"-m" | "--mount")
		# pripoji sitovy disk
                echo -e "${Green}Mounting: ${Blue}$name${NC}"
                gio mount "$path"
        ;;
        "-u" | "--unmount")
                # odpoji se od sitoveho disku
		echo -e "${Green}Unmounting: ${Blue}$name${NC}"
                gio mount -u "$path"
        ;;
        "-l" | "--list")
                # vypise pripojene disky
                gio mount -l | grep "^[^ ]" | grep "Mount"
        ;;
        *)
                # Default condition
                echo -e "${Red}Unknown parametr: $arg${NC}"
                exit 2
        ;;
esac


exit
#END
