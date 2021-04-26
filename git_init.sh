#!/bin/bash
# By Pytel
# Skript pro ininicializaci Git-repo

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")         # adresa k tomuto skriptu
user=$(. "$BASEDIR"/tools/get_curent_user.sh)
path="/home/$user/Shell"	# cesta k /home/user/Shell

# colors
source "$path"/tools/colors.sh

echo -en "${Green}Are you sure to init git repo here?${NC} Y/n: "
read answer
#if [ $($path/tools/yes_no.sh $answer) != true ] ; then
if ! "$path"/tools/yes_no.sh "$answer" ; then
	exit 1
fi

echo -en "${Green}What is the name of this project?${NC} "
read name

echo "# $name" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
echo -en "${Green}Type link to your GitHub repo: ${NC}"
read GitHubPage
git remote add origin "$GitHubPage"
git push -u origin main

echo "Done"
exit 0
#END
