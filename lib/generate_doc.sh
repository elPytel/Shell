#!/bin/bash
# By Pytel

# Description:
# Script for generating documentation out of bash scripts.

# colors
source ../tools/colors.sh > /dev/null
source IO_prints.shlib

# Help print
function printHelp () {
    echo -e "USE:"
    echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) -f FILE"
    echo ""
    echo -e "FILE:"
    echo -e "  path to the file"
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t\t print this text"
	echo -e "  -d, --debug\t\t enable debug output"
	echo -e "  -v, --verbose\t\t increase verbosity"
    echo -e "  -f, --file FILE\t set file"
}


# find all functions in a file
function find_functions () { # ( file )
    local file=$1
    # check if argument is set
    if [ -z $file ]; then
        printErrorAndExit "No file specified."
    fi
    # check if file exists
    if [ ! -f $file ]; then
        printErrorAndExit "File ${Blue}$file${NC} does not exist."
    fi
    local functions=$(cat $file | grep "^function " | cut -d " " -f 2)
    echo $functions
}

# find arguments of a function
function find_arguments () { # ( file function ) -> arguments
    local file=$1
    local function=$2
    local function_header=$(cat $file | grep "function $function")
    local comment=$(echo $function_header | cut -d "#" -f 2)
    local arguments=$(echo $comment | cut -d "(" -f 2 | cut -d ")" -f 1)
    echo $arguments
}

# find return of a function
function find_return () { # ( file function ) -> return
    local file=$1
    local function=$2
    local function_header=$(cat $file | grep "function $function")
    local comment=$(echo $function_header | cut -d "#" -f 2)
    local return=""
    # test is ">" in comment
    if [ $(echo $comment | grep ">" | wc -l) -eq 0 ]; then
        return=""
    else
        return=$(echo $comment | cut -d ">" -f 2-)
    fi
    echo $return
}

# print function lines
function print_function_lines () { # ( file function ) -> code
    local file=$1
    local function=$2
    local len=$(cat $file | wc -l)
    local start=$(cat -n $file | grep "function $function" | tr "\t" " " | tr -s " " | cut -d " " -f 2)
    local func_len=$(sed -n ${start},${len}p $file | grep -n "^}" | head -n 1 | cut -d ":" -f 1)
    local index_of_last_line=$(( $start + $func_len ))
    local end=$(( $index_of_last_line - 1 ))
    if $DEBUG; then
        echo -e "start: $start"
        echo -e "func_len: $func_len"
        echo -e "index_of_last_line: $index_of_last_line"
        echo -e "end: $end"
    fi
    code=$(sed -n ${start},${end}p $file)
    echo -e "$code"
}

# print description
function print_description () { # ( file ) -> description
    local file=$1
    local line=""
    local line_with_description=$(cat $file | grep -n "^#" | grep "Description:" | head -n 1 | cut -d ":" -f 1)
    if [ ! -z $line_with_description ]; then
        echo -e "## Description: "
        while true; do
            line_with_description=$(( $line_with_description + 1 ))
            line=$(sed -n ${line_with_description}p $file) # get line
            if [[ $line == \#* ]]; then # if line starts with #
                echo -e "${line:1}"     # print line without #
            else
                break
            fi
        done
        echo ""
    fi
}

# print function description
function print_function_description () { # ( file function ) -> description
    local file=$1
    local function=$2
    local line=""
    local line_with_declaration=$(cat $file | grep -n "function $function" | head -n 1 | cut -d ":" -f 1)
    local line_with_description=$line_with_declaration
    
    while true; do
        line_with_description=$(( $line_with_description - 1 ))
        line=$(sed -n ${line_with_description}p $file)
        if [[ $line != \#* ]]; then
            break
        fi
    done
    start=$(( $line_with_description + 1 ))
    end=$(( $line_with_declaration - 1 ))
    if $DEBUG; then
        echo -e "line_with_description: $start"
        echo -e "line_with_declaration: $end"
    fi
    comment=$(sed -n ${start},${end}p $file)
    comment=$(echo -e "$comment" | sed 's/^# //')
    echo -e "$comment"
}

# print help
function print_help () { # ( file ) -> help
    local file=$1
    local text=""
    local functions=$(find_functions $file)
    local help_exists=$(echo $functions | tr " " "\n" | grep $HELP_FUNCTION | wc -l)
    if [[ $help_exists -eq 1 ]]; then
        text=$(./$file -h)
        echo -e "## Help: "
        echo '```bash'
        echo -e "$text"
        echo '```'
    fi
    echo ""
}

# print the function documentation:
# - Description,
# - Arguments,
# - Return.
function print_function_doc () { # ( file function ) -> doc
    local file=$1
    local function=$2
    echo -e "### $function()"
    echo -e "\n> [!info] \n> Description:"
    local description=$(print_function_description $file $function)
    echo -e "$description" | sed 's/^/> /'
    echo -e "\nArguments: "
    local arguments=$(find_arguments $file $function)
    if [ -z "${arguments}" ]; then
        echo -e " - No arguments."
    else
        for argument in $arguments; do
            echo -e " - \`${argument}\`"
        done
    fi
    echo -e "\nReturn: "
    local return=$(find_return $file $function)
    if [ -z "${return}" ]; then
        echo -e " - No return."
    else
        echo -e " - \`${return}\`"
    fi
    echo ""
}

# set file
function setFile () { # ( file ) -> bool
    file=$1
    if [ ! -f $file ]; then
        printErrorAndExit "File ${Blue}$file${NC} does not exist." 1
    fi
    return 0
}

# main
file="generate_doc.sh"
HELP_FUNCTION="printHelp"
#DEBUG=true
DEBUG=false

# input args
case $# in
    0) printHelp; exit 2;;
    *) arg=$1;;
esac

# parse input
while [ $# -gt 0 ] ; do
    $DEBUG && echo "Arg: $arg remain: $#"

    # vyhodnoceni
    case $arg in
        -h | --help)    printHelp; exit 2;;
        -d | --debug)   DEBUG=true;;
        -v | --verbose) VERBOSE=true;;
        -f | --file)    shift; setFile "$1" || exit 3;;
        *) echo -e "Unknown parametr: $arg"; exit 1;;
    esac

    # next arg
    shift
    arg=$1
done

# file name
echo -e "# File: $file"
echo ""

# get description
print_description $file

# if printHelp exists
print_help $file

echo -e "## Functions: "
echo ""

functions=$(find_functions $file)
for function in $functions; do
    print_function_doc $file $function
done

exit 0