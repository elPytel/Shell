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

# get atribut
function get () { # ( instance atribut )
    eval "echo \${$1[$2]}"
}

# run function
function rfn () { # ( instance func atributs )
	#echo $(eval $(get $1 $2) $3)
	local object=$1; shift
	local fun=$1; shift
	local args=$@
	echo $(eval $(get $object $fun) $args)
}

# run object function
function rof () { # ( instance.func(atributs, ...) )
    local args=$@
	local object=$(echo $args | cut -d "." -f1)
	local fun=$(echo $args | cut -d "." -f2 | cut -d "(" -f1)
	local arg=$(echo $args | cut -d "." -f2 | cut -d "(" -f2 | tr -d ")" | tr -d ",")
    echo $(eval $(get $object $fun) $arg)
}


# generic contructor
function new () { # ( class )
	echo "Not implemented"
}	

classA=( ["text"]="Ahoj!" ["print"]="echo " )
string=$(get classA text)

rfn classA print $string
rfn classA print $string " všichni!"

rof classA.print\("Hola"\)
rof classA.print\( $string \)

