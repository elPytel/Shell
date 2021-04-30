#!/bin/bash
# By Pytel


for i in {1..100}; do
	echo -ne "\r$(./loaded_percents.sh -p $i)"
	sleep 0.3 
done
echo -e "\nDone"
exit 0
# END
