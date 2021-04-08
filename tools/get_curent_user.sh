#!/bin/bash
# By Pytel
# Skript pro zjisteni jaky uzivatel spustil dany skript

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

if [ $(whoami) == "root" ]
then
	if [ $(pwd | tr "/" "\n" | wc -l) -lt 3 ]
	then
		exit 1
	fi	
	
	if [ $(pwd | cut -d"/" -f2) == "home" ]
	then 
		user=$(pwd | cut -d"/" -f3)
	fi
else
	user=$(whoami)
fi
echo $user

exit 0
#END
