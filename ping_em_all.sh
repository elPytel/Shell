#!/bin/bash
# By Pytel
# Skript pro zahlceni site pomoci pingu.

# ./ping_em_all.sh -n 192.168.1.0 -m 255.255.255.0 -d

#DEBUG=true
DEBUG=false

SLEEP_TIME=0.2
cycle=3
thread_gap=0.3
file="founded_ips.txt"
toFile=false
exec {FD}<>$file

function spinner () {
	spin='- \ | /'
	while true; do
		for char in $spin; do
			#printf "\r$char"
			echo -en "\r$char"
			sleep 0.2
		done
	done
}

function showCursor () {
    tput cnorm
}

function hideCursor () {
    tput civis
}

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
	echo -e "  -F --toFile\t send output to file."
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

function setThreadGap () { # ( threadGap )
	if [ $# -ne 1 ]; then
        return 1
    fi
	thread_gap=$1
	if [ thread_gap -eq 0 ]; then
		thread_gap=$(( $thread_gap + 0.001 ))
	fi
	exit 0
}

function pingIt () { # ( ip )
	local l_address=$1
	
	# ping'em
	ping $l_address -4 -c $cycle >> /dev/null; ec=$?
	if [ $ec -ne 0 ]; then 
		sleep $SLEEP_TIME
		ping $l_address -4 -c $cycle >> /dev/null; ec=$?
	fi

	# adresa byla kontaktovana uspesne
	if [ $ec -eq 0 ]; then
		if $toFile; then
			flock $FD		# kritická sekce
			echo $l_address >> $file
			flock -u $FD
		else
			echo $l_address
		fi
		return 0
	fi
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
		-d | --debug) 	DEBUG=true;;
		-n | --network) shift; setNetwork $1 || exit 3;;
		-m | --mask) 	shift; setMask $1 || exit 4;;
		-c | --cycle)	shift; cycle=$1;;
		-s | --sleep)	shift; SLEEP_TIME=$1;;
		-T | --time)	shift; setThreadGap $1 || exit 6;;
		-f | --file)	shift; setFileName $1 || exit 5;;
		-F | --toFile)	toFile=true;;
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
	echo "To file: $toFile"
	echo "File: $file"
fi

# execute
if $toFile; then
	hideCursor
	spinner &
	spinnerPID=$!
fi

for address in $(tools/generate_ips.sh $network $mask); do
	if $toFile; then
		echo -ne "\033[0K\r  pinging: $address"
	fi
	pingIt $address &
	sleep $thread_gap
done

sleep 10 

if $toFile; then
	kill $spinnerPID
	showCursor
	echo -e "\nDone"
fi

exit 0
#END
