#!/bin/bash
# By Pytel
# I will change your MAC

#DEBUG=true
DEBUG=false

VERBOSE=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) -i [interface] -m [MAC] COMMANDS"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
	echo -e "  -l --list \t list all Vendors"
	echo -e "  -f --file \t load file"
	echo -e "  -i --interface set interface: <>"
	echo -e "  -m --MAC  \t set MAC address: <>"
	echo -e "  -v --vendor\t set Vendor: <>"
	echo -e "  -R --random\t make random pic of MAC"
}

function listVendors () {
	cat $file | grep "#" | tr " " "\n" | grep "#" -v
}

function setVendor () { #( vendor )
	local _vendor="$1"
	if [ $(echo "$(listVendors)" | grep $_vendor -c) -ne 1 ]; then
		echo -e "${RED}ERROR: ${NC}unknown interface!" 1>&2
        return 2
	fi
	vendor=$_vendor
	return 0
}

function setFile () { #( file )
	local _file=$1
	if [ ! -f $_file ]; then
		echo -e "${RED}ERROR: ${NC}file does not exist!" 1>&2
		return 2
	fi
	file=$_file
}

function setInterface () { #( interface )
    # not one argument
	if [ $# -ne 1 ]; then
		$VERBOSE && echo -e "ERROR: ${NC}interface not specified!"
		return 1
	fi
	# empty argument
	if [ -z "$1" ]; then
		$VERBOSE && echo -e "ERROR: ${NC}empty interface!"
		return 2
	fi
	interface=$1	# global!!
	# not from existing interfaces
	if [ $(echo "$interfaces" | grep -x "$interface" -c) -ne 1 ]; then
		$VERBOSE && echo -e "ERROR: ${NC}invalid interface!"
		return 3
	fi
	$DEBUG && echo -e "Interface set: $interface"
    return 0
}

function setMAC () { #( MAC ) 
	local mac="$1"
	if [ $(echo "$mac" | grep -o . | grep ":" -c) -ne 5 ]; then
		$VERBOSE && echo -e "ERROR: ${NC}invalid MAC!"
		return 3
	fi
	MAC="$mac"
	return 0
}

function listInterfaces () {
	echo "$(ifconfig | grep -v "^[[:space:]]" | grep ":" | cut -d ":" -f 1)"
}

interface=""
interfaces="$(listInterfaces)"
file="Vendors_MAC.txt"
vendor=""
random=false

if [ $(whoami) != "root" ]
then
	echo -e "${RED}I need root privileges!${NC}"
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
		-l | --list)	echo "$(listVendors)"; exit 3;;
		-f | --file)	shift; setFile $1 || exit 4;;
		-V | --vendor)	shift; setVendor $1 || exit 5;; 
		-i | --interface) shift; setInterface $1 || exit 6;;
		-m | --MAC)		shift; setMAC $1 || exit 7;;
		-R | --random)	random=true;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

if $DEBUG; then
	echo "Interface: $interface"
	echo "Vendor: $vendor"
	echo "MAC: $MAC"
	echo "File: $file"
	echo -n "Random: "; $random && echo "True" || echo "False"
fi

# invalid interface
if [ -z "$interface" ] || [ $(echo "$interfaces" | grep "$interface" -c) -ne 1 ]; then
    echo -e "${RED}ERROR: ${NC}invalid interface!" 1>&2
    exit 3
fi

# prepare MAC
if [ -z $MAC ]; then
	if [ ! -z "$vendor" ]; then
		# pic one from list
		line=$(cat Vendors_MAC.txt | grep "#" -v | grep "$vendor" | shuf -n 1)
		partMAC=$(echo $line | cut -d " " -f 2)
		# select the 6 other chars
		for i in {1..3}; do
			twoRndChar=$(cat /dev/urandom | tr -dc '0-9a-f' | fold -w 2 | head -n 1)
			partMAC="$partMAC:$twoRndChar"
		done
	elif $random; then
		# select TOTALY random MAC
		partMAC=$(cat /dev/urandom | tr -dc '0-9a-f' | fold -w 2 | head -n 1)
		for i in {1..5}; do
			twoRndChar=$(cat /dev/urandom | tr -dc '0-9a-f' | fold -w 2 | head -n 1)
			partMAC="$partMAC:$twoRndChar"
		done
	else
		# select random vendor
		line=$(cat Vendors_MAC.txt | grep "#" -v | shuf -n 1)
		vendor=$(echo $line | cut -d " " -f 1)
		partMAC=$(echo $line | cut -d " " -f 2)
		# select the 6 other chars
		for i in {1..3}; do
			twoRndChar=$(cat /dev/urandom | tr -dc '0-9a-f' | fold -w 2 | head -n 1)
			partMAC="$partMAC:$twoRndChar"
		done
		$VERBOSE && echo "Selected Vendor: $vendor"
	fi
	MAC=$partMAC
	$VERBOSE && echo "New generated MAC: $MAC"
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
