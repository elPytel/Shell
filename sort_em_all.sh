#!/bin/bash
# By Pytel
# Algoritmus pro trideni soubru podle klice do adresaru.
# Jeho zaznam by mel mit cron pro spravnou funkci.

#DEBUG=true
DEBUG=false
VERBOSE=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo $-2 | tr "/" "\n" | tail -n 1) COMMAND"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t print this text"
	echo -e "  -d, --debug\t enable debug output"
	echo -e "  -v, --verbose\t increase verbosity"
}

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
#source "$BASEDIR"/tools/colors.sh

config=".sort.conf"
#cat $config

records=$(grep -v "#" $path/$config | grep ":")

# parse input
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-v | --verbose) VERBOSE=true;;
		-d | --debug) DEBUG=true;;
		*) echo -e "Unknown parametr: $arg" 1>&2; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

for record in "$records"; do
	eval fromFolder=$(echo $record | cut -d":" -f1)
	eval toFolder=$(echo $record | cut -d":" -f2)
	matchExtensions=$(echo $record | cut -d":" -f3 | tr "," " ")
	if $DEBUG; then
		echo "Record: $record"
		echo "From folder: $fromFolder"
		echo "To folder: $toFolder"
		echo "Extensions: $matchExtensions"
	fi

	# do folders exist?
	if [ ! -d $fromFolder ]; then
		$VERBOSE && echo "ERROR: $fromFolder do not exist!" 1>&2
		exit 1
	fi
	if [ ! -d $toFolder ]; then
		$VERBOSE && echo "ERROR: $toFolder do not exist!" 1>&2
		exit 1
	fi

	# vyresi soubory s mezery
	#for file in $fromFolder/*; do
	#	if [ echo $file | grep " " ]; then
	#		echo $file
	#		mv "$file" `echo "$file" | tr " " "_"`
	#	done
	#done

	for file in $fromFolder/*; do
		fileName=$(basename -- "$file")
		extension="${fileName##*.}"
		if $DEBUG; then
			echo -n "File: $fileName, "
			echo "Etension: $extension"
			echo "$(echo "$matchExtensions" | tr " " "\n" | grep "$extension" -c)"
		fi
		
		if [ $(echo "$matchExtensions" | tr " " "\n"  | grep "$extension" -c) -ge 1 ]; then
			mv "$file" "$toFolder"
			$VERBOSE && echo "File: $fileName, from: $fromFolder, moved to: $toFolder"
		fi
	done

done

exit 0
# END
