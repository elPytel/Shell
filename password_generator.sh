#!/bin/bash
# By Pytel
# Script for generating random alfanumeric strings.

#DEBUG=true
DEBUG=false

VERBOSE=false

# -aA0.

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) COMMANDs"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
	echo -e "  -c --check\t check genrated passwords"
	echo -e "  -l --len\t set len of password: <>"
	echo -e "  -t --test \t test this password: <>"
	echo -e "  -n --number\t set number of repetition: <>"
	echo -e "  -m --mode\t set specific mod: <>"
	echo -e " \t * a small chars"
	echo -e " \t * A large chars"
	echo -e " \t * 0 numbers"
	echo -e " \t * . special chars"
}

function isInt () { #( number )
	local number=$1
	local re='^[0-9]+$'
	if ! [[ $number =~ $re ]] ; then
		return 1
	fi
	return 0
}


function setLen () { #( number )
	local number=$1
	isInt "$number"
	if [ ! $? ]; then
		echo "Error: ${NC}this: $number is not a number!" >&2
		return 2
	fi
	len=$number
	$DEBUG && echo "Len set: $len"
	return 0
}


function setNumber () { #( number )
	local number=$1
	isInt "$number"
	if [ ! $? ]; then
		echo "Error: ${NC}this: $number is not a number!" >&2
		return 2
	fi
	repetition=$number
	$DEBUG && echo "Len set: $repetition"
	return 0
}

function setMode () { #( mode )
	local string=$(echo i"$1" | grep -o . | sort | uniq)
	local special='!@#$%^&*()-_+?><~;'

	$DEBUG && echo "Mode to set: "

	mode=""
	for char in $string; do
		$DEBUG && echo "$char"
		case $char in 
			a) mode=$mode'a-z';;
			A) mode=$mode'A-Z';;
			0) mode=$mode'0-9';;
			.) mode=$mode$special;;
			*) $VERBOSE && echo "Unknown mode!";; 
		esac
	done
	return 0
}

# Returns number of occurences of password in database.
function pwnedCheck() { #( password )
	local pwd="$1"
	local hash
	hash=$(echo -n "$pwd" | sha1sum | cut -c -40)
	local expected=${hash#?????}
	local prefix=${hash%$expected}
	local match

	match="$(curl -s "https://api.pwnedpasswords.com/range/${prefix}" | grep -i "^$expected:")" || return 1 
	echo "${match#*:}" | tr -d '\r'
}

# Test password and print number of occurences.
function testPassword() { #( password )
	local password="$1"
	local occurences=$(pwnedCheck "$password")
	if $VERBOSE ; then
		if [[ -z "$occurences" ]]; then
			echo "The password '$password' has no occurences."
		else
			echo "The password '$password' has $occurences occurences."
		fi
	else
		echo "$password $occurences"
	fi
}

len=12
repetition=1
mode="a-zA-Z0-9"

$DEBUG && echo "Args: [$*]"

# input args
arg=$1

# parse input
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug)	DEBUG=true;;
		-v | --verbose)	VERBOSE=true;;
		-m | --mode)	shift; setMode "$1" || exit 3;;
		-l | --len)	shift; setLen "$1" || exit 4;;
		-n | --number)	shift; setNumber "$1" || exit 5;;
		-t | --test)	shift; testPassword "$1"; exit 0;;
		-c | --check)	PWNEDCHECK=true;
	esac

	# next arg
	shift
	arg=$1
done

if $DEBUG ; then 
	echo "Lenght: $len"
	echo "Number: $repetition"
	echo "Mode: $mode"
fi

# print password
if [ -z $mode ]; then
	echo "Error: ${NC}empty mode!" >&2
	exit 6
fi

if [ $PWNEDCHECK ]; then
	passwords=$(cat /dev/urandom | tr -dc $mode | fold -w $len | head -n $repetition)

	for password in $passwords; do
		testPassword "$password"
	done
else
	cat /dev/urandom | tr -dc $mode | fold -w $len | head -n $repetition
fi




$VERBOSE && echo "Done"
exit 0 
# END

#Creates 10 passwords (15 char length) containing at least one character from each group: lower , upper case, digit.
#LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom |fold -w 15|grep [[:upper:]]|grep [[:lower:]]|grep [[:digit:]]|head -n 10

