#!/bin/bash
# By Pytel

spin='- \ | /'
while true; do
	for char in $spin; do
		 #printf "\r$char"
		 echo -en "\r$char"
		 sleep 0.2
	done
done

exit 0
