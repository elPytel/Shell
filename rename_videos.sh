#!/bin/bash
# By Pytel
# Prejmenuje videa stazena z youtube

#DEBUG=true
DEBUG=false
VERBOSE=false

noSpaces=false
patern="y2mate.com - "
eval folder="~/Stažené"

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t\t print this text"
	echo -e "  -d, --debug\t\t enable debug output"
	echo -e "  -v, --verbose\t increase verbosity"
	echo -e "  -f, --folder\t\t set folder with videos"
	echo -e "  -S, --no-spaces\t remove spaces from name"
}

function setFolder () { # ( folder ) 
	eval folder="$1"
}

# parse input
$DEBUG && echo "Args: [$@]"
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug) 	DEBUG=true;;
		-v | --verbose) VERBOSE=true;;
		-f | --folder)	shift; setFolder "$1";;
		-S | --no-spaces)noSpaces=true;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

# do folder exist?
if [ ! -d $folder ]; then
	$VERBOSE && echo "ERROR: $folder do not exist!"
	exit 1
fi

for file in $folder/*; do
	fileName=$(basename -- "$file")
	if [ $(echo $fileName | grep $patern -c) -eq 1 ]; then
		newName=${fileName#"$patern"}
		if $noSpaces; then
			newName=$(echo "$newName" | tr " " "_")
		fi
		mv "$file" "$folder/$newName"
		$VERBOSE && echo "File $fileName renamed to: $newName"
	fi
done

$VERBOSE && echo -e "Done"
exit 0
#END
