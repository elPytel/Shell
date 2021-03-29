#!/bin/bash
# By Pytel
# Skript pro praci zalohovani dat mezi disky pomoci rsync
# parametry programu rsync:
# -a archivuj
# -r rekurzivne

DEBUG=true
#DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptui
user=$(. $BASEDIR/installers/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/colors.sh

mount="/media/$user/"


# rsync -r $source/ $destination/
#/media/$user/

#END
