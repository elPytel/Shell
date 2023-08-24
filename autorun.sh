#!/bin/bash
# By Pytel
# Auto run script on change

#DEBUG=true
DEBUG=false

VERBOSE=false

BASEDIR=$(dirname "$0")     # adresa k tomuto skriptu
user=$(. $BASEDIR/tools/get_curent_user.sh)
path="/home/$user"        	# cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

if [[ $# -eq 0 ]]; then
    echo -e "${Red}ERROR${NC}: no file is specified!"
    exit 1
fi

file="$1"

chmod +x $file &&
echo $file | entr -c ./$file; echo ""

$DEBUG && echo "Done"
#END
