#!/bin/bash
# By Pytel
# Skript pro konfiguraci environment promenych.

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
user=$(. ../tools/get_curent_user.sh)
if [ $? != 0 ]; then
	$DEBUG && echo $user
	echo -e "${RED}Unable to parse user!${NC}"
	exit 2
fi

path="/home/$user"

# colors
source $path/Shell/tools/colors.sh

# vytvori soubor .bash_environment 
echo -en "${Green}Setting environment: ${NC}"
[ ! -f $path/.bash_environment ] && touch $path/.bash_environment

# nastavi environment
# odstrani puvodni PATH pro Shell
sed -i '/Shell/d' $path/.bash_environment

# nastavi novou PATH pro Shell
cat >> $path/.bash_environment <<EOF

# set PATH to includes user's private Shell sripts if it exists
if [ -d "\$HOME/Shell" ] ; then
	PATH="\$HOME/Shell:\$PATH"
fi #Shell
EOF
echo "Done"

exit 0
# END
