#!/bin/bash
# By Pytel

source ./class_v2.sh

DEBUG=true
#DEBUG=false

declare -A myClass 

myClass=( ["text"]="Ahoj!" ["print"]="echo " )
string=$(get myClass.text)

echo ${!myClass[@]}
declare -A instance
declare -A instance2
declare -A instance3

new instance = myClass
copy instance2 instance
extend instance3 myClass
sat instance3.hi = "Halo?!"
echo ${!instance[@]}

echo -e "\nSet:"
echo $(get instance3.hi)

echo -e "\nAtribut:"
echo $(get instance.text)
echo $(get instance2.print)
echo $(get instance3.hi)

echo -e "\nFunction:"
rfn instance print $string
rfn instance2 print $string " všichni!"

rof instance.print\("Hola"\)
rof instance3.print\( $(get instance3.hi) \)
rof instance2.print\( $string \)

echo -e "\nDelete:"
delete instance
echo $(get instance.text)

# END
