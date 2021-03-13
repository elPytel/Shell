#!/bin/bash
# By Pytel
# Skript pro instalaci:
# bat - A cat(1) clone with wings.

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu

# find user name
# $USERNAME - nefunguje na roota
user=$(. $BASEDIR/get_curent_user.sh)
#echo $user
if [ $? != 0 ]
then
        echo -e "${RED}Unable to parse user!${NC}"
        exit 2
fi

path="/home/$user/"
echo -e "${GREEN}Installing bat: ${NC}"
apt install bat
echo "Done"

# nastavi aliasy
echo -en "${GREEN}Setting aliases: ${NC}"
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
