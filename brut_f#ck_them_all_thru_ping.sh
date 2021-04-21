#!/bin/bash
# By Pytel
# Skript pro zahlceni site pomoci pingu.

DEBUG="true"
#DEBUG="false"

SLEEP_TIME=0.2

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
    echo -e "  -n --network\t setup network, expect: xxx.xxx.xxx.xxx"
    echo -e "  -m --mask\t setup mask, expect: xxx.xxx.xxx.xxx"
}

function setNetwork () {
	if [ $# -ne 1 ]; then
		return 1
	fi
	network=$1
	return 0
}

function setMask () {
	if [ $# -ne 1 ]; then
		return 1
	fi
	mask=$1
	A=$(echo $mask | cut -d"." -f1)
	B=$(echo $mask | cut -d"." -f2)
	C=$(echo $mask | cut -d"." -f3)
	D=$(echo $mask | cut -d"." -f4)	
	return 0
}


$DEBUG && echo "Args: [$@]"

# parse input
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug) 	DEBUG="true";;
		-n | --network) shift; setNetwork $1;;
		-m | --mask) 	shift; setMask $1;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done


# kontext setup
if [ -z $network ]; then 
	echo -n "Network: "
	read input
	setNetwork $input
fi
if [ -z $mask ]; then
	echo -n "Mask: "
	read input
	setMask $input
fi

#range_start=$3
#range_stop=$4

# debug output
if [ $DEBUG ]; then
	echo "$network"
	echo "$mask"
	echo -e "$A\t$B\t$C\t$D"
fi

aRange=$(( 254 - $A ))
bRange=$(( 254 - $B ))
cRange=$(( 254 - $C ))
dRange=$(( 254 - $D ))
#echo $dRange
#echo "$(seq 1 1 $dRange)"


#TODO use counter!

exit 2

for a in $(seq 1 1 $aRange); do
	for b in $(seq 1 1 $bRange); do
		for c in $(seq 1 1 $cRange); do
			for d in $(seq 1 1 $dRange); do
				echo $a.$b.$c.$d
			done
		done
	done
done

exit 1


#subnet
#pc_index
ping $address -4 -c 5; ec=$?
if [ ! -z $ec ]; then 
	sleep $SLEEP_TIME
	ping $address -4 -c 5; ec=$?
fi

# adresa byla kontaktovana uspesne
if [ -z $ec ]; then
	echo $address 
fi

exit 0
#END
