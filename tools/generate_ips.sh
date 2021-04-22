#!/bin/bash
# By Pytel
# script pro generovani ip adres
# echo 192.168.{0..255}.{0..255}

#DEBUG=true
DEBUG=false

if [ $# -ne 2 ]; then
    return 1
fi

network=$1
mask=$2

if [ $(echo $network | grep -o . | grep '\.' -c) -ne 3 ]; then
    return 2
fi
if [ $(echo $mask | grep -o . | grep '\.' -c) -ne 3 ]; then
	return 3
fi

ips=""
for i in {1..4}; do
	# vyber pozit
	net_part=$(echo $network | cut -d"." -f$i)
	mask_part=$(echo $mask | cut -d"." -f$i)
	
	# vyhodnoceni
	range=$(( 255 - $mask_part ))
	if [ $i -eq 4 ]; then
		range=$(( $range - 1 ))		# vyradi broad cast
		if [ $net_part -eq 0 ]; then
			net_part=$(( $net_part + 1 ))	# vyradi cislo site
			range=$(( $range - 1 ))
		fi
	fi
	ips+="{$net_part..$(( $net_part + $range ))}"
	
	# odelovaci tecka
	if [ $i -lt 4 ]; then
		ips+="."
	fi

	if $DEBUG ; then
		echo -e "$net_part\t $mask_part"
		echo "len: $max"
	fi
done

#echo $ips
eval echo $ips

exit 0
#END
