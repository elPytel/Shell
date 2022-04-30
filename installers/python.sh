#!/bin/bash
# By Pytel
# Skript pro instalaci:
# Pythonu

#DEBUG="true"
DEBUG="false"

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"              # cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

# instalace
apps="python3 python3-pip"
for app in $apps; do
	$path/Shell/tools/install_app.sh $app || exit $?
done

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
exit 0
#END
