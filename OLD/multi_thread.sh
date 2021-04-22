#!/bin/bash
# By Pytel
# multi thread tester

file="mt.out"
MAX=50

function worker () { # ( file_name id )
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
	exit 0
}

if $DEBUG; then
	echo $file
	echo $RANGE
fi

rm $file

RANGE=$(eval echo {0..$MAX})
for i in $RANGE; do
	$DEBUG && echo "Worker: $i started."
	worker $file $i &
done

exit 0
#END
