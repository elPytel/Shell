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
	echo -e "OPTIONS:"
	echo -e "  -h, --help \t\t print this text"
	echo -e "  -d, --debug\t\t enable debug output"
	echo -e "  -v, --verbose\t\t increase verbosity"
	echo -e "  -f, --folder\t\t set folder with videos"
	echo -e "  -S, --no-spaces\t remove spaces from name"
}

function setFolder () { # ( folder ) 
	eval folder="$1"
}

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta ke scriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source "$BASEDIR"/tools/colors.sh

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
	$VERBOSE && echo -e "${Red}ERROR: ${Blue}$folder${NC} do not exist!"
	exit 1
fi

# proces
for file in $folder/*; do
	fileName=$(basename -- "$file")
	if [ $(echo $fileName | grep $patern -c) -eq 1 ]; then
		newName=${fileName#"$patern"}
		
		# remove spaces
		if $noSpaces; then
			newName=$(echo "$newName" | tr " " "_")
		fi

		# rename
		mv "$file" "$folder/$newName"
		$VERBOSE && echo -e "File ${Blue}$fileName${NC} renamed to: ${Blue}$newName${NC}"
	fi
done

$VERBOSE && echo -e "Done"
exit 0
#END
