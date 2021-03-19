#!/bin/bash
# By Pytel
# Skript pro instalaci:
# LSDeluxe - The next gen ls command

# colors
RED='\033[0;31m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
user=$(. $BASEDIR/get_curent_user.sh)
if [ $? != 0 ]; then
        [ $DEBUG ] && echo $user
	echo -e "${RED}Unable to parse user!${NC}"
        exit 2
fi

path="/home/$user"               # cesta k /home/user

# colors
source $path/Shell/colors.sh

verzion=0.19.0
file=lsd_"$verzion"_amd64.deb

# stahne dany soubor
if [ -f $file ]	# existuje jiz dany soubor?
then
        echo -e "${Green}Already downloaded!${NC}"
else
        echo -e "${Green}Downloading: ${Blue}LSD${NC}"
	curl -L -O https://github.com/Peltoche/lsd/releases/download/$verzion/$file
fi

echo -en "${Green}Install LSDeluxe: ${NC}"
if [ ! $(dpkg -i $file) ]
then
	echo -e "${Red}Are you root?${NC}"
        exit 1
fi
echo "Done"
#snap install lsd --classic     # stara nefunkci verze

echo -e "${Green}Installing fonts: ${NC}"
./fonts.sh
echo -e "\r${Green}Installing fonts: ${NC}Done"

# clear
echo -e -n "${Green}Clearing downloaded files: ${NC}"
rm $file    # smaze stazeny balicek
echo "Done"

# nastavi aliasy
echo -en "${Green}Setting aliases: ${NC}" 
[ ! -f $path/.bash_aliases ] && touch $path/.bash_aliases

# odstrani puvodni aliasy pro lsd
sed -i '/lsd/d' $path/.bash_aliases

# nastavi nove aliasy pro lsd
cat >> $path/.bash_aliases <<EOF

# some lsd aliases:
alias lsd='lsd --group-dirs first'
EOF

#echo "# some lsd aliases:" >> ~/.bash_aliases
#echo "alias lsd='lsd --group-dirs first'" >> ~/.bash_aliases

echo "Done"

exit
#END
