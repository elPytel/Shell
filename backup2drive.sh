#!/bin/bash
# By Pytel
# Script for baskuping data to external drives.

#DEBUG=true
DEBUG=false

VERBOSE=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) -V [vendroID] -P [productID] COMMANDs"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
	echo -e "  -V --vendor\t set vendor ID"
	echo -e "  -P --product\t set product ID"
	echo -e "  -t --time \t set spin up time"
}

function setVendor () { #( vendorID )
	# not one argument
	if [ $# -ne 1 ]; then
		echo -e "${Red}ERROR: ${NC}vendor not specified!" 1>&2
		return 1
	fi
	# empty argument
	if [ -z "$1" ]; then
		echo -e "${Red}ERROR: ${NC}empty argument!" 1>&2
		return 2
	fi
	VendorID="$1"
}

function setProduct () { #( productID )
	# not one argument
	if [ $# -ne 1 ]; then
	echo -e "${Red}ERROR: ${NC}product not specified!" 1>&2
		return 1
	fi
	# empty argument
	if [ -z "$1" ]; then
	echo -e "${Red}ERROR: ${NC}empty argument!" 1>&2
		return 2
	fi
	ProductID="$1"
}

function setTime () { #( time )
	# empty argument
	if [ -z "$1" ]; then
	echo -e "${Red}ERROR: ${NC}empty argument!" 1>&2
		return 2
	fi
	sleepTime="$1"
}

function checkDriveID () {
	if [ -z $VendorID ]; then return 1; fi
	if [ -z $ProductID ]; then return 2; fi
	return 0
}

# program

VendorID=""
ProductID=""
sleepTime=1
config=".backup2drive.conf"

BASEDIR=$(dirname "$0")
user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"
$DEBUG && echo "path: $BASEDIR"

# colors
source $path/tools/colors.sh

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
		-V | --vendor)	shift; setVendor "$1" || exit 3;;
		-P | --product)	shift; setProduct "$1" || exit 4;;
		-t | --time)	shift; setTime "$1" || exit 5;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

if $DEBUG; then
        echo "VendorID: $VendorID"
        echo "ProductID: $ProductID"
	echo "Sleep time: $sleepTime"
fi

if [ ! checkDriveID ]; then
        echo -e "${Red}ERROR: ${NC} invalid args!" 1>&2
        return 1
fi

# spin up time for drive
sleep $sleepTime
$VERBOSE && echo "$(date)"

cat "$path/$config" | grep -v "#" | grep "$VendorID:$ProductID" | while read -r line ; do
#for line in "$(cat "$path/$config" | grep -v "#" | grep "$VendorID:$ProductID")"; do
	sourceDir="$(echo "$line" | cut -d":" -f3)"
	destinationDir="$(echo "$line" | cut -d":" -f4)"
	options="$(echo "$line" | cut -d":" -f5)"

	if $DEBUG; then
		echo "Source: $sourceDir"
		echo "Destination: $destinationDir"
		echo "Option: $options"
	fi
	
	# test dirs
	valid=true
	if [ "$(echo -n "$sourceDir" | tail -c 1)" != "*" ]; then
		# dir
		if [ ! -d "${sourceDir}" ]; then
			echo -e "${Red}ERROR:${NC} invalid source dir!" 1>&2
			valid=false
			ret=2
		fi
	else
		# files
		if [ ! -d "$(dirname $sourceDir | uniq)/" ]; then
			echo -e "${Red}ERROR:${NC} invalid source files!" 1>&2
			valid=false
			ret=2
		fi
	fi
	if [ ! -d "$destinationDir" ]; then
		echo -e "${Red}ERROR:${NC} destination dir do not exist!" 1>&2
 		echo -e "\t${Green}try:${NC} mkdir -p $destinationDir" 1>&2
		valid=false
		ret=3
	fi

	# syncing
	if [ $valid == "true" ]; then
		if [ $(echo "$sourceDir" | grep " " -c) -eq 1 ]; then
			rsync $options "$sourceDir" "$destinationDir"
		else
			rsync $options $sourceDir "$destinationDir"
		fi
		#rsync $options "$sourceDir" "$destinationDir"
		ec=$?
	fi
	$DEBUG && echo "valid: $valid ret: $ec"
	if [[ $valid != "true" || $ec -ne 0 ]]; then
		echo -e "${Red}ERROR:${NC} unable to run sync!" 1>&2
		ret=1
	elif $VERBOSE; then
		echo -e "From: ${Blue}$sourceDir${NC} to: ${Blue}$destinationDir${NC} syncing done."
	fi
done

$VERBOSE && echo -e "Done, run time: ${Blue}$($path/tools/sec2time.sh $SECONDS)${NC}"
exit 0
# END
