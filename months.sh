#!/bin/bash
# By Pytel
# Script ktery vypise mesice v roce: cisla, cesky, anglicky.

#DEBUG=true
#DEBUG=false

MONTH_CZ=(Leden Únor Březen Duben Květen Červen Červenec Srpen Září Říjen Listopad Prosinec)
MONTH_EN=(January February March April May June July August September October November December)

echo -e "Číslo:\t měsíc:\t\t month:"
for i in {0..11}; do
	index=$(( i +1 ))
	printf "%4d\t %s" "$index" "${MONTH_CZ[$i]}" 
	if [ ${#MONTH_CZ[$i]} -lt 8 ]; then echo -ne "\t"; fi;
	printf "\t %s\n" "${MONTH_EN[$i]}"
done

exit 0
#END
