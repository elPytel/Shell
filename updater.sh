#!/bin/bash
# By Pytel
# Skript pro automatickou aktualizaci

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

if [ $(whoami) != "root" ]	# kdyz neni root
then
        echo -e "${RED}I nead root privileges!${NC}"
        sudo $0 $1        # znovu zpusti sam sebe ale s pravy roota
        exit 1
fi

# argumenty
arg=""
if [ "$1" == "-y" ]
then
        arg=$1
fi

# aktualizace
echo -e "${GREEN}Update:${NC}"
apt-get update
echo -e "${GREEN}Upgrade:${NC}"
apt-get upgrade $1

exit 0
#END
