#!/bin/bash
# By Pytel
# upravi .bashrc

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

path="/home/$user"

# nastavi cestu .bashrc k .bash_environment
env=.bash_environment
if [ $(cat $path/.bashrc | grep $env | wc -l) -eq 0 ]
then
        cat >> $path/.bashrc <<EOF

# Environment definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_environment, instead of adding them here directly.
if [ -f ~/.bash_environment ]; then
    . ~/.bash_environment
fi
EOF
        echo ".bashrc updated."
fi
exit 0
#END
