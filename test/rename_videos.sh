#!/bin/bash
# By Pytel
# Prejmenuje videa stazena z youtube

DEBUG=true
#DEBUG=false

patern="y2mate.com"
delimiter="-"
eval folder="~/Stažené"

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t print this text"
	echo -e "  -d, --debug\t enable debug output"
	echo -e "  -f, --folder\t set folder with videos"
	echo -e "  -s, --no-spaces\t remove spaces from name"
}

# parse input
$DEBUG && echo "Args: [$@]"
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug) 	DEBUG="true";;
		-n | --network) shift; setNetwork $1 || exit 3;;
		-m | --mask) 	shift; setMask $1 || exit 4;;
		-c | --cycle)	shift; cycle=$1;;
		-s | --sleep)	shift; SLEEP_TIME=$1;;
		-T | --time)	shift; setThreadGap $1 || exit 6;;
		-f | --file)	shift; setFileName $1 || exit 5;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done


echo -e "\nDone"
exit 0
#END
