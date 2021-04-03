#!/bin/bash
# By Pytel
# Skript pro instalaci:
# tty-clock - aplikace pro zobrazovani casu v terminalu

#DEBUG="true"
DEBUG="false"

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"        	# cesta k /home/user

# colors
source $path/Shell/colors.sh

# instalace
echo -e "${Green}Installing tty-clock: ${NC}"
if apt install tty-clock -y; then
        echo "Done"
else
        echo -e "${Red}ERROR!${NC}"
        exit 1
fi

# nastavi aliasy
echo -en "${Green}Setting aliases: ${NC}"
[ ! -f $path/.bash_aliases ] && touch $path/.bash_aliases

# odstrani puvodni aliasy
sed -i '/tty-clock/d' $path/.bash_aliases

# nastavi nove aliasy
cat >> $path/.bash_aliases <<EOF

# some tty-clock aliases:
alias clock='tty-clock -tbc'
EOF
echo "Done"

exit 0
#END
