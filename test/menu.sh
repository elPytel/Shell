#!/bin/bash
OPTIONS="Hello Quit"
#PS3="Select option: "
select opt in $OPTIONS; do
	if [ "$opt" = "Quit" ]; then
		echo done
        exit
    elif [ "$opt" = "Hello" ]; then
        echo Hello World
    else
        clear
	    echo bad option
	fi
done
