#!/bin/bash
# By Pytel
# Skript pro instalaci:
# at 

#DEBUG=true
DEBUG=false

# colors
RED='\033[0;31m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
user=$(. $BASEDIR/../tools/get_curent_user.sh)
if [ $? != 0 ]; then
	$DEBUG &&  echo $user
	echo -e "${RED}Unable to parse user!${NC}"
	exit 2
fi

path="/home/$user"

# colors
source $path/Shell/tools/colors.sh

# instalace
app="at"
$path/Shell/tools/install_app.sh $app || exit $?

# enable service
systemctl enable --now atd

echo "Done"
exit 0
#END
