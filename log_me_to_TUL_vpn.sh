#!/bin/bash
# By Pytel
# Skript pro zalogovani do TUL vpn

#DEBUG="true"
DEBUG="false"

PROFILE="TUL"
HOST="vpn.tul.cz"
USERNAME="jaroslav.korner@tul.cz"

vpn_tool="/opt/cisco/anyconnect/bin/vpn"
BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/tools/colors.sh

# top -bn 1 | grep vpnagentd

# zadal validni argumenty?
if [ $# -eq 0 ]
then
	echo -e "${Green}Valid arguments: ${NC} connect | disconnect | state"
	exit 2
elif [ $# -eq 1 ]
then
	arg=$1
else
	echo -e "${Red}Invalid options: $@${NC}"
	exit 1
fi

# mam nainstalovany vpn klient?
if [ ! -e $vpn_tool ]
then
	echo -e "${Red}ERROR: cisco anyconnect not found!${NC}"
	exit 1
fi

case $arg in
	"connect")
		# pripoji se pres vpn 
		echo -e "${Green}Connecting to: ${Blue}$HOST${NC}"
	 	echo -e "${Green}As user: ${Blue}$USERNAME${NC}"
		echo -en "${Green}Type your password: ${NC}"	
		read -s PASSWORD
		#line="$USERNAME\n$PASSWORD\ny"
		line=$PROFILE'\n\n'$PASSWORD
		printf "$line" | $vpn_tool -s connect $HOST
	;;
	"disconnect")
		# odpoji se od vpn
		$vpn_tool disconnect | grep "state" | uniq
	;;
	"state")
		# zjisti stav pripojeni
		$vpn_tool -s state | grep "state" | uniq | tr -d ">"
	;;
	*)
                # Default condition
                echo -e "${Red}Unknown parametr: $arg${NC}"
                exit 2
        ;;
esac


exit
#END
