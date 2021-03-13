#!/bin/bash
DEBUG="true"
#DEBUG="false"
echo $(pwd)

source ./colors.sh

echo -e "${Green}My test skript${NC}"
echo -e "${Green}User name: ${Blue}$USERNAME${Color_Off}"

echo -e "$(whoami)"

#echo -e "${Yellow}/home/user: \n${NC}$(ls --color=always ~ | tr ' ' '\n')"

exit
