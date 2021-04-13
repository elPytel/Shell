#!/bin/bash
# By Pytel
# skript pro odesilani logu na email
# mail z baliku mailutils
# instalace a konfigurace:
# sudo apt install mailutils
# sudo dpkg-reconfigure postfix
# vybrat: Internetový počítač
# systemctl reload postfix

#mail -s "Test Subject" jaroslav.korner1@gmail.com < /dev/null

#DEBUG="true"
DEBUG="false"

path=$(dirname "$0")         # adresa k tomuto skriptu

# colors
source $path/tools/colors.sh

config=".email.conf"
subject="Logs"  # datum a nazev
$DEBUG && echo "Subject: $subject"

# odeslani e-mailem
#FILES="~/.my.log ~/.backup.log ~/.startup.log"
FILES=".test.log"
for FILE in $FILES; do
	files="$files -A $FILE"
done
$DEBUG && echo "Files: $files"

# odeslani
email=$(cat $path/$config)
echo -e "${Green}Sending to email:${NC} $email"
#mail -s $subject -A $subject $email < /dev/null; ec=$?
ec=0
case $ec in
        0) echo "E-mail: $subject, sent OK.";;
        *) 
		echo -e "${Red}ERROR:${NC} failed to sent!"
		exit 1
		;;
esac

# prace se soubory
for FILE in $FILES; do
	name=$FILE
	name_OLD="$(echo $FILE | cut -d"." -f1,2)_OLD.log"
	rm $name_OLD			# odstrani stary
	mv $name $name_OLD; ec=$?	# prejmenuje novy na stary (_OLD)
	if [ $ec -eq 0 ]; then
	       echo -e "File: $name renamed to: $name_OLD"
	fi
done

echo "Done"
exit 0
#END
