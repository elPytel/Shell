#!/bin/bash
# By Pytel
# Skript pro instalaci:
# tty-clock - aplikace pro zobrazovani casu v terminalu

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"

# colors
source $path/Shell/tools/colors.sh

# instalace
app="tty-clock"
$path/Shell/tools/install_app.sh $app || exit $?

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
