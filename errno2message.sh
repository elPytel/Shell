#!/bin/bash
# By Pytel
# Error code to message

#DEBUG=true
DEBUG=false

VERBOSE=false

BASEDIR=$(dirname "$0")     # adresa k tomuto skriptu
user=$(. $BASEDIR/tools/get_curent_user.sh)
path="/home/$user"        	# cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

# Help print
function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) COMMANDs -E [number]"
	echo ""
	echo -e "COMMANDs:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
    echo -e "  -s --short \t only short output"
    echo -e "  -l --long \t long"
    echo -e "  -a --all \t all"
    echo -e "  -E --ERRNO \t [number] of ERROR"
}

FORMAT="LONG"

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
		-d | --debug)	DEBUG=true;;
		-v | --verbose)	VERBOSE=true;;
		-s | --short)	FORMAT="SHORT";;
		-l | --long)	FORMAT="LONG";;
		-a | --all)     FORMAT="ALL";;
		-E | --ERRNO)	shift; number="$1";;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

$DEBUG && echo -e "Format: ${Blue}$FORMAT${NC}"

line=$(grep -E "^($number)[[:space:]]" ERRNO)

case $FORMAT in
    SHORT)  echo $line | cut -d " " -f 2;;
    LONG)   echo $line | cut -d " " -f 3-;;
    ALL)    echo $line;;
esac

$VERBOSE && echo "Done"
# END