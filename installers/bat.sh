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

# find user name
user=$(. $BASEDIR/../tools/get_curent_user.sh)
if [ $? != 0 ]; then
	$DEBUG &&  echo $user
	echo -e "${RED}Unable to parse user!${NC}"
	exit 2
fi

path="/home/$user/"

# colors
source $path/Shell/tools/colors.sh

app="bat"
# instalace
echo -e "${Green}Installing ${Blue}$app: ${NC}"
if apt install $app -y; then
        echo "Done"
else
        echo -e "${Red}ERROR: failed to install ${Blue}$app${NC}!"
        exit 1
fi

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
