#!/bin/bash
# By Pytel
# Script for checking if needed software is instaled and instaling it if is not already.

#DEBUG=true
DEBUG=false

VERBOSE=true
#VERBOSE=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) <path/file_name>"
}

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"	        # cesta k /home/user 

if $DEBUG; then
	echo $user
	echo $path
fi

# colors
source $path/Shell/tools/colors.sh

apps="tpad"

# zadal validni argumenty?
case $# in
	0) printHelp; exit 2;;
	1) file=$1;;
	*) echo -e "${Red}Invalid options: $@${NC}"; exit 1;;
esac


# existuje soubor?
if [ ! -f $file ]; then
	echo -e "${Red}ERROR: ${NC}File: ${Blue}$file ${NC}does not exit!${NC}";
	exit 3
fi

apps=$(cat $file | grep -v "#" | grep "\S")

$DEBUG && echo -e "Apps to install: \n$apps"

if [ $(whoami) != "root" ]
then
	echo -e "${Red}I nead root privileges!${NC}"
	exec sudo "$0" "$@"	# znovu zpusti sam sebe ale s pravy roota
	echo "Error: failed to execute sudo" >&2
	exit 1
fi

for app in $apps; do
    sudo snap install $app
done

$VERBOSE && echo -e "Done"
exit 0
# END
