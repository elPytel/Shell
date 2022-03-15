#!/bin/bash
# By Pytel

source ./class.sh

DEBUG=true
#DEBUG=false

declare -A testClass

testClass=(
    ["text"]='Zkušební text.'
)


function test_get () {
	new instance = testClass
	if [ "$(get instance.text)" != 'Zkušební text.' ]; then
		echo "ERROR"
		return 1
	fi
	delete instance
    return 0
}

function test_sat () {
	strings=(
		"test mezer v textu"
		'Ahoj!'
		"Cus!"
	)
	new instance = testClass
	for string in "${strings[@]}"; do
		$DEBUG && echo "string: $string"
    	sat instance.string = "$string"
		$DEBUG && echo "get: $(get instance.string)"
		if [ "$string" != "$(get instance.string)" ]; then
			echo "$string"
			get instance.string
			return 1
		fi
	done
	delete instance
	return 0
}

function test_delete () {
    $DEBUG && echo -e "\nDelete:"
	
	new instance = testClass
    delete instance
	
	if [ -z ${instance+x} ]; then 
		$DEBUG && echo "var is unset"
	else 
		echo "ERROR: var is set!"
		return 1
	fi
	return 0
}

# END
