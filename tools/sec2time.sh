#!/bin/bash
# By Pytel
# Skript pro prevod sekund na standardni format casu.

case $# in
	0) exit 1;;
	1) 
		if [ $1 -gt 0 ]; then
			(( h=${1}/3600 ))
			(( m=(${1}%3600)/60 ))
			(( s=${1}%60 ))
			printf "%02d:%02d:%02d\n" $h $m $s
		fi
		exit 0
		;;
	*) exit 2;;
esac

exit 3
#END
