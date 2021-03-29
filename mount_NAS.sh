#!/bin/bash
# By Pytel
# Skript pro praci s gio na pripojovani sitovych disku

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptui
user=$(. $BASEDIR/installers/get_curent_user.sh)
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
line=$(cat -n $config | grep "SMB" | cut -f1 | tr -d " ")
NUM=$(( line + 1 ))
servername=$(sed "${NUM}q;d" $config | cut -d"=" -f2)
NUM=$(( line + 2 ))
sharename=$(sed "${NUM}q;d" $config | cut -d"=" -f2)

userid=$(id -u $user)
mountpoint="/media/$user/$servername"
tmplocation="/run/user/$userid/gvfs/smb-share:server=$servername,share=$sharename"

# ~/<mountpoint>

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
		./linkCheck.sh $mountpoint	
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
