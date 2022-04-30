#!/bin/bash
# By Pytel
# Skript pro instalaci:
# htop - interaktivni top 

#DEBUG=true
DEBUG=false

# colors
RED='\033[0;31m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
user=$(. $BASEDIR/get_curent_user.sh)
if [ $? != 0 ]; then
	$DEBUG && echo $user
    echo -e "${RED}Unable to parse user!${NC}"
    exit 2
fi
path="/home/$user"              # cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

# instalace
app="htop"
$path/Shell/tools/install_app.sh $app || exit $?

# konfigurace
echo -en "${Green}Setting up configuration: ${NC}"
file=/home/$user/.config/htop/htoprc
if [ ! -f $file ]
then
	echo -e "${Red}Config file does not exist!${NC}"
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
