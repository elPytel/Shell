#!/bin/bash
# By Pytel
# Skript pro instalaci:
# git - verzovaci system pro spravu softwaru

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"	        # cesta k /home/user 

if $DEBUG; then
	echo $user
	echo $path
fi

# colors
source $path/Shell/tools/colors.sh

# instalace gitu
app="git"
$path/Shell/tools/install_app.sh $app || exit $?

app="gh"
$path/Shell/tools/install_app.sh $app || exit $?

# nastavi aliasy
echo -en "${Green}Setting aliases: ${NC}"
[ ! -f $path/.bash_aliases ] && touch $path/.bash_aliases

# odstrani puvodni aliasy
sed -i '/git/d' $path/.bash_aliases

# nastavi nove aliasy
cat >> $path/.bash_aliases <<EOF

# some git aliases:
alias gt='git status'
alias gd='git add . '
alias gp='git push'
alias gc='git commit -a'
EOF
echo "Done"

# configurace
echo -e "${Green}Git config${NC} "
echo -en "${Green}Your email: ${NC} "
read email
echo -en "${Green}Your name: ${NC} "
read name
git config --global user.email $email
git config --global user.name $name
git config --global init.defaultBranch main	# nove inicializovane repozitare zacinaji ve vetvi main

# nastavi ukladani hesla
git config --global credential.helper store
# git config credential.helper cache <timeout> # timeout v sec.

# propojeni s githubem
echo -en ${Green}Loging to github${NC}
gh auth login

echo -e "${Green}Git config done${NC}"
exit 0
#END

