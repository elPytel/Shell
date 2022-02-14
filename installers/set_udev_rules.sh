#!/bin/bash
# By Pytel
# Add rule to /etc/udev/rules.d/ to run special script after connecting USB.

#DEBUG=true
DEBUG=false
#VERBOSE=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# colors
source ../tools/colors.sh

# find user name
user=$(. ../tools/get_curent_user.sh)
if [ $? != 0 ]; then
        [ $DEBUG ] && echo $user
	echo -e "${Red}Error${NC}: Unable to parse user!" >&2
        exit 2
fi

if [ $(whoami) != "root" ]
then
	echo -e "${Red}I nead root privileges!${NC}"
	exec sudo "$0" "$@"
	echo -e "${Red}Error${NC}: failed to execute sudo" >&2
	exit 1
fi

file="50-USB_connected_script.rules"
pathRules="/etc/udev/rules.d/"
path="/home/$user/Shell"
script="USB_connected.sh"

if [ -f "$pathRules/$file" ]; then
	echo -e "${Red}Error${NC}: file already exist!" >&2
	exit 3
fi

touch "$pathRules/$file"
cat >> "$pathRules/$file" <<EOF
ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="*", ATTRS{idProduct}=="*", RUN+="$path/$script '%E{DEVNAME}'" 
EOF

udevadm control --reload-rules

$VERBOSE && echo "Done"
exit 0
# END
