#!/bin/bash
# By Pytel


for i in {1..100}; do
	echo -ne "\r$(./loaded_percents.sh -p $i)"
	sleep 1
done

exit 0
# END
