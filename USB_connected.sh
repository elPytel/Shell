#!/bin/bash
# By Pytel

DEBUG=false

unit=$1
# add entry to log
user="pytel"
path="/home/$user"
file=".my.log"
config=".USB2script.conf"
dateTime=$(date)
echo -e "USB device connected at: $dateTime" >> $path/$file
echo " $unit" >> $path/$file

bus=$(echo $unit | cut -d "/" -f5)
device=$(echo $unit | cut -d "/" -f6)

usb=$(lsusb | grep "Bus $bus" | cut -d" " -f3- | grep "Device $device")

ID=$(echo $usb | cut -d" " -f4)
VendorID=$(echo $ID | cut -d":" -f1)
ProductID=$(echo $ID | cut -d":" -f2)

if $DEBUG; then
	echo "unit: $unit"
	echo "USB: $usb"
	echo "ID: $ID"
	echo "VendorID: $VendorID"
	echo "ProductID: $ProductID"
fi

script="None"
cat "$path/Shell/$config" | grep -v "#" | grep "$ID" | while read -r entry ; do
#for entry in "$(cat "$path/Shell/$config" | grep -v "#" | grep "$ID")"; do
	if [ -z "$entry" ]; then break; fi;
	script=$(echo "$entry" | cut -d":" -f3-)
	if $DEBUG; then
		echo "entry: $entry"
		echo "script: $script"
	fi
	echo -e " Running script: $script" >> $path/$file
	# su -c "$script" $user
	su -c "echo '$script' | batch" $user 
done

exit 0
# END
