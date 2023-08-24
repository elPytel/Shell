#!/bin/bash

# Textový editor v Bashi

# Získání názvu souboru
echo -n "Zadejte název souboru, který chcete upravit: \n"
read filename

# Ověření, zda existuje
if [ -e $filename ]; then
    echo "Soubor $filename existuje.\n"
else
    echo "Soubor $filename neexistuje.\n"
    exit 1
fi

# Cyklus načítání řádků souboru
while read -r line; do
    echo "$line\n "
    echo -n "Chcete tento řádek upravit? (ano/ne): \n"  
    read answer
    if [ "$answer" = "ano" ]; then
        echo -n "Zadejte nový řádek: \n"  
        read newline
        sed -i "s/$line/$newline/g" $filename
    fi
done < $filename

echo "Soubor $filename byl úspěšně upraven!"