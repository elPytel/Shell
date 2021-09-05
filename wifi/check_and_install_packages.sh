#!/bin/bash
# By Pytel
# Script for checking if needed software is instaled.

DEBUG=true
#DEBUG=false

VERBOSE=true
#VERBOSE=false

apps="aircrack-ng"

if [ $(whoami) != "root" ]
then
	echo -e "${RED}I nead root privileges!${NC}"
	exec sudo "$0" "$@"	# znovu zpusti sam sebe ale s pravy roota
	echo "Error: failed to execute sudo" >&2
	exit 1
fi

for app in $apps; do
	dpkg -s $app &>/dev/null
	ret="$?"
	$DEBUG && echo -e "ret: $ret"
	if [ $ret -eq 0 ]; then
		$VERBOSE && echo -e "App: $app is installed!"
	else
		$VERBOSE && echo -e "App: $app is not installed! \n instaling..."
		sudo apt install $app -y
	fi
done

$VERBOSE && echo -e "Done"
exit 0
# END
