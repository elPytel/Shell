#!/bin/bash
# By Pytel

source ./class_v3.sh

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
)

#TODO include fun, to load classes from diferent file in sane format

string=$(get myClass.text)

declare -A instance

new instance = myClass

echo -e "\nAtributs:"
indir_keys myClass

echo -e "\nGet:"
get instance.text
get instance.print
get instance.n_times_repeat

echo -e "\nFunction:"
rof instance.display
rof instance.print $string
rof instance.print "Hola"
rof instance.n_times_repeat 5 "tohle je argument"
rof instance.fun

echo -e "\nDelete:"
delete instance

# END
