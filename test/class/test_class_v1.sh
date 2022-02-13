#!/bin/bash
# By Pytel

source class_v1.sh

DEBUG=true
#DEBUG=false

declare -A classA

myClass=( ["text"]="Ahoj!" ["print"]="echo " )
string=$(get classA text)

rfn myClass print $string
rfn myClass print $string " všichni!"

rof myClass.print\("Hola"\)
rof myClass.print\( $string \)

echo ${!classA[@]}
declare -A instance
new instance classA
echo ${!instance[@]}

# END

