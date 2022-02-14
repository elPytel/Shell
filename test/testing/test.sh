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

	echo -e "==== FAILURE ====\n"
	echo "$code" | sed 's/^/\t/' | sed "${faigled_line}s/^/>/" 
	
	echo -e "\nERROR in: $file on line: $(( $start + $faigled_line - 1 ))."
}

function test_function () { # ( file function )
	local file=$1
	local function=$2

	output=$(run_function $function)
	errno=$?
	
	$VERBOSE && echo -e "$output"

	if [ $errno -ne 0 ]; then
		print_function_and_error_line $file $function $errno
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
	local pass="."
	local fail="F"

	$DEBUG && echo -e "All func: $functions"
	for function in $functions; do
		$DEBUG && echo -e "Function: $function"
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


# prepinac verbose nastavi vsechny test funkce na vypisovani vsech vystupu, jinak vypisuje pouze chyby

# bez argumentu najde vsechny soubory zacinajici test_ a koncisi .sh v pracovnim adresari
# s argumetem spusti vybrany soubor

# iteruje pre vsechny vybrane soubory a postupne spousti
# najde v nich vsechny funkce oznacene function test_... () a prida je do seznamu funkci, ktere je potreba spustit

# kazdou funkci spusti a odchyti jeji nermolni a chybovy vystup

# chyby funkci se posilaji na chybovy vystup
# vse ostatni je na normalnim

# standardni format chybovych vystupu

# kdyz funkce chybuje, tak vypisuji do konzole jeji kod
# zvyrazneni radku, ktery navraci danou chybovou hodnotu

# spocita uspesnot souboru, pocet proslych testu vs chybujicich


#TODO assert alias

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

echo -e "=== test session starts ==="
echo -e "rootdir: $(pwd)"

for file in $files; do
	echo -e "File: $file"
	# do file exist?
	if [ ! -f $file ]; then
		$VERBOSE && echo "ERROR: $file do not exist!"
		continue
	fi
	test_file $file
done

echo -e "=== $passed passed, $faigled failed ==="

$VERBOSE && echo -e "Done"
exit 0
#END
