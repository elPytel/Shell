#!/bin/bash
# By Pytel
# 

DEBUG=true
#DEBUG=false

#lshw -class network


numberOfNICs=$(lshw -class network 2>/dev/null | grep "*" -c)
$DEBUG && echo "NICs: $numberOfNICs"


for i in $(seq $numberOfNICs); do
	nic=$(lshw -class network 2>/dev/null | tr "\n" ";" | cut -d "*" -f $(($i+1)) | tr ";" "\n")
	$DEBUG && echo -e "Interface number $i: \n $nic"
done

# END
