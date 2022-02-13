#!/bin/bash
# By Pytel
# Skript pro instalaci:
# Pythonu

#DEBUG="true"
DEBUG="false"

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"              # cesta k /home/user
app="Python3"

# colors
source $path/Shell/colors.sh

# instalace
echo -e "${Green}Installing ${Blue}$app: ${NC}"
if apt install python3 -y; then
        echo "Done"
else
        echo -e "${Red}ERROR: failed to install ${Blue}$app${NC}!"
        exit 1
fi

app="Python3-pip"
echo -e "${Green}Installing ${Blue}$app: ${NC}"
if apt install python3-pip -y; then
        echo "Done"
else
        echo -e "${Red}ERROR: failed to install ${Blue}$app${NC}!"
        exit 1
fi

# aktulizace
python3 -m pip install --upgrade pip

# pytest
pip install -U pytest

# nastavi environment
# odstrani puvodni PATH pro .local/bin
sed -i '/.local\/bin/d' $path/.bash_environment

# nastavi PATH pro 
cat >> $path/.bash_environment <<EOF

# set PATH so it includes user's private .local/bin sripts if it exists
if [ -d "\$HOME/.local/bin" ] ; then
	PATH="\$HOME/.local/bin:\$PATH"
fi #.local/bin
EOF

echo "Done"


echo "Done"

exit 0
#END
