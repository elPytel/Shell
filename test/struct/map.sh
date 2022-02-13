#!/bin/bash
# By Pytel
# animals['key']='value' to set value
# "${animals[@]}" to expand the values
# "${!animals[@]}" (notice the !) to expand the keys


declare -A house
house=( ["door"]=1 ["windows"]=3 )

echo "Struct:"
for atribut in "${!house[@]}"; do
	echo "$atribut - ${house[$atribut]}"
done

for key in ${!house[@]}; do echo $key; done
for value in ${house[@]}; do echo $value; done
echo struct/hasmap has ${#house[@]} elements

# END
