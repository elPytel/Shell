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

function apt_intall () { # app
    local app="$1"
    if ! dpkg -s "$app" &>/dev/null; then
        echo "Installing $app..."
        if apt install "$app" -y; then
            echo "Done"
        else
            echo -e "${Red}ERROR: failed to install ${Blue}$app${NC}!"
            exit 3
        fi
    else
        echo "App: ${Blue}$app${NC} is already installed!"
    fi
}

function apk_install () { # app
    local app="$1"
    if ! apk info "$app" &>/dev/null; then
        echo "Installing $app..."
        if apk add "$app"; then
            echo "Done"
        else
            echo -e "${Red}ERROR: failed to install ${Blue}$app${NC}!"
            exit 4
        fi
    else
        echo "App: ${Blue}$app${NC} is already installed!"
    fi
}

# Check if the package manager is apt or apk
if command -v apt &>/dev/null; then
	apt_intall "$app"
elif command -v apk &>/dev/null; then
	apk_install "$app"
else
	echo -e "${Red}ERROR: No supported package manager found!${NC}"
	exit 5
fi

exit 0
# END
