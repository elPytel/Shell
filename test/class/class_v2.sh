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
	echo ${object["$atribut"]}
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
	#echo $(eval $(get $1 $2) $3)
	local object=$1; shift
	local fun=$1; shift
	local args=$@
	echo $(eval $(get $object.$fun) $args)
}

# run object function
function rof () { # ( instance.func(atributs, ...) )
	local args=$@
	local object=$(echo $args | cut -d "." -f1)
	local fun=$(echo $args | cut -d "." -f2 | cut -d "(" -f1)
	local arg=$(echo $args | cut -d "." -f2 | cut -d "(" -f2 | tr -d ")" | tr -d ",")
	echo $(eval $(get $object.$fun) $arg)
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
	declare -n object=$(echo $args | cut -d "=" -f 1)
    declare -n class=$(echo $args | cut -d "=" -f 2)

    for atribut in "${!class[@]}"; do
        object["$atribut"]="${class[$atribut]}";
    done
}

function delete () { # ( object ) 
	unset $1
}

# END
