#!/bin/bash
# By Pytel
# Skript pro instalaci fontu

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 	# No Color

# font: UbuntuMono Nerd Font 
# dostupne z: https://www.nerdfonts.com/font-downloads
font_type=nerdfont
font_name=UbuntuMono
archiv=".zip"
version="3.1.1"
# stahne dany soubor
if [ $(ls | grep "$name$archiv" | wc -l) -eq 1 ]
then
	echo -e "${GREEN}Already downloaded!${NC}"
else
	echo -e "${GREEN}Downloading: ${BLUE}$font_name${NC}"
	curl -L -O https://github.com/ryanoasis/nerd-fonts/releases/download/$version/$font_name$archiv
fi

# rozbali archiv do adekvatni slozky
folder="/usr/share/fonts"
if [ ! -d $folder/$font_type ]
then
	echo -e "${GREEN}Folder: ${BLUE}$font_type ${GREEN}does not exist, creating new one.${NC}" 
	if ! mkdir $folder/$font_type 
	then
		echo -e "${RED}Are you root?${NC}"
		exit 1
	fi
fi

if [ ! -d $folder/$font_type/$font_name ]
then
	echo -e "${GREEN}Folder: ${BLUE}$font_name ${GREEN}doesnt exist, creating new one.${NC}"
	if ! mkdir $folder/$font_type/$font_name
        then
			echo -e "${RED}Are you root?${NC}"
			exit 1
        fi
fi

if [ $(ls "$folder/$font_type/$font_name" | wc -l) -gt 0 ]
then
	echo -e "${RED}Font already extracted!${NC}"
else
	echo -e "${GREEN}Extracting: ${BLUE}$font_name$archiv ${GREEN}to folder ${BLUE}$folder/$font_type/$font_name${NC}"
	unzip $font_name$archiv -d $folder/$font_type/$font_name
	
	# aktualizuje font-cache
	echo -e "${GREEN}Font-cache aktualization:${NC}"
	fc-cache -fv
fi

# clear
echo -e -n "${GREEN}Clearing downloaded files: ${NC}"
rm $font_name$archiv	# smaze stazeny archiv

echo "Done"
echo -e "${RED}If you want to use this font in the terminal for LSD, then you nead to setup terminal preferences to use ${BLUE}$font_name $font_type${NC}!"
exit 0
#END
