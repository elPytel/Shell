#!/bin/bash
# By Pytel
# Skript pro instalaci:
# ranger - a text-based file manager written in Python. Directories are displayed in one pane with three columns.

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")		# adresa k tomuto skriptu

# find user name
# $USERNAME - nefunguje na roota
user=$(. $BASEDIR/get_curent_user.sh)
if [ $? != 0 ]; then
	[ $DEBUG ] && echo $user
	echo -e "${RED}Unable to parse user!${NC}"
        exit 2
fi

config="/home/$user/.config/ranger"

if [ $# -gt 0 ]
then
	case "$1" in
		"uninstall")
			# unistalace
			echo -e "${GREEN}Uninstalling ranger: ${NC}"
		        apt remove ranger
		        echo -e "${GREEN}Removing config: ${NC}"
		        rm -r $config
		        echo "Done"
		        exit 0
		;;
		*)
			# Default condition
			echo -e "${RED}Unable to parse: $1${NC}"
			exit 2
		;;
	esac
fi

# instalace
echo -e "${GREEN}Installing ranger: ${NC}"
apt install ranger
echo "Done"

# konfigurace
echo -e "${GREEN}Ranger config files: ${NC}"
[ ! -d $config ] && su - $user -c "mkdir -p $config"

if [ $(ls $config | wc -l) -eq 0 ]
then
	su - $user -c "ranger --copy-config=all" && echo "Generated new ones."
fi

file="rc.conf"
# enable preview script
line="#set preview_script ~\/.config\/ranger\/scope.sh"
new_line="set preview_script ~\/.config\/ranger\/scope.sh"
sed -i "s/$line/$new_line/" $config/$file && echo "Image preview script enabled."

# enable image preview
line="set preview_images "
value=" true"
number=$(cat -n $config/$file | grep "$line" | cut -f1 | tr -d " ")
#echo $number	# DEBUG
new_line="$line$value"
sed -i $number's/.*/'"$new_line/" $config/$file	&& echo "Image preview enabled."

# Mam stazeny ueberzug?
if [ -f /home/$user/.local/bin/ueberzug ]
then
	line="set preview_images_method"
	value="ueberzug"
	number=$(cat -n $config/$file | grep "$line" | cut -f1 | tr -d " ")
        new_line="$line $value"
        sed -i $number's/.*/'"$new_line/" $config/$file && echo -e "Image preview metod set to ${BLUE}$value${NC}."
fi

# enable draw borders
line="set draw_borders"
value="both"
number=$(cat -n $config/$file | grep "$line" | cut -f1 | tr -d " ")
new_line="$line $value"
sed -i $number's/.*/'"$new_line/" $config/$file && echo "Borders enabled."

# plugins
# pridani ikon
echo -e "${GREEN}Ranger installing plugins: ${NC}"
./ranger_devicons_plugin.sh
#TODO

# nastavi promnene prostredi
echo -e "${GREEN}Setting environment: ${NC}"
env=".bash_environment"
if [ ! -f ~/$env ] 
then
	touch ~/$env && echo -e "File ${BLUE}$env${NC} created."
fi

variable=RANGER_LOAD_DEFAULT_RC
value=FALSE
new_line="$variable=$value"
if [ $(cat ~/$env | grep "$variable" | wc -l) -eq 0 ]
then
	echo -e "\n$new_line" >> ~/$env
else
	number=$(cat -n ~/$env | grep "$variable" | cut -f1 | tr -d " ")
	sed -i "$number"'s/.*/'"$new_line/" ~/$env
fi
echo -e "Environmental variable ${BLUE}$variable${NC} was set to: ${BLUE}$value${NC}"

. $BASEDIR/bashrc_updater.sh

echo "Done"

exit 0
#END
