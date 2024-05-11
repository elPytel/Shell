#!/bin/bash
# By Pytel
# skript pro odesilani logu na email
# mail z baliku mailutils
# instalace a konfigurace:
# sudo apt install mailutils
# sudo dpkg-reconfigure postfix
# vybrat: Internetový počítač
# systemctl reload postfix

#mail -s "Test Subject" <email>@gmail.com < /dev/null

#DEBUG=true
DEBUG=false

path=$(dirname "$0")         # adresa k tomuto skriptu

# colors
source "$path"/tools/colors.sh

config=".email.conf"
subject="Logs: $(date | cut -d"," -f1)"			# datum a nazev
$DEBUG && echo "Subject: $subject"

# odeslani e-mailem
FILES=$(cat "$path"/$config | grep "files2send=" | cut -d"=" -f2)
for FILE in $FILES; do
	files="$files -A "$(eval echo "$FILE")
	#files="$files -A $FILE"
done
#files=~/.my.log
$DEBUG && echo "Files: $files"


# odeslani
email=$(cat "$path"/$config | grep "e-mail=" | cut -d"=" -f2)
echo -e "${Green}Sending to email:${NC} $email"
#mail -s "$subject" -A ~/.my.log -A ~/.backup.log -A ~/.startup.log $email < /dev/null; ec=$?
mail -s "$subject" $files "$email" < /dev/null; ec=$?
#ec=0
case $ec in
	0) echo "E-mail: $subject, sent OK.";;
    *) 
		echo -e "${Red}ERROR:${NC} failed to sent!"
		exit 1
		;;
esac

# prace se soubory
for FILE in $FILES; do
	#if [ $(echo $FILE | grep -c "~*") -gt 0 ]; then
	#	name=$HOME/$(echo $FILE | tr -d  "~/")
	#else
	#	name=$FILE
	#fi
	
	name=$FILE
	$DEBUG && echo "$name"
	name_OLD=$(echo "$name" | cut -d"." -f1,2)_OLD.log
	eval rm "$name_OLD"				# odstrani stary
	eval mv "$name" "$name_OLD"; ec=$?	# prejmenuje novy na stary (_OLD)
	eval touch "$name"				# vygeneruje novy prazdny
	if [ $ec -eq 0 ]; then
	       echo -e "File: $name renamed to: $name_OLD"
	fi
done

echo "Done"
exit 0
#END
