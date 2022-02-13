#!/bin/bash
# By Pytel
# framework for testing bash scripts
# testing files: test_...sh
# testing metodes: test_... ()

#DEBUG=true
DEBUG=false
VERBOSE=false

# prepinac verbose nastavi vsechny test funkce na vypisovani vsech vystupu, jinak vypisuje pouze chyby

# bez argumentu najde vsechny soubory zacinajici test_ a koncisi .sh v pracovnim adresari
# s argumetem spusti vybrany soubor

# iteruje pre vsechny vybrane soubory a postupne spousti
# najde v nich vsechny funkce oznacene function test_... () a prida je do seznamu funkci, ktere je potreba spustit

# kazdou funkci spusti a odchyti jeji nermolni a chybovy vystup

# chyby funkci se posilaji na chybovy vystup
# vse ostatni je na normalnim

# standardni format chybovych vystupu

# kdyz funkce chybuje, tak vypisuji do konzole jeji kod
# zvyrazneni radku, ktery navraci danou chybovou hodnotu

# spocita uspesnot souboru, pocet proslych testu vs chybujicich

#END
