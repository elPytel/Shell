#!/bin/bash
# By Pytel
# List all SSID

#DEBUG=true
DEBUG=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) COMMAND"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h --help \t\t print help."
	echo -e "  -s --sort \t\t print output sorted."
	echo -e "  -d --debug \t\t debug mode."
}

sortem=false

# zadal validni argumenty?
case $# in
	0) ;;
	1) arg=$1;;
	*)
		echo -e "${Red}Invalid options:${NC} $@"
		exit 1;;
esac

# Valid arguments?
case $arg in
	"") ;;
	"-h" | "--help") printHelp; exit 2;;
	"-s" | "--sort") sortem=true;;
	"-d" | "--debug") DEBUG=true;;
	*) echo -e "${Red}Invalid options:${NC} $@"; exit 1;;
esac


devices=$(ls /sys/class/net/ | egrep -v ^lo$)
SSIDs=""

# Are there any network devices?
if [ $(echo $devices | wc -w) -eq 0 ]; then
	echo "ERROR: no network devices!"
	exit 3
fi

# Search for Access Points
for device in $devices; do
	$DEBUG && echo " Device: $device"
	SSID=$(sudo iw dev $device scan | grep "SSID: ." | tr -d " " | cut -d ":" -f2)
	$DEBUG && echo -e "\t SSID: \n$SSID"
	SSIDs+=$SSID
done 2>/dev/null

if $sortem; then
	SSIDs=$(echo $SSIDs | tr " " "\n" | sort -u)
	$DEBUG && echo -e "Sorting: DONE"
fi

echo "$SSIDs" #| tr " " "\n"
exit 0
# END
