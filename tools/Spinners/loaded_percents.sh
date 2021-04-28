#!/bin/bash
# By Pytel
# Vykresli bar postupu nacitani podle predanych procent a pozadovane sirky.
# Bez zadani sirky zvoli sirku okna.
# Bez zadani procent selze: 1
# Vykresluje:
# [=====>  ]  72%

#DEBUG=true
DEBUG=false

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h --help \t print this text"
	echo -e "  -p --percent \t set loaded percetns"
	echo -e "  -l --length \t set length of output"
	echo -e "  -d --debug\t enable debug output"
}

function setPercent () { # ( percent )
	if [ $# -ne 1 ]; then
		return 1
	fi
	percent=$1
    return 0
}

function validPercent () {
	if [ "$percent" -gt 100 ]; then
		return 2;
	elif [ "$percent" -lt 0 ]; then
		return 3
	fi
	return 0
}

function setLength () { # ( length )
	if [ $# -ne 1 ]; then
		return 1
	fi
	if [ $1 -gt $(tput cols) ]; then
        return 2;
    elif [ $1 -lt 0 ]; then
        return 3
    fi
	terminal_width=$1
	bar_length=$(( $terminal_width - 9 ))
	return 0
}

terminal_width=$(tput cols)
bar_length=$(( $terminal_width - 9 ))
percent=-1
ret=""

$DEBUG && echo "Args: [$*]"

# parse input
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"
	
	# vyhodnoceni
	case $arg in
		-h | --help)     printHelp; exit 2;;
		-d | --debug)	 DEBUG=true;;
		-p | --percent)	 shift; setPercent "$1" || exit 3;;
		-l | --length)	 shift; setLength "$1" || exit 4;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

if $DEBUG; then
	echo "Percent: $percent"
	echo "Terminal width: $terminal_width"
	echo "Bar length -[]: $bar_length"
fi

validPercent || exit 3;

# construct bar
ret+="["
# TODO range
# "scale=2 ; $var1 / $var2" | bc
max=$(bc <<< "scale=0 ; $bar_length * $percent / 100")
$DEBUG && echo "Max: $max"
range=""
if [ $max -gt 0 ]; then
	range=$(eval echo "{0..$(($max-1))}")
fi
for i in $range; do
	ret+="="
done
ret+=">"
range=""
if [ $max -lt $bar_length ]; then
	range=$(eval echo "{$max..$bar_length}")
fi
for i in $range; do
    ret+=" "
done
ret+="]"

# add percents
ret+=$(printf "%4.4s%%" $percent) 

echo "$ret"
exit 0
#END
