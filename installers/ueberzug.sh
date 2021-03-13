#!/bin/bash
# By Pytel
# Skript pro instalaci:
# Überzug is a command line util which allows to draw images on terminals by using child windows.

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
# $USERNAME - nefunguje na roota
user=$(. $BASEDIR/get_curent_user.sh)
#echo $user
if [ $? != 0 ]
then
        echo -e "${RED}Unable to parse user!${NC}"
        exit 2
fi


echo -e "${GREEN}Installing ueberzug: ${NC}"
pip install ueberzug
echo "Done"

echo -en "${GREEN}One time path export: ${NC}"
export PATH=/home/$user/.local/bin:$PATH
echo "Done"

exit
#END
