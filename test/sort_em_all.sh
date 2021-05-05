#!/bin/bash
# By Pytel
# Algoritmus pro trideni soubru podle klice do adresaru.
# Jeho zaznam by mel mit cron pro spravnou funkci.

DEBUG=true
#DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
#user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"        # cesta k skriptum
$DEBUG && echo "path: $BASEDIR"

# colors
#source "$BASEDIR"/tools/colors.sh

config=".sort.conf"

cat $config
entry=$(grep -v "#" $config | grep ":" | cut -d":" -f1)
toFolder=$(grep -v "#" $config | grep ":" | cut -d":" -f2)
echo $(grep -v "#" $config | grep ":" )
echo $entry
echo $toFolder

exit 0
# END
