#!/bin/sh
# By Pytel
# Skript prevede vsechny mp4 soubory v aktualnim adresari na mp3

#DEBUG=true
DEBUG=false

VERBOSE=false


old_format="mp4"
new_format="mp3"

folder="$(pwd)"

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

for file in "$folder"/*; do
	fileName=$(basename -- "$file")
	extension="${fileName##*.}"
	fileName="${fileName%.*}"
	#fileName="${fileName##*/}"
	if $DEBUG; then
		echo -n "File: $fileName, "
		echo "Etension: $extension"
	fi

	if [ "$extension" != "$old_format" ]; then
		$DEBUG && echo "Wrong extension: $extension"
		continue
	fi

	old_file=${fileName}.${old_format}
	new_file=${fileName}.${new_format}
	echo "$old_file -> $new_file"
	ffmpeg -i $old_file $new_file
	rm "$old_file"
done

exit 0
# END
