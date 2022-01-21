#!/bin/bash
# By Pytel
# instalation script for ThinkFan

# https://www.thinkwiki.org/wiki/How_to_control_fan_speed
# echo level 0 | sudo tee /proc/acpi/ibm/fan (fan off)
# echo level 7 | sudo tee /proc/acpi/ibm/fan (maximum speed)
# echo level auto | sudo tee /proc/acpi/ibm/fan (automatic - default)
# echo level disengaged | sudo tee /proc/acpi/ibm/fan (disengaged)

#DEBUG=true
DEBUG=false

VERBOSE=true
#VERBOSE=false

BASEDIR=$(dirname "$0")         # my path

# find user name
user=$(. $BASEDIR/../../tools/get_curent_user.sh)
if [ $? != 0 ]; then
	$DEBUG &&  echo $user
	echo -e "${RED}Unable to parse user!${NC}"
	exit 2
fi

path="/home/$user/"

# colors
source $path/Shell/tools/colors.sh

# gain root
if [ "$(whoami)" != "root" ]	# if not root
then
	echo -e "${Red}I nead root privileges!${NC}"
	sudo "$0" "$1"        # re-run itself as root
	exit 1
fi

apps="lm-sensors thinkfan"

# instalation
for app in $apps; do
	# what is status of this package?
	dpkg -s $app &>/dev/null
	ret="$?"
	$DEBUG && echo -e "ret: $ret"
	if [ $ret -eq 0 ]; then
		$VERBOSE && echo -e "App: ${Blue}$app${NC} is installed!"
	else
		$VERBOSE && echo -e "App: ${Blue}$app${NC} is not installed!"
		echo -e "${Green}Installing ${Blue}$app: ${NC}"
		if apt install $app -y; then
        	echo "Done"
		else
        	echo -e "${Red}ERROR: failed to install ${Blue}$app${NC}!"
        exit 1
		fi
    fi
done

$VERBOSE && echo -e "Instalation: Done"

$VERBOSE && echo -e "Enabling: fan_control."
echo "options thinkpad_acpi fan_control=1" >> /etc/modprobe.d/thinkpad_acpi.conf
# modprobe thinkpad_acpi

$VERBOSE && echo -e "All: Done"

exit 0
#END
