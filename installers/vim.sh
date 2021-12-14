#!/bin/bash
# By Pytel
# install and configure Vim

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")
user=$(. ../tools/get_curent_user.sh)
if [ $? != 0 ]; then
        [ $DEBUG ] && echo $user
	echo -e "${Red}Unable to parse user!${NC}"
        exit 2
fi

path="/home/$user"

# colors
source $path/Shell/tools/colors.sh

app="vim"
# install
echo -e "${Green}Installing ${Blue}$app: ${NC}"
if apt install $app -y; then
        echo "Done"
else
        echo -e "${Red}ERROR: ${NC}failed to install ${Blue}$app${NC}!"
        exit 1
fi

vimConf=".vimrc"
if [ ! -f $path/$vimConf ]; then
	cat >> $path/$vimConf <<EOF

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
EOF
	echo "${Blue}$vimConf ${NC}created."
fi

echo "${Blue}$app ${NC}installing done."
exit 0
#END


