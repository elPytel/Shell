#!/bin/bash
# By Pytel

source ./class.sh

DEBUG=true
#DEBUG=false

declare -A myClass 

myClass=( 
	["text"]='Ahoj!' 
	["print"]='echo $@'
	["display"]='echo $(get $this.text)'
	["n_times_repeat"]='
		range=$1; shift;
		echo "range: $range";
		for i in $(seq 1 $range); do
			echo "$i $@";
   		done
		'
	["fun"]='
		echo "hi"
		'
	["repeat"]='
		range=$(get $this.text | wc -c);
		for i in $(seq 1 $range); do
			echo -e "$(get $this.text)";
		done
		'
)


#TODO include fun, to load classes from diferent file in sane format

string=$(get myClass.text)

declare -A instance

new instance = myClass

echo -e "\nAtributs:"
indir_keys myClass

function test_get () {
	echo -e "\nGet:"
	if [ "$(get instance.text)" != "Ahoj!" ]; then
		echo "$(get instance.text)"
		return 1
	elif [ "$(get instance.print)" != "echo \$@" ]; then
		echo "$(get instance.print)"
		return 2
	fi
	return 0
}

get instance.n_times_repeat

echo -e "\nFunction:"
rof instance.display
rof instance.print $string
rof instance.print "Hola"
rof instance.n_times_repeat 5 "tohle je argument"
rof instance.repeat
rof instance.fun

function test_delete () {
	echo -e "\nDelete:"
	delete instance
}

# END
