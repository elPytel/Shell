#!/bin/bash
# By Pytel
# Skript pro instalaci:
# WordGrinder is a simple, Unicode-aware word pro>

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"              # cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

# instalace
app="wordgrinder"
$path/Shell/tools/install_app.sh $app || exit $?

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
