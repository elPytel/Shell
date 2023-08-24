#!/bin/bash
# By Pytel
# instalace

DEBUG=false

BASEDIR=$(dirname "$0")     # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"          # cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

app="$1"
if [ -z $app ]; then
	echo -e "${Red}ERROR: app not selected!${NC}"
	exit 1
fi

# gain root
if [ $(whoami) != "root" ]
then
    echo -e "${Red}I nead root privileges!${NC}"
    exec sudo "$0" "$@" # znovu zpusti sam sebe ale s pravy roota
    echo "Error: failed to execute sudo" >&2
    exit 2
fi

# what is status of this package?
dpkg -s $app &>/dev/null
ret="$?"
$DEBUG && echo -e "ret: $ret"
if [ $ret -eq 0 ]; then
	$VERBOSE && echo -e "App: ${Blue}$app${NC} is installed!"
else
	$VERBOSE && echo -e "App: ${Blue}$app${NC} is not installed! \n instaling..."
	if apt install $app -y; then
		echo "Done"
	else
        echo -e "${Red}ERROR: failed to install ${Blue}$app${NC}!"
        exit 3
	fi
fi
exit 0
# END
