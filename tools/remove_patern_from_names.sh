#!/bin/bash
# By Pytel
# Remove specified patern from file names.

#DEBUG=true
DEBUG=false
VERBOSE=false

function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo $-2 | tr "/" "\n" | tail -n 1) PATERN COMMAND"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t\t print this text"
	echo -e "  -d, --debug\t\t enable debug output"
	echo -e "  -v, --verbose\t\t increase verbosity"
	echo -e "  -f, --folder\t\t set folder, else pwd"
}

function setFolder () { # ( folder )
	# empty argument
	if [ -z "$1" ]; then
		echo -e "${RED}ERROR: ${NC}empty argument!" 1>&2
		return 1
	fi

	eval folder="$1"

	# do folder exist?
	if [ ! -d $folder ]; then
		$VERBOSE && echo "ERROR: $folder do not exist!" 1>&2
		return 2
	fi
	return 0
}

folder="$(pwd)"
patern=$1

# parse input
$DEBUG && echo "Args: [$@]"
shift
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug) 	DEBUG=true;;
		-v | --verbose) VERBOSE=true;;
		-f | --folder)	shift; setFolder "$1" || exit 3;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

# process
for file in $folder/*; do
	fileName=$(basename -- "$file")
	if [ $(echo $fileName | grep $patern -c) -eq 1 ]; then
		# new name
		newName=${fileName#"$patern"}

		# rename
		mv "$file" "$folder/$newName"
		$VERBOSE && echo "File $fileName renamed to: $newName"
	fi
done

$VERBOSE && echo -e "Done"
exit 0
#END
