#!/bin/bash
# By Pytel

#DEBUG=true
DEBUG=false

function nextLetter () { #( letter )
	local letter=$1
	echo "$letter" | tr "0-9a-z" "1-9a-z_"
	return 0
}

input=$1
readarray -t array < <(echo "$input" | rev | grep -o .)
$DEBUG && echo -e "Loaded array: \n${array[*]}"

# inscrement last
$DEBUG && echo "last element: ${array[0]}"

array[0]=$(nextLetter ${array[0]})

$DEBUG && echo "last element incremented: ${array[0]}"

increment=false
for i in "${!array[@]}"; do
	$DEBUG && echo "Index: $i, char: ${array[$i]}, increment: $increment"
	if $increment ; then
		array[$i]=$(nextLetter ${array[$i]})
		increment=false
		$DEBUG && echo "Incremented"
	fi
	if [ ${array[$i]} == "_" ]; then
		array[$i]="0"
		increment=true
		$DEBUG && echo -e "Increment next"
	fi
done

if $increment ; then
	exit 3
else
	echo ${array[*]} | rev | tr -d " "
	exit 0
fi
# END
