#!/bin/bash
# By Pytel

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

# create file
[ ! -f $path/.bash_aliases ] && touch $path/.bash_aliases

cat aliases.txt >> $path/.bash_aliases

exit 0
# END
