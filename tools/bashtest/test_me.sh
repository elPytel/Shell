#!/bin/bash

inA=( 1 1 4 ) 
inB=( 1 2 2 )
out=( 2 3 42 )

function add () {
	echo $(( $1 + $2 ))
}

function test_true () {
	echo "Test true"
	return 0
}

function test_false () {
	echo "Test false"
	return 1
}

function test_add () {
	local len=${#out[@]}
	echo "len: $len"
	for i in $(seq 1 $len); do
		A=${inA[$i]}
		B=${inB[$i]}
		echo "A: $A"
		echo "B: $B"
		sum=$(add $A $B)
		if [ $sum -gt ${out[$i]} ]; then
			return 1
		elif [ $sum -lt ${out[$i]} ]; then
			return 2
		fi
	done
	return 0
}

#END
