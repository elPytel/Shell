#!/bin/bash
# By Pytel

DEBUG=true
#DEBUG=false

declare -A classA

indir_keys() {
    eval "echo \${!$1[@]}"
}

indir_val() {
    eval "echo \${$1[$2]}"
}

function get_OLD () { # ( instance atribut ) 
	object="$1"
	atribut="$2"
	$DEBUG && echo "object: $object"
	$DEBUG && echo "atribut: $atribut"
	$DEBUG && echo ${object}[$atribut]
	
	echo $(indir_val $object $atribut)
}

# get atribut
function get () { # ( instance atribut )
    eval "echo \${$1[$2]}"
}

# run funstion
function rfn () { # ( instance func atributs )
	echo $(eval $(get $1 $2) $3)
	#eval "echo $(get $1 $2) $3"
}

# generic contructor
function new () { # ( class )
	echo "Not implemented"
}	

classA=( ["text"]="Ahoj!" ["print"]="echo " )
string=$(get classA text)

echo -e "$string"
eval $(get "classA" "print") "Badumts!"
eval $(get classA print) $(get classA text)

echo -e $(rfn classA print $string)

