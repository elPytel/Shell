#!/bin/bash
# By Pytel
# Script for changing NIC up/off/mode state.

#DEBUG=true
DEBUG=false

# functions

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
	echo -e "  -s --status\t return status: on/off mode"
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

function isInterfaceOn () { #( interface )
	# not one argument
        if [ $# -ne 1 ]; then
                $VERBOSE && echo -e "ERROR: ${NC}interface not specified!"
                return 1
        fi
	local interface=$1
	# ip a show "$interface"
	# iwconfig "$interface" 2>/dev/null | grep "$interface" | grep "off" -c
	local isOff=$(ip a show "$interface" | grep "DOWN" -c)
	local mode=$(iwconfig "$interface" 2>/dev/null | tr " " "\n" | grep "Mode:" | cut -d ":" -f 2)
	if [ $isOff -eq 0 ]; then
		echo -n "UP "
	else
		echo -n "DOWN "
	fi
	echo "$mode"
	return 0
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

function setInterfaceDown () { #( interface )
	if [ $# -ne 1 ]; then
        	$VERBOSE && echo "ERROR: ${NC}invalid args: [$*]"
		return 1
	fi
	# empty argument
        if [ -z "$1" ]; then
                $VERBOSE && echo -e "ERROR: ${NC}empty interface!"
                return 2
        fi
	local interface=$1
	ip link set dev $interface down
	local ret=$?
	if [ $ret ]; then
		$VERBOSE && echo -e "Interface: $interface down"
	else
		$VERBOSE && echo -e "ERROR: ${NC}unable to switch interface: $interface down!"
	fi
	return $ret
}

function setInterfaceUp () { #( interface )
        if [ $# -ne 1 ]; then
		echo "ERROR: ${NC}invalid args: [$*]" 1>&2
                return 1
        fi
	# empty argument
        if [ -z "$1" ]; then
                echo -e "ERROR: ${NC}empty interface!" 1>&2
                return 2
        fi
        local interface=$1
        ip link set dev $interface up
	local ret=$?
	if [ $ret ]; then
		$VERBOSE && echo -e "Interface: $interface up"
	else
		$VERBOSE && echo -e "ERROR: ${NC}unable to switch interface: $interface up!"
	fi
	return $ret
}

function setInterfaceMode () { #( interface mode )
	if [ $# -ne 2 ]; then
		echo "ERROR: ${NC}invalid args: [$*]" 1>&2
		return 1
	fi
	# empty argument
        if [ -z "$1" ]; then
                echo -e "${RED}ERROR: ${NC}empty interface!" 1>&2
                return 2
        fi
	local interface=$1
	local mode=$2
	if [ $(echo "$modes" | grep "$mode" -c) -ne 1 ]; then
		echo -e "${RED}ERROR: ${NC}invalid mode: $mode${NC}! ${NC}" 1>&2
		return 3
	fi
	setInterfaceDown $interface	# turn NIC off
	iwconfig $interface mode $mode	# change mode
	local ret=$?
	if [ $ret ]; then
                $VERBOSE && echo -e "Interface: $interface${NC} mode: $mode${NC}"
        else
                $VERBOSE && echo -e "ERROR: ${NC}unable to switch mode to: $mode${NC}!"
        fi
	setInterfaceUp $interface	# turn NIC on
	
	case $mode in 
		monitor) service NetworkManager stop;;
		managed) service NetworkManager start;;
	esac
	return $ret
}

# will return info for pc, not selected interface!
function testInterface () {  #( interface )
	# "Supported interface modes:"
	# iw list | sed $'s/\t/ /g' | grep "*\|:"
	echo "$(iw list | sed $'s/\t/ /g' | grep "*\|:" | tr "\n" "_" | tr -s " " | tr ":" "\n" | grep "Supported interface modes" -A1 | tail -n 1 | tr "_" "\n" | grep "*")"
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
	echo "Error: ${NC}failed to execute sudo" >&2
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
		-m | --mode)	shift; setInterfaceMode "$interface" $1 || exit 6;;
		-t | --test)	testInterface "$interface" || exit 7;;
		-s | --status)	isInterfaceOn "$interface" || exit 8;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done


$VERBOSE && echo "Done"
exit 0 
# END
