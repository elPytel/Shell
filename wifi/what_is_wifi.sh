#!/bin/bash
# By Pytel
# Will return your wifi/s name. 

#DEBUG=true
DEBUG=false

#lshw -class network
#cat /proc/net/wireless

numberOfNICs=$(lshw -class network 2>/dev/null | grep "*" -c)
$DEBUG && echo "NICs: $numberOfNICs"

# is there any NIC?
if [ $numberOfNICs -eq 0 ]; then
	$DEBUG && echo "ERROR: no internet interface!"
	exit 2
fi

wifis=""
# serch through all NICs
for i in $(seq $numberOfNICs); do
	nic=$(lshw -class network 2>/dev/null | tr "\n" ";" | cut -d "*" -f $(($i+1)) | tr ";" "\n")
	$DEBUG && echo -e "Interface number $i: \n $nic"
	
	# is wireless?
	wifiMentions=$(echo "$nic" | grep -E "Wireless interface|wireless|802.11" -c)
	if [ $wifiMentions -gt 0 ]; then
		wifi=$(echo "$nic" | grep "logical name" | cut -d ":" -f 2 | tr -d " ")
		wifis+=" $wifi"
		$DEBUG && echo -e "WIFI: $wifi"		
	fi
done

# have I found any wifi interface?
if [ -z "$wifis" ]; then
	exit 1
else
	echo $wifis
	exit 0
fi
# END
