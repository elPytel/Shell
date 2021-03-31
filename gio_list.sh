#!/bin/bash
# By Pytel
# Skript pro praci s gio na pripojovani sitovych disku

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/installers/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/colors.sh

gio list -a "standard::display-name" | cut -d"=" -f2

exit 0
#END
