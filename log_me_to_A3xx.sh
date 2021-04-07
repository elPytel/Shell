#!/bin/bash
# By Pytel
# skript pro ulehcene pripojovani na skolni pocitace TUL v siti LIANE

#DEBUG="true"
#DEBUG="false"

num_pc=24		# pocet pocitacu v dane ucebne
name="jaroslav.korner"	# jmeno uzivatele
room="a03"		# adresa ucebny
school=".nti.tul.cz"	# adresa skoly

user=$(. $BASEDIR/installers/get_curent_user.sh)
path="/home/$user/Shell"	# cesta k skriptum
BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# colors
source $BASEDIR/tools/colors.sh
#source ~/Shell/tools/colors.sh

echo -n "Which pc? [01 - $num_pc]: "
read number
len=$(echo -n "$number" | wc -c)	# pocet zadanych znaku

#echo $len
if [ "$len" -ne 2 ]			# je to spravna delka?
then
	echo "Is you Derp? Wtf you typed?!"
	exit 1
fi
if [ "$number" -gt "$num_pc" ]		# je mensi nez num_pc?
then
	echo "Is you Derp? I said 01-$num_pc!"
	exit 2
fi

# bezi vpn?
state=$(bash $path/log_me_to_TUL_vpn.sh --state | tr -s " " | cut -d " " -f3)
$DEBUG && echo $state
if [ $state == "Connected" ] 
then
	echo -e "${Green}VPN connected.${NC}"
elif [ $state == "Disconnected" ]
then	
	bash $path/log_me_to_TUL_vpn.sh --connect TUL
fi

# ssh do skoly
address="@$room$number$school"        # adresa ucebny
echo "ssh $name$address"
ssh $name$address

exit 0
#END
