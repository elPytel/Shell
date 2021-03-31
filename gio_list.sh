#!/bin/bash
# By Pytel
# Skript pro praci s gio na pripojovani sitovych disku

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/installers/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/colors.sh

#gio list -a "standard::display-name"
#gio list -a "standard::display-name" | cut -f3,4 | tr -s ":" | tr -s [:space:] | tr "\t" ":"
#exit

text=$(gio list -a "standard::display-name" | cut -f1,3,4 | tr -s ":" | tr -s [:space:] | tr "\t" ":" | tr " " "_")
for line in $text; do
	$DEBUG && echo $line
	printf "%.5s " "$(echo $line | cut -d":" -f1)"
	format=$(echo $line | cut -d":" -f2)
	file_name=$(echo $line | cut -d":" -f4 | cut -d"=" -f2)
	case $format in
		"(regular)") echo "$file_name";;
		"(directory)") echo -e "${Blue}$file_name${NC}";;
		*) echo "$file_name";;
	esac
done

exit 0
#END
