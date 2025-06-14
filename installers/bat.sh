#!/bin/bash
# By Pytel
# Skript pro instalaci:
# bat - A cat(1) clone with wings.

#DEBUG=true
DEBUG=false

# colors
RED='\033[0;31m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"        	# cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

# instalace
app="bat"
$path/Shell/tools/install_app.sh $app || exit $?

# nastavi aliasy
echo -en "${Green}Setting aliases: ${NC}"
[ ! -f $path.bash_aliases ] && touch $path.bash_aliases

# odstrani puvodni aliasy pro bat
sed -i '/bat/d' $path.bash_aliases

# nastavi nove aliasy pro bat
cat >> $path.bash_aliases <<EOF

# some bat aliases:
alias bat='batcat'
EOF
echo "Done"

exit 0
#END
