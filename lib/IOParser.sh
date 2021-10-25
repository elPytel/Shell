#!/bin/bash
# By Pytel

# funkce pro rozhodovani potvrzeni a zamitnuti
function yes_no () { #( strign )
	# !1 argiment
	if [ $# -ne 1 ]; then
        	return 2
	fi

	case $1 in
		"Y" | "y" | "Yes" | "yes")	return 0;;
		"N" | "n" | "No"  | "no")	return 1;;
		*)				return 2;;
	esac

	return 2
}


#END
