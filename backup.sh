#!/bin/bash
# By Pytel
# Skript pro praci zalohovani dat mezi disky pomoci rsync
# parametry programu rsync:
# -a 		archivuj (vse kopiruje identicky, -rlptgoD)
# -r 		rekurzivne (pro slozky)
# -n, --dry-run	beh na zkouska (testovani)
# -v verbose
# -z, --compress	komprimace pro komunikaci po siti
# -p, --perms	zachovej opravneni
# -P, --progress
# -h		humanreadeble
# -u, --update
# --delete	odstrani neexistujici soubory z ciloveho adresare

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptui
user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source "$BASEDIR"/tools/colors.sh

config=".backup.conf"
BACKUPS=$(cat -n "$path"/$config | grep "backups" | cut -d"=" -f2)
$DEBUG && echo "Backups: $BACKUPS"
len=$(wc -l "$path"/$config | cut -d" " -f1)      # conf file len
mount="/media/$user"		# pripojove body ulozist
ret=0

for BACKUP in $BACKUPS
do
	echo -e "${Green}Backup: ${Blue}$BACKUP${NC}"
	# najiti intervalu
	start_line=$(cat -n "$path"/$config | tail -n $(( $len - 1 )) | grep "# $BACKUP" | cut -f1 | tr -d " ")
	stop_line=$(cat -n "$path"/$config | tail -n $(( $len - $start_line )) | grep "#" | tr "\n" " " | cut -f1 | tr -d " ")

	# parse
	options=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "option" | cut -d"=" -f2)
	source_dir=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "source" | cut -d"=" -f2 | cut -f1)
	s_removable=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "source" | cut -d"=" -f2 | cut -f2)
	case $s_removable in
		"true") source_dir="$mount/$source_dir";;
		"false" | *) s_removable=false;;
	esac

	destination=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "destination" | cut -d"=" -f2 | cut -f1)
	d_removable=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "destination" | cut -d"=" -f2 | cut -f2)
	case $d_removable in
		"true")
			destination="$mount/$destination";;
		"false" | *) d_removable=false;;
	esac

	if $DEBUG; then
		echo "Config lines:"
		echo " > from:	$start_line"
		echo " > to:		$stop_line"
		echo "options:	$options"
		echo "source:		$source_dir"
		echo " > removable:	$s_removable"
		echo "destination:	$destination"
		echo " > removable:	$d_removable"
	fi

	# test validity adresaru
	valid=true
	if [ ! -d "$source_dir" ]; then
		echo -e "${Red}ERROR:${NC} in source dir!"
		valid=false
		ret=2	
	fi
	if [ ! -d "$destination" ]; then
		echo -e "${Red}ERROR:${NC} destination dir do not exist!"
 		echo -e "\t${Green}try:${NC} mkdir -p $destination"
		valid=false
		ret=3
	fi
	
	# syncing
	if [ $valid == "true" ]; then
		rsync $options $source_dir "$destination"
		ec=$?
	fi
	$DEBUG && echo "valid: $valid ret: $ec"
	if [[ $valid != "true" || $ec -ne 0 ]]; then
		echo -e "${Red}ERROR:${NC} unable to run sync!"
		ret=1
	else
		echo -e "${Blue}$BACKUP${NC} syncing done."
	fi
done

echo -e "Done, run time: ${Blue}$("$path"/tools/sec2time.sh $SECONDS)${NC}"
exit $ret
#END
