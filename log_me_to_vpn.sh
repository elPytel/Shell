#!/bin/bash
# By Pytel
# Skript pro zalogovani do TUL vpn

#DEBUG=true
DEBUG=false

function printHelp () {
	#echo -e "${Green}Valid arguments: ${NC} connect | disconnect | state"
	echo -e "USE:"
	echo -e "  $(echo $-2 | tr "/" "\n" | tail -n 1) COMMAND CONNECTION"
	echo ""
	echo -e "COMMANDS:"
	echo -e "  -c --connect \t\t to connect to selected vpn"
	echo -e "  -d --disconnect \t to disconnect from vpn"
	echo -e "  -s --state \t\t state of vpn connection"	
}

function setProfile () { #( arg profile )
	if [ $(echo "$PROFILES" | tr " " "\n" | grep "$2" | wc -l) -ne 1 ]; then
		return 1
	fi
	arg=$1
	PROFILES=$2
	return 0
}

function connect () {
	case $(echo "$PROFILES" | wc -w) in
		1) # profil je jiz zvolen
			# najiti intervalu
			start_line=$(cat -n "$path"/$config | tail -n $(($len-1)) | grep "#" | grep $PROFILES | cut -f1 | tr -d " ")
			stop_line=$(cat -n "$path"/$config | tail -n $(($len-$start_line)) | grep "#" | tr "\n" " " | cut -f1 | tr -d " ")

			if $DEBUG; then
				echo ":${PROFILES}:"
				echo $start_line
				echo $stop_line
			fi

			# parse
			profile=$PROFILES
			host=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "host" | cut -d"=" -f2)
			username=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "user" | cut -d"=" -f2)
			echo -e "${Green}Connecting to: ${Blue}$host${NC}"
			echo -e "${Green}As user: ${Blue}$username${NC}"

			if [ $(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "passwd" -c) -eq 1 ]; then
				password=$(sed -n "${start_line},${stop_line}p" "$path"/$config | grep "passwd" | cut -d"=" -f2)
			else
				echo -en "${Green}Type your password: ${NC}"
				read -s password
			fi
		;;
		*) # profil zatím není zvolen
			echo "Chose one number from: "
			number=1
			for PROFILE in $PROFILES; do
				echo "  $number) $PROFILE"
				number=$(( $number + 1 ))
			done
			read choice
			profile=$(echo "$PROFILES" | tr " " "\n" | sed -n ${choice})
			$DEBUG && echo "Profile: $profile"
			# rekurzivni spusteni
			bash "$0" -c "$profile"
		;;
	esac

	line=$profile'\n\n'$password
	#printf "%s" "$line" | $vpn_tool -s connect "$host"
	printf "$line" | $vpn_tool -s connect "$host"
}

vpn_tool="/opt/cisco/anyconnect/bin/vpn"
path=$(dirname "$0")         # adresa k tomuto skriptu
$DEBUG && echo "path: $path"

# colors
source "$path"/tools/colors.sh

config=".vpn.conf"
PROFILES=$(cat -n "$path"/$config | grep "vpns" | cut -d"=" -f2)
len=$(wc -l "$path"/$config | cut -d" " -f1)      # conf file len

# top -bn 1 | grep vpnagentd

# mam nainstalovany vpn klient?
if [ ! -e $vpn_tool ]
then
        echo -e "${Red}ERROR: cisco anyconnect not found!${NC}"
        exit 1
fi

# zadal validni argumenty?
case $# in
	0) printHelp; exit 2;;
	1) arg="$1";;
	2) setProfile "$1" "$2" || exit 3;;
	*) echo -e "${Red}Invalid options:${NC} $@"; exit 1;;
esac

$DEBUG && echo "vpns: $PROFILES"

case $arg in
	"-c" | "--connect")
		# pripoji se pres vpn 
		connect
	;;
	"-d" | "--disconnect")
		# odpoji se od vpn
		$vpn_tool disconnect | grep "state" | tail -n 1 | cut -d":" -f2
	;;
	"-s" | "--state")
		# zjisti stav pripojeni
		$vpn_tool -s state | grep "state" | uniq | cut -d":" -f2
	;;
	*) # Default condition
		echo -e "${Red}Unknown parametr:${NC} $arg"
		exit 2
        ;;
esac


exit
#END
