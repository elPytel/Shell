#!/bin/bash
# By Pytel

DEBUG=true
running_threads=0

function thread++ () {
    running_threads=$(( $running_threads +1 ))
    $DEBUG && echo $running_threads
}

function thread-- () {
    running_threads=$(( $running_threads -1 ))
	$DEBUG && echo $running_threads
}

for i in {1..10}; do
	thread++
done

while [ $running_threads -ne 0 ]; do
	thread--
done

exit 0
#END
