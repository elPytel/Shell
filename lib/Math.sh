#!/bin/bash
# By Pytel

function isInt () { #( number )
	local number=$1
	local re='^[+-]?[0-9]+$'
	if ! [[ $number =~ $re ]] ; then
		return 1
	fi
	return 0
}

function isFloat () { #( number )
	local number=$1
	local re='^[+-]?[0-9]+([.][0-9]+)?$'
	if ! [[ $number =~ $re ]] ; then
		return 1
	fi
	return 0
}

# END
