#!/bin/bash
# By Pytel
# Skript pro instalaci:
# WordGrinder is a simple, Unicode-aware word pro>

#DEBUG="true"
DEBUG="false"

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"              # cesta k /home/user

# colors
source $path/Shell/colors.sh

# instalace
echo -e "${Green}Installing wordgrinder: ${NC}"
if apt install wordgrinder -y; then
        echo "Done"
else
        echo -e "${Red}ERROR!${NC}"
        exit 1
fi

# nastavi aliasy
echo -en "${Green}Setting aliases: ${NC}"
[ ! -f $path/.bash_aliases ] && touch $path/.bash_aliases

# odstrani puvodni aliasy
sed -i '/wordgrinder/d' $path/.bash_aliases

# nastavi nove aliasy
cat >> $path/.bash_aliases <<EOF

# some wordgrinder aliases:
alias word='wordgrinder'
EOF
echo "Done"

exit 0
#END
