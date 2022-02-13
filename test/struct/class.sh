# By Pytel

DEBUG=true
#DEBUG=false

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
	declare -n object=$1
	declare -n class=$2

	for atribut in "${!class[@]}"; do 
		object["$atribut"]="${class[$atribut]}"; 
	done
}

declare -A classA

classA=( ["text"]="Ahoj!" ["print"]="echo " )
string=$(get classA text)

rfn classA print $string
rfn classA print $string " všichni!"

rof classA.print\("Hola"\)
rof classA.print\( $string \)

echo ${!classA[@]}
declare -A instance
new instance classA
echo ${!instance[@]}

# END
