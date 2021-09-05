#!/bin/bash
# By Pytel
# Script for changing NIC up/off/mode state.

#DEBUG=true
DEBUG=false

# funtions

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) -i [interface] COMMANDs"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -D --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
	echo -e "  -d --down\t switch off network interface"
	echo -e "  -u --up\t switch on network interface"
	echo -e "  -m --mode\t set mode: <>"
	echo -e "  -i --interface set interface: <>"
	echo -e "  -t --test\t test interface for mods"
	echo -e "  -l --list\t list modes"
}

function listModes () {
        echo -e "MODES:"
	echo -e " $modes"
}

function loadIntefaces () {
	echo "$(hwinfo --network --short | grep -v ":" | tr -s " " | cut -d " " -f 2)"
}

function setInterface () { #( interface )
        # not one argument
	if [ $# -ne 1 ]; then
		$VERBOSE && echo -e "ERROR: interface not specified!"
		return 1
	fi
	# empty argument
	if [ -z "$1" ]; then
		$VERBOSE && echo -e "ERROR: empty interface!"
		return 2
	fi
	interface=$1	# global!!
	# not from existing interfaces
	if [ $(echo "$interfaces" | grep -x "$interface" -c) -ne 1 ]; then 
		$VERBOSE && echo -e "ERROR: invalid interface!"
		return 3
	fi
	$DEBUG && echo -e "Interface set: $interface"
        return 0
}

function setInterfaceDown () { #( interface )
	if [ $# -ne 1 ]; then
        	$VERBOSE && echo "ERROR: invalid args: [$*]"
		return 1
	fi
	# empty argument
        if [ -z "$1" ]; then
                $VERBOSE && echo -e "ERROR: empty interface!"
                return 2
        fi
	local interface=$1
	ip link set dev $interface down
	return $?
}

function setInterfaceUp () { #( interface )
        if [ $# -ne 1 ]; then
		$VERBOSE && echo "ERROR: invalid args: [$*]"
                return 1
        fi
	# empty argument
        if [ -z "$1" ]; then
                $VERBOSE && echo -e "ERROR: empty interface!"
                return 2
        fi
        local interface=$1
        ip link set dev $interface up
	return $?
}

function setInterfaceMode () { #( interface mode )
	if [ $# -ne 2 ]; then
		$VERBOSE && echo "ERROR: invalid args: [$*]"
		return 1
	fi
	# empty argument
        if [ -z "$1" ]; then
                $VERBOSE && echo -e "ERROR: empty interface!"
                return 2
        fi
	local interface=$1
	local mode=$2
	if [ $(echo "$modes" | grep "$mode" -c) -ne 1 ]; then
		return 3
	fi
	iwconfig $interface mode $mode
	local ret=$?
	return $ret
}

# program

VERBOSE=false
wifi="wlp3s0"
interface=""
interfaces=$(loadIntefaces)
modes="monitor managed"

if [ $(whoami) != "root" ]
then
	echo -e "${RED}I nead root privileges!${NC}"
	exec sudo "$0" "$@"	# znovu zpusti sam sebe ale s pravy roota
	echo "Error: failed to execute sudo" >&2
	exit 1
fi

$DEBUG && echo "Args: [$*]"

# input args
case $# in
	0) printHelp; exit 2;;
	*) arg=$1;;
esac

# parse input
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-l | --list)	listModes; exit 2;;
		-D | --debug)	DEBUG=true;;
		-v | --verbose)	VERBOSE=true;;
		-i | --interface) shift; setInterface $1 || exit 3;;
		-d | --down)	setInterfaceDown "$interface" || exit 4;;
		-u | --up)	setInterfaceUp "$interface" || exit 5;;
		-m | --mode)	setInterfaceMode "$interface" || exit 6;;
		-t | --test)	testInterface "$interface" || exit 7;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done


$VERBOSE && echo "Done"
exit 0 
# END
