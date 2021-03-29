#!/bin/bash
# By Pytel
# Skript pro praci s gio na pripojovani sitovych disku

DEBUG=true
#DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptui
user=$(. $BASEDIR/installers/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/colors.sh

# zadal validni argumenty?
if [ $# -eq 0 ]
then
	echo -e "${Green}Valid arguments: ${NC} -m --mount | -u --unmount | -l --list"
        exit 2
elif [ $# -eq 1 ]
then
        arg=$1
else
        echo -e "${Red}Invalid options: $@${NC}"
        exit 1
fi

config=".mount.conf"
DRIVES=$(cat -n $path/$config | grep "drives" | cut -d"=" -f2)
$DEBUG && echo "drives: $DRIVES"
len=$(wc -l $path/$config | cut -d" " -f1)	# conf file len
for DRIVE in $DRIVES
do
	echo -e "${Green}Drive: ${Blue}$DRIVE${NC}"
	# najiti intervalu
	start_line=$(cat -n $path/$config | tail -n $(( $len - 1 )) | grep "#" | grep $DRIVE | cut -f1 | tr -d " ")
	stop_line=$(cat -n $path/$config | tail -n $(( $len - $start_line )) | grep "#" | tr "\n" " " | cut -f1 | tr -d " ")
	
	# parse
	name=$(sed -n "${start_line},${stop_line}p" $path/$config | grep "name" | cut -d"=" -f2)
	servername=$(sed -n "${start_line},${stop_line}p" $path/$config | grep "servername" | cut -d"=" -f2)
	sharename=$(sed -n "${start_line},${stop_line}p" $path/$config | grep "sharename" | cut -d"=" -f2)
	
	if $DEBUG; then
        	echo "Config lines:"
		echo " > from: $start_line"
        	echo " > to: $stop_line"
		echo "Server: $servername"
        	echo "Share: $sharename"
        	echo "Mount point: $mountpoint"
        	echo "tmp location: $tmplocation"
	fi
done
exit

line=$(cat -n $path/$config | tail -n $(( $len - 1 )) | grep "SMB" | cut -f1 | tr -d " ")
NUM=$(( line + 1 ))
name=$(sed "${NUM}q;d" $path/$config | cut -d"=" -f2)
NUM=$(( line + 2 ))
servername=$(sed "${NUM}q;d" $path/$config | cut -d"=" -f2)
NUM=$(( line + 3 ))
sharename=$(sed "${NUM}q;d" $path/$config | cut -d"=" -f2)

userid=$(id -u $user)
mountpoint="/media/$user/$name"
tmplocation="/run/user/$userid/gvfs/smb-share:server=$servername,share=$sharename"

if $DEBUG; then
        echo "Server: $servername"
        echo "Share: $sharename"
	echo "Mount point: $mountpoint"
	echo "tmp location: $tmplocation"
fi

case $arg in
	"-m" | "--mount")
		# pripoji sitovy disk
                echo -e "${Green}Mounting: ${Blue}$servername${NC}"
                gio mount "smb://$servername/$sharename"
		# mount point
		echo -en "${Green}Link check: ${NC}"
		$path/linkCheck.sh $mountpoint	
		ec=$?
		case $ec in
			0) echo "Link to tmp dir established.";;
			1) echo "${Red}ERROR:${NC} Invalid mount point!";;
			2) echo "${Red}ERROR:${NC} Failed to connect with tmp dir!";;
			3) echo "${Red}ERROR:${NC} Dir already exists and it is not a link!";;
			4) 
				echo  "Creating new link."
				sudo ln -s $tmplocation $mountpoint
			;;
		esac
        ;;
        "-u" | "--unmount")
                # odpoji se od sitoveho disku
		echo -e "${Green}Unmounting: ${Blue}$servername${NC}"
                gio mount -u "smb://$servername/$sharename"
        ;;
        "-l" | "--list")
                # vypise pripojene disky
                gio mount -l | grep "^[^ ]" | grep "Mount"
        ;;
        *)
                # Default condition
                echo -e "${Red}Unknown parametr: $arg${NC}"
                exit 2
        ;;
esac

echo "Done"
exit
#END
