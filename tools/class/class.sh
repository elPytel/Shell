#!/bin/bash
# By Pytel

indir_keys() {
    eval "echo \${!$1[@]}"
}

indir_val() {
    eval "echo \${$1[$2]}"
}

# get atribut
function get () { # ( instance.atribut )
	declare -n object=$(echo $1 | cut -d "." -f 1)
    local atribut=$(echo $1 | cut -d "." -f 2)
	echo -e "${object["$atribut"]}"
}

# set atribut
function sat () { # ( instance.atribut = "value" )
	local args=$(echo $@ | tr -d " ")
	declare -n object=$(echo $args | cut -d "." -f 1) 
	local atribut=$(echo $args | cut -d "." -f 2 | cut -d "=" -f 1)
	local arg=$(echo $args | cut -d "." -f 2 | cut -d "=" -f 2)
	object["$atribut"]="$arg"
}

# run function
function rfn () { # ( instance func atributs )
	local this=$1; shift
	local fun=$1; shift
    local code=$(get $this.$fun)
	eval $code
}

# run object function
function rof () { # ( instance.func atributs ... )
	local this=$(echo $1 | cut -d "." -f1)
	local fun=$(echo $1 | cut -d "." -f2 ); shift
	local code=$(get $this.$fun)
	#$DEBUG && echo -e "Code: \n$code"
	eval $code 
}

# copy class
function copy () { # ( object class )
	declare -n object=$1
	declare -n class=$2

	for atribut in "${!class[@]}"; do 
		object["$atribut"]="${class[$atribut]}"; 
	done
}

# exnteds class
function extend () { # ( object class )
	copy $@
}

# generic contructor
function new () { # ( object = class )
	local args=$(echo $@ | tr -d " " )
	local object=$(echo $args | cut -d "=" -f 1)
	local class=$(echo $args | cut -d "=" -f 2)
	declare -gA $object
	copy $object $class
}

function delete () { # ( object ) 
	unset $1
}

# END
