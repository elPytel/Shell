#!/bin/bash
# By Pytel
# Skript pro praci s gio na pripojovani sitovych disku

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
source $BASEDIR/tools/colors.sh

config=".mount.conf"
DRIVES=$(cat -n $path/$config | grep "drives" | cut -d"=" -f2)
len=$(wc -l $path/$config | cut -d" " -f1)      # conf file len
userid=$(id -u $user)

# zadal validni argumenty?
case $# in
	0) 
		#echo -e "${Green}Valid arguments: ${NC} -m --mount | -u --unmount | -l --list | -c --connections"
        	echo -e "USE:"
		echo -e "  $(echo $0 | tr "/" "\n" | tail -n 1) COMMAND [none=all | conf_name]"
		echo ""
		echo -e "COMMANDS:"
		echo -e "  -m --mount  \t\t to mount selected network drive"
		echo -e "  -u --unmount\t\t to unmount selected network drive"
		echo -e "  -l --list   \t\t list of mounted drves"
		echo -e "  -c --connections\t print all configurated connections"
		exit 2
		;;
	1) arg=$1;;
	2)
		if [ $(echo "$DRIVES" | tr " " "\n" | grep "$2" | wc -l    ) -eq 1 ]; then
			arg=$1
			DRIVES=$2
		fi
		;;
	*) echo -e "${Red}Invalid options: $@${NC}"; exit 1;;
esac

$DEBUG && echo "drives: $DRIVES"

# zpracovani
case $arg in
	"-m" | "--mount" | "-u" | "--unmount")
		for DRIVE in $DRIVES; do
        		echo -e "${Green}Drive: ${Blue}$DRIVE${NC}"
        		# najiti intervalu
        		start_line=$(cat -n $path/$config | tail -n $(( $len - 1 )) | grep "#" | grep $DRIVE | cut -f1 | tr -d " ")
        		stop_line=$(cat -n $path/$config | tail -n $(( $len - $start_line )) | grep "#" | tr "\n" " " | cut -f1 | tr -d " ")

        		# parse
       			name=$(sed -n "${start_line},${stop_line}p" $path/$config | grep "name" | cut -d"=" -f2)
        		service=$(sed -n "${start_line},${stop_line}p" $path/$config | grep "service=" | cut -d"=" -f2)
        		server=$(sed -n "${start_line},${stop_line}p" $path/$config | grep "server=\|host=")
        		share=$(sed -n "${start_line},${stop_line}p" $path/$config | grep "share=\|user=")
			
			mountpoint="/media/$user/$name"
        		tmplocation="/run/user/$userid/gvfs/$service:$server,$share"

        		if $DEBUG; then
        		        echo "Config lines:"
        		        echo " > from: $start_line"
        		        echo " > to: $stop_line"
        		        echo "Server: $server"
        		        echo "Share: $share"
        		        echo "Mount point: $mountpoint"
        		        echo "tmp location: $tmplocation"
       			fi

			servername=$(echo $server | cut -d"=" -f2)
			sharename=$(echo $share | cut -d"=" -f2)
			#exit
			case $arg in	
				"-m" | "--mount")
					# pripoji sitovy disk
        			        echo -e "${Green}Mounting: ${Blue}$servername${NC}"
					case $service in
						"google-drive") gio mount "$service://$sharename@$servername";;
						"smb-share") gio mount "smb://$servername/$sharename";;
						*) 
							echo -e "${Red}ERROR:${NC} Ups something Faigled!" 
							echo -e "\tUnimplemented service: ${Blue}$service${NC}"
							;;
					esac
					# mount point
					echo -en "${Green}Link check: ${NC}"
					$path/linkCheck.sh $mountpoint	
					ec=$?
					case $ec in
						0) echo "Link to tmp dir established.";;
						1) echo -e "${Red}ERROR:${NC} Invalid mount point!";;
						2) echo -e "${Red}ERROR:${NC} Failed to connect with tmp dir!";;
						3) echo -e "${Red}ERROR:${NC} Dir already exists and it is not a link!";;
						4) 
							echo  "Creating new link."
							sudo ln -s $tmplocation $mountpoint
							;;
					esac
        				;;
        			"-u" | "--unmount")
                			# odpoji se od sitoveho disku
					echo -e "${Green}Unmounting: ${Blue}$name${NC}"
                			case $service in
						"google-drive") gio mount -u "$service://$sharename@$servername";;
						"smb-share") gio mount -u "smb://$servername/$sharename";;
					esac
					;;
			esac
		done
		echo "Done"
		;;
	"-c" | "--connections")
		# vypise konfigurovana spojeni
		echo $(cat $path/$config | grep "drives" | cut -d"=" -f2)
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

exit 0
#END
