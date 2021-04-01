#!/bin/bash
# By Pytel
# Skript pro rozhodovani potvrzeni a zamitnuti

# !1 argiment
if [ $# -ne 1 ]
then
        exit 2
fi

case $1 in
	"Y" | "y" | "Yes" | "yes")
		exit 0
		;;
	"N" | "n" | "No" | "no")
		exit 1
		;;
	*)
		exit 2
		;;
esac

exit 2
#END
