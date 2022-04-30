#!/bin/bash
# By Pytel
# install and configure Vim

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")
user=$(. ../tools/get_curent_user.sh)
if [ $? != 0 ]; then
    $DEBUG && echo $user
	echo -e "${Red}Unable to parse user!${NC}"
    exit 2
fi

path="/home/$user"

# colors
source $path/Shell/tools/colors.sh

# install
app="vim"
$path/Shell/tools/install_app.sh $app || exit $?

vimConf=".vimrc"
if [ ! -f $path/$vimConf ]; then
	cat >> $path/$vimConf <<EOF

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
EOF
	echo -e "${Blue}$vimConf ${NC}created."
fi

echo -e "${Blue}$app ${NC}installing done."
exit 0
#END
