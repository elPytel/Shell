#!/bin/bash
# By Pytel
# Skript pro zjisteni jaky uzivatel spustil dany skript

if [ "$(whoami)" == "root" ]
then
	if [ "$(pwd | tr "/" "\n" | wc -l)" -lt 3 ]
	then
		exit 1
	fi	
	
	if [ "$(pwd | cut -d"/" -f2)" == "home" ]
	then 
		user=$(pwd | cut -d"/" -f3)
	fi
else
	user=$(whoami)
fi
echo "$user"

exit 0
#END
