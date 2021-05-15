#!/bin/bash
# By Pytel
# Skript pro instalaci:
# plugin ikony pro ranger

#DEBUG="true"
DEBUG="false"

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
user=$(. $BASEDIR/get_curent_user.sh)
if [ $? != 0 ]
then
        echo "Unable to parse user!"
        exit 2
fi

# colors
source /home/$user/Shell/colors.sh

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
