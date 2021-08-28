#!/bin/bash
# By Pytel
# Skript pro nastavení jiného scritu jako spustitelneho.

#DEBUG=true
DEBUG=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) <path/file_name>"
}

# colors
source colors.sh

# zadal validni argumenty?
case $# in
	0) printHelp; exit 2;;
	1) file=$1;;
	*) echo -e "${Red}Invalid options: $@${NC}"; exit 1;;
esac

# existuje soubor?
if [ ! -f $file ]; then
	echo -e "${Red}ERROR: ${NC}File: ${Blue}$file ${NC}does not exit!${NC}";
	exit 3
fi

# nastavi soubor jako spusitelny
chmod 755 $file 

if [ $? -eq 0 ]; then
	echo Done
	exit 0
else
	echo -e "${Red}FAIL ${NC}"
	exit 4
fi

# END
