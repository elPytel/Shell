#!/bin/bash
# By Pytel
# Replace spaces by "_" in file names.

#DEBUG=true
DEBUG=false
VERBOSE=false

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t\t print this text"
	echo -e "  -d, --debug\t\t enable debug output"
	echo -e "  -v, --verbose\t\t increase verbosity"
	echo -e "  -f, --folder\t\t set folder, else pwd"
	echo -e "  -e, --extensions\t set specific extensions (* - for all)"
	echo -e "			 eg: -e pdf,jpg,exe..."
}

function setFolder () { # ( folder )
	# empty argument
	if [ -z "$1" ]; then
		echo -e "${Red}ERROR: ${NC}empty argument!" 1>&2
		return 1
	fi

	eval folder="$1"

	# do folder exist?
	if [ ! -d $folder ]; then
		$VERBOSE && echo "${Red}ERROR: ${NC}$folder do not exist!" 1>&2
		return 2
	fi
	return 0
}

function setExtensions () { # ( extensions )
        # empty argument
        if [ -z "$1" ]; then
                echo -e "${Red}ERROR: ${NC}empty argument!" 1>&2
                return 1
        fi

	eval extensions=$(echo $1 | tr "," " ")

        return 0
}

function rename () { # ( file )
	# new name
	local fileName=$1
	local newName=$(echo "$fileName" | tr " " "_")
	# rename
	mv "$fileName" "$folder/$newName"
	$VERBOSE && echo "File $fileName renamed to: $newName"
}

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
# colors
source "$BASEDIR"/colors.sh

folder="$(pwd)"
extensions="*"

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
		-f | --folder)	shift; setFolder "$1" || exit 3;;
		-e | --extensions) shift; setExtensions "$1" || exit 4;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

# process
for file in "$folder"/*; do
	fileName=$(basename -- "$file")
	extension="${fileName##*.}"
	if $DEBUG; then
		echo -n "File: $fileName, "
		echo "Etension: $extension"
	fi
	
	if [ $(echo $fileName | grep " " -c) -eq 0 ]; then
		$DEBUG && echo "continue, no spaces..."
		continue
	elif [ "$extensions" = "*" ]; then
		rename "$fileName"
	elif [ $(echo "$extensions" | tr " " "\n"  | grep "$extension" -c) -ge 1  ]; then
		rename "$fileName"
	fi
done

$VERBOSE && echo -e "Done"
exit 0
#END
