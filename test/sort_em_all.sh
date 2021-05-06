#!/bin/bash
# By Pytel
# Algoritmus pro trideni soubru podle klice do adresaru.
# Jeho zaznam by mel mit cron pro spravnou funkci.

#DEBUG=true
DEBUG=false
VERBOSE=false

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t print this text"
	echo -e "  -d, --debug\t enable debug output"
	echo -e "  -v, --verbose\t increase verbosity"
}

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
#user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
#source "$BASEDIR"/tools/colors.sh

config=".sort.conf"
#cat $config

records=$(grep -v "#" $config | grep ":")

# parse input
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-v | --verbose) VERBOSE=true;;
		-d | --debug) DEBUG=true;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

for record in "$records"; do
	eval fromFolder=$(echo $record | cut -d":" -f1)
	eval toFolder=$(echo $record | cut -d":" -f2)
	matchExtensions=$(echo $record | cut -d":" -f3)
	if $DEBUG; then
		echo "Record: $record"
		echo "From folder: $fromFolder"
		echo "To folder: $toFolder"
		echo "Extensions: $matchExtensions"
	fi

	# test folders if exist!!!
	if [ ! -d $fromFolder ]; then
		$VERBOSE && echo "ERROR: $fromFolder do not exist!"
		exit 1
	fi
	if [ ! -d $toFolder ]; then
        $VERBOSE && echo "ERROR: $toFolder do not exist!"
		exit 1
    fi

	# vyresit soubory s mezery
	for matchExtension in $matchExtensions; do
		ls $fromFolder | grep "**.$matchExtension" 
	done

	exit
	for file in $fromFolder/*; do
		filename=$(basename -- "$file")
		extension="${filename##*.}"
		if $DEBUG; then
			echo -n "File: $filename, "
			echo "Etension: $extension"
			echo "$(echo "$matchExtensions" | tr " " "\n" | grep "$extension" -c)"
		fi
		
		if [ $(echo "$matchExtensions" | tr " " "\n"  | grep "$extension" -c) -ge 1 ]; then
			#mv "$file" "$toFolder"
			$VERBOSE && echo "File: $file, from: $fromFolder, moved to: $toFolder"
		fi
	done

done

exit 0
# END
