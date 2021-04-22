#!/bin/bash
# By Pytel
# Skript pro zahlceni site pomoci pingu.

#DEBUG=true
DEBUG=false

SLEEP_TIME=2
cycle=3
thread_gap=0.2
file="founded_ips.txt"
running_threads=0

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
    echo -e "  -n --network\t setup network, expect: xxx.xxx.xxx.xxx"
    echo -e "  -m --mask\t setup mask, expect: xxx.xxx.xxx.xxx"
	echo -e "  -c --cycle\t setup number of ping cycles."
	echo -e "  -s --sleep\t setup sleep time in sec, expect: x.x"
	echo -e "  -T --time\t setup thread gap time."
	echo -e "  -f --file\t setup output file name."
}

function setNetwork () {	# ( network )
	if [ $# -ne 1 ]; then
		return 1
	fi
	network=$1
	return 0
}

function setMask () {		# ( mask )
	if [ $# -ne 1 ]; then
		return 1
	fi
	mask=$1
	# xxx.xxx.xxx.xxx
	if [ $(echo $mask | grep -o . | grep '\.' -c) -ne 3 ]; then
		return 2
	fi

	return 0
}

function setFileName () { # ( file_name )
	file=$1
	return 0
}

function thread++ () {
	running_threads=$(( $running_threads +1 ))
	$DEBUG && echo $running_threads
}

function thread-- () {
	running_threads=$(( $running_threads -1 ))
}

function pingIt () { # ( ip )
	thread++
	local l_address=$1
	
	# ping'em
	ping $l_address -4 -c $cycle >> /dev/null; ec=$?
	if [ $ec -ne 0 ]; then 
		sleep $SLEEP_TIME
		ping $l_address -4 -c $cycle >> /dev/null; ec=$?
	fi
	
	# adresa byla kontaktovana uspesne
	if [ $ec -eq 0 ]; then
		echo $l_address >> $file
		return 0
	fi
	thread--
	return 1
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
		-n | --network) shift; setNetwork $1 || exit 3;;
		-m | --mask) 	shift; setMask $1 || exit 4;;
		-c | --cycle)	shift; cycle=$1;;
		-s | --sleep)	shift; SLEEP_TIME=$1;;
		-T | --time)	shift; thread_gap=$1;;
		-f | --file)	shift; setFileName $1 || exit 5;;
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
	setNetwork $input || exit 3
fi
if [ -z $mask ]; then
	echo -n "Mask: "
	read input
	setMask $input || exit 4 
fi


# debug output
if $DEBUG ; then
	echo "Network: $network"
	echo "Mask: $mask"
	echo "Sleep time: $SLEEP_TIME"
	echo "Ping cycles: $cycle"
	echo "Thread gap: $thread_gap"
	echo "File: $file"
fi

# execute
for address in $(tools/generate_ips.sh $network $mask); do
	$DEBUG && echo "Adresa: $address"
	pingIt $address &
	sleep $thread_gap
	$DEBUG && echo "Number of running threads: $running_threads"
done

while [ $running_threads -ne 0 ]; do
	sleep 5
	#TODO spiner
done

exit 0
#END
