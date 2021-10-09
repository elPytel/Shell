#!/bin/bash
# By Pytel
# tool for adding more MAC and Vendos

DEBUG=true

vendor=$1
file=$2

for line in $(cat "$file" | cut -f 1); do
	edited=$(echo $line | cut -d ":" -f 1,2,3)
	echo "$vendor $edited"
done

exit 0
# END

# cat Vendors-MAC.txt | rev | sed 's/^\(.\{8\}\)./\1 /' | rev
# cat Vendors-MAC.txt | sort | cut -d " " -f1 | uniq | tr "\n" " "
