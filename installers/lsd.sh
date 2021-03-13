#!/bin/bash
# By Pytel
# Skript pro instalaci:
# LSDeluxe - The next gen ls command

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
# $USERNAME - nefunguje na roota
user=$(. $BASEDIR/get_curent_user.sh)
#echo $user
if [ $? != 0 ]
then
        echo -e "${RED}Unable to parse user!${NC}"
        exit 2
fi

path="/home/$user"

verzion=0.19.0
file=lsd_"$verzion"_amd64.deb

# stahne dany soubor
if [ -f $file ]	# existuje jiz dany soubor?
then
        echo -e "${GREEN}Already downloaded!${NC}"
else
        echo -e "${GREEN}Downloading: ${BLUE}LSD${NC}"
	curl -L -O https://github.com/Peltoche/lsd/releases/download/$verzion/$file
fi

echo -en "${GREEN}Install LSDeluxe: ${NC}"
if [ ! $(dpkg -i $file) ]
then
	echo -e "${RED}Are you root?${NC}"
        exit 1
fi
echo "Done"
#snap install lsd --classic     # stara nefunkci verze

echo -e "${GREEN}Installing fonts: ${NC}"
./fonts.sh
echo -e "\r${GREEN}Installing fonts: ${NC}Done"

# clear
echo -e -n "${GREEN}Clearing downloaded files: ${NC}"
rm $file    # smaze stazeny balicek
echo "Done"

# nastavi aliasy
echo -en "${GREEN}Setting aliases: ${NC}" 
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
