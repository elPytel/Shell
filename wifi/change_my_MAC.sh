#!/bin/bash
# By Pytel
# I will change your MAC

#DEBUG=true
DEBUG=false

VERBOSE=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) [interface] [MAC] COMMANDS"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
}

function listInterfaces () {
	echo "$(ifconfig | grep -v "^[[:space:]]" | grep ":" | cut -d ":" -f 1)"
}

interface=""
interfaces="$(listInterfaces)"

if [ $(whoami) != "root" ]
then
	echo -e "${RED}I nead root privileges!${NC}"
	$DEBUG && echo "Running: sudo $0 $@"
	exec sudo "$0" "$@"		# znovu zpusti sam sebe ale s pravy roota
	echo "Error: failed to execute sudo" >&2
	exit 1
fi

$DEBUG && echo "Args: [$*]"

# input args
case $# in
	0) printHelp; exit 2;;
	*) arg=$1;;
esac

while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help)    printHelp; exit 2;;
		-d | --debug)   DEBUG=true;;
		-v | --verbose) VERBOSE=true;;
		*) interface="$1"; shift; MAC="$1"; $VERBOSE && echo "Interface set: $interface";;
	esac

	# next arg
	shift
	arg=$1
done

if $DEBUG; then
	echo "Interface: $interface"
	echo "MAC: $MAC"
fi

# invalid interface
if [ ! -z "$interface" ] && [ $(echo "$interfaces" | grep "$interface" -c) -ne 1 ]; then
        echo -e "${RED}ERROR: ${NC}invalid interface!" 1>&2
        exit 3
fi

oldMAC=$(ifconfig $interface | grep "ether" | tr -s " " | cut -d " " -f 3)

# change MAC
ifconfig $interface down && $VERBOSE && echo "Switching: DOWN"
ifconfig $interface hw ether $MAC && $VERBOSE && echo "Changing MAC ..."
ifconfig $interface up && $VERBOSE && echo "Switching: UP"

newMAC=$(ifconfig $interface | grep "ether" | tr -s " " | cut -d " " -f 3)

if $VERBOSE; then
	echo "$interface, old MAC: $oldMAC"
	echo "$interface, new MAC: $newMAC"
fi

$VERBOSE && echo "Done"
exit 0
# END

