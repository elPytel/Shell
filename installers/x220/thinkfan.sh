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
# sudo sensors-detect

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

$VERBOSE && echo -e "Enabling: fan_control"
echo "options thinkpad_acpi fan_control=1" >> /etc/modprobe.d/thinkpad_acpi.conf
modprobe thinkpad_acpi

echo 'THINKFAN_ARGS="-c /etc/thinkfan.conf"' >> /etc/default/thinkfan
echo 'START=yes' >> /etc/default/thinkfan

config="/etc/thinkfan.conf"
cat > $config <<EOF
######################################################################
#
# IBM/Lenovo Thinkpads (thinkpad_acpi, /proc/acpi/ibm)
# ====================================================
#  Syntax:
#  (LEVEL, LOW, HIGH)
#  LEVEL is the fan level to use (0-7 with thinkpad_acpi)
#  LOW is the temperature at which to step down to the previous level
#  HIGH is the temperature at which to step up to the next level
#  All numbers are integers.

tp_fan /proc/acpi/ibm/fan
EOF

find /sys/devices -type f -name "temp*_input"|sed 's/^/hwmon /g' >> $config

cat >> $config <<EOF

(0,	0,	60)
(1,	60,	65)
(2,	65,	70)
(3,	70,	75)
(4,	75,	80)
(5,	80,	85)
(7,	85,	90)
(127, 90, 32767)

# END
EOF

systemctl enable thinkfan

$VERBOSE && echo -e "All: Done"

exit 0
#END
