#!/bin/bash
# By Pytel

source ./class.sh

DEBUG=true
#DEBUG=false

declare -A myClass 

myClass=( ["text"]="Ahoj!" ["print"]='echo $@' )
string=$(get myClass.text)

declare -A instance
declare -A instance2
declare -A instance3

new instance = myClass
copy instance2 instance
extend instance3 myClass
sat instance3.hi = "Halo?!"

echo -e "\nAtributs:"
indir_keys myClass
indir_keys instance
indir_keys instance3

echo -e "\nSet:"
echo $(get instance3.hi)

echo -e "\nGet:"
get instance.text
get instance2.print
get instance3.hi

echo -e "\nFunction:"
rfn instance print $string
rfn instance2 print $string " všichni!"

rof instance.print "Hola"
rof instance3.print $(get instance3.hi)
rof instance2.print $string " všichni!"
rof instance3.print "Tohle, je test."

echo -e "\nDelete:"
delete instance
get instance.text

# END
