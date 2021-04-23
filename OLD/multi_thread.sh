#!/bin/bash
# By Pytel
# multi thread tester

#DEBUG=true
DEBUG=false

file="mt.out"
rm $file
MAX=10
sharedMemory="/dev/shm"
running_threads="running_threads"
eps="1.0e-6"

# init
var="$sharedMemory/$running_threads"
echo 0 > $var;

function showCursor () {
    tput cnorm
}

function hideCursor () {
    tput civis
}

function threads++ () {
	local var="$sharedMemory/$running_threads"
    while [ -f $var.mtx ]; do
		sleep $eps
	done
	touch $var.mtx
	echo $(($(<$var)+1)) > $var;
	rm $var.mtx
	$DEBUG && echo $(threads)
}

function threads-- () {
    local var="$sharedMemory/$running_threads"
    while [ -f $var.mtx ]; do
        sleep $eps
    done
    touch $var.mtx
	echo $(($(<$var)-1)) > $var;
	rm $var.mtx
	$DEBUG && echo $(threads)
}

function threads () {
    while [ -f $var.mtx ]; do
        sleep $eps
    done
	local var="$sharedMemory/$running_threads"
    echo $(<$var)
}

function worker () { # ( file_name id )
	threads++
	local l_f_name=$1
	local l_id=$2
	local l_random_sleep=$((RANDOM%10+1))
	sleep $l_random_sleep
	local rnumber=$((RANDOM%3))
	if [ $rnumber -eq 0 ]; then
		echo "$l_id PASSED" >> $l_f_name
	else
		echo "$l_id FAILED" >> $l_f_name
	fi
	$DEBUG && echo "Worker: $l_id Done"
	threads--
	exit 0
}


if $DEBUG; then
	echo $file
	echo $RANGE
fi

RANGE=$(eval echo {0..$MAX})
for i in $RANGE; do
	echo "Worker: $i started."
	echo "Number of running threads: $(threads)"
	worker $file $i &
	sleep 0.1
done

hideCursor
./spinner.sh &
spinnerPID=$!
last=-1
while [ $(threads) -ne 0 ]; do
    sleep 0.2
	if [ $(threads) -ne $last ]; then
		last=$(threads)
		echo -en "\r\e[0K  Number of running threads: $(threads)"
	fi
done

kill $spinnerPID
showCursor
echo -e "\nDone"
exit 0
#END
