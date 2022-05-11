#!/bin/bash
# By Pytel
# framework for testing bash scripts
# testing files: test_...sh
# testing metodes: test_... ()

#DEBUG=true
DEBUG=false
VERBOSE=false

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t\t print this text"
	echo -e "  -d, --debug\t\t enable debug output"
	echo -e "  -v, --verbose\t\t increase verbosity"
}

function run_function () { # ( function ) 
	local function=$1
	eval $function
	return $?
}

function print_function_and_error_line () { # ( file function errno )
	# print function & error line
	local file=$1
	local function=$2
	local errno=$3

	indexes=$(cat -n $file | grep "function" | grep "()" | tr "\t" " " | tr -s " ")
	len=$(cat $file | wc -l)
	indexes="${indexes}\n ${len}"

	start_end=$(echo -e "$indexes" | grep -A 1 $function | cut -d " " -f 2 | tr "\n" " ")
	start=$(echo $start_end | cut -d " " -f 1)
	end=$(echo $start_end | cut -d " " -f 2)
	end=$(( $end - 1 ))

	code=$(sed -n ${start},${end}p $file)
	faigled_line=$(echo -e "$code" | grep -n "return $errno" | cut -d ":" -f1)

	echo -e "${Red}=== FAILURE ===${NC}\n"
	echo "$code" | sed 's/^/\t/' | sed "${faigled_line}s/^/>/" 
	
	echo -e "\n${Red}ERROR${NC} in: ${Blue}$file${NC} on line: $(( $start + $faigled_line - 1 ))."
}

function test_function () { # ( file function )
	local file=$1
	local function=$2
	local output

	output=$(run_function $function); errno=$?
	
	if [ $errno -ne 0 ]; then
		print_function_and_error_line $file $function $errno
	fi
	
	if $VERBOSE; then
		echo -e "\nFunction output:"
		echo -e "$output"
	fi

	if [ $errno -ne 0 ]; then
		return 1
	fi
	return 0
}

function find_test_functions () { # ( file )
    local file=$1
    local functions=$(cat $file | grep "function test_" | cut -d " " -f 2)
	echo $functions
}

function test_file () { # ( file )
	local file=$@
	local functions=$(find_test_functions $file)
	
	# load functions
	source $file

	local progres=""
	local pass="${Green}.${NC}"
	local fail="${Red}F${NC}"

	$DEBUG && echo -e "All func: $functions"
	for function in $functions; do
		$DEBUG && echo -e "\nFunction: ${Blue}$function${NC}"

		test_function $file $function
		ret=$?
		if [ $ret -eq 0 ]; then
			passed=$((passed+1))
			progres=$progres$pass
		else
			faigled=$((faigled+1))
			progres=$progres$fail
		fi
	done

	# return stats (passed faigled)
	echo -e "Progress: $progres"
	return 0
}

# kazdou funkci spusti a odchyti jeji nermolni a chybovy vystup

# chyby funkci se posilaji na chybovy vystup
# vse ostatni je na normalnim

# standardni format chybovych vystupu

# kdyz funkce chybuje, tak vypisuji do konzole jeji kod
# zvyrazneni radku, ktery navraci danou chybovou hodnotu

# colors
source ../colors.sh

passed=0
faigled=0
files=""

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
		*) files=$arg;;
	esac

	# next arg
	shift
	arg=$1
done

# are files set?
if [ -z $files ]; then
	files=$(ls $pwd | tr " " "\n" | grep ".sh" | grep "test_")
fi

number=$(echo $files | tr " " "\n" | wc -l)
echo -e "${Green}=== test session starts ===${NC}"
echo -e "rootdir: ${Blue}$(pwd)${NC}"
echo -e "collected: ${Blue}$number${NC} files"

exit_status=0

for file in $files; do
	echo -e "File: ${Blue}$file${NC}"
	# do file exist?
	if [ ! -f $file ]; then
		$VERBOSE && echo "ERROR: $file do not exist!"
		continue
	fi
	test_file $file
done

echo -e "=== ${Green}$passed passed${NC}, ${Red}$faigled failed${NC} ==="

if [ $faigled -gt 0 ]; then
	exit_status=1
fi
$VERBOSE && echo -e "Done"
exit $exit_status
#END
