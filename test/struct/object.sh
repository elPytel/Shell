#!/bin/bash
# By Pytel

declare -A classA

classA=( ["text"]="Ahoj!" ["print"]="echo " )

echo ${!classA[@]}

echo ${classA["text"]}
echo ${classA["print"]}

eval ${classA["print"]} ${classA["text"]}

# END
