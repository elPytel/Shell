#!/bin/bash
# By Pytel
# remove spaces from file name

DEBUG=true
#DEBUG=false
VERBOSE=false
char="_"

function printHelp () {
    echo -e "COMMANDS:"
    echo -e "  -h, --help \t print this text"
    echo -e "  -d, --debug\t enable debug output"
    echo -e "  -v, --verbose\t increase verbosity"
}

function setFile () { #( "file_with_path" )
	filePath="$(dirname -- "$1")"
	fileName="$(basename -- "$1")"
	if $DEBUG; then
		echo $filePath
		echo $fileName
	fi
}

# parse input
arg=$1
while [ $# -gt 0 ] ; do
    $DEBUG && echo "Arg: $arg remain: $#"

    # vyhodnoceni
    case $arg in
        -h | --help)    printHelp; exit 2;;
        -v | --verbose) VERBOSE=true;;
        -d | --debug) DEBUG=true;;
        -c | --char) shift; char="1";;
		*) setFile "$arg";;
    esac

    # next arg
    shift
	arg=$1
done

exit 7

if [ $fileName == "" ]; then
	exit 1
fi

newFileName=$(echo $fileName | tr " " "_")

mv "$fileName" "$newFileName"
$VERBOSE && echo "Renaming: $fileName to $newFileName"

exit 0
#END
