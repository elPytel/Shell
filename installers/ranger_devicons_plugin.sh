#!/bin/bash
# By Pytel
# Skript pro instalaci:
# plugin ikony pro ranger

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

#su - $user -c ""

plugin="ranger_devicons"
path="/home/$user/.config/ranger/plugins"
config="/home/$user/.config/ranger"
file="rc.conf"

if [ ! -d $path/$plugin ] 
then
	su - $user -c "git clone https://github.com/alexanderjeurissen/ranger_devicons $path/$plugin"
	echo -e "Plugin: ${BLUE}$plugin${NC} downloaded."
fi

line="default_linemode"
value="devicons"
new_line="$line $value"
if [ $(cat $config/$file | grep "$line" | wc -l) -eq 0 ]
then
        echo -e "\n$new_line" >> $config/$file
else
        number=$(cat -n $config/$file | grep "$line" | cut -f1 | tr -d " ")
        sed -i $number's/.*/'"$new_line/" $config/$file
fi
echo -e "${BLUE}$line${NC} was set to: ${BLUE}$value${NC}"

exit 0
#END
