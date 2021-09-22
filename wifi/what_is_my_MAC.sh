#!/bin/bash
# By Pytel
# Will return your MAC address

#DEBUG=true
DEBUG=false

VERBOSE=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) [interface]"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
}

function listInterfaces () {
	echo "$(ifconfig | grep -v "^[[:space:]]" | grep ":" | cut -d ":" -f 1)"
}

$DEBUG && echo "Args: [$*]"

# input args
arg=$1

interface=""
interfaces=$(listInterfaces)

# parse input
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug)	DEBUG=true;;
		-v | --verbose)	VERBOSE=true;;
		*) interface="$1"; $VERBOSE && echo "Interface set: $interface";;
	esac

	# next arg
	shift
	arg=$1
done

# invalid interface
if [ ! -z "$interface" ] && [ $(echo "$interfaces" | grep "$interface" -c) -ne 1 ]; then
	echo -e "${RED}ERROR: ${NC}invalid interface!" 1>&2
	exit 3
fi

echo "$(ifconfig $interface | grep "ether" | tr -s " " | cut -d " " -f 3)"

$VERBOSE && echo "Done"
exit 0 
# END
