#!/bin/bash
# By Pytel
# Skript pro instalaci:
# htop - interaktivni top 

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

# instalace
echo -e "${GREEN}Installing htop: ${NC}" 
apt install htop
echo "Done"

# konfigurace
echo -en "${GREEN}Setting up configuration: ${NC}"
file=/home/$user/.config/htop/htoprc
if [ ! -f $file ]
then
	echo -e "${RED}Config file does not exist!${NC}"
	exit 1
fi
number=$(cat -n $file | grep "left_meters" | cut -f1 | tr -d " ")
new_line='left_meters=AllCPUs Memory Swap'
sed -i "$number"'s/.*/'"$new_line/" $file

number=$(cat -n $file | grep "left_meter_" | cut -f1 | tr -d " ")
new_line='left_meter_modes=1 1 1'
sed -i "$number"'s/.*/'"$new_line/" $file

number=$(cat -n $file | grep "right_meters" | cut -f1 | tr -d " ")
new_line='right_meters=Battery CPU Clock Uptime Tasks LoadAverage'
sed -i "$number"'s/.*/'"$new_line/" $file

number=$(cat -n $file | grep "right_meter_" | cut -f1 | tr -d " ")
new_line='right_meter_modes=1 1 2 2 2 2'
sed -i "$number"'s/.*/'"$new_line/" $file

echo "Done"

exit 0
#END
