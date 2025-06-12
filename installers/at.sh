#!/bin/bash
# By Pytel
# Skript pro instalaci:
# at 

#DEBUG=true
DEBUG=false

# colors
RED='\033[0;31m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"

# colors
source $path/Shell/tools/colors.sh

# instalace
app="at"
$path/Shell/tools/install_app.sh $app || exit $?

echo "Done"
exit 0
#END
