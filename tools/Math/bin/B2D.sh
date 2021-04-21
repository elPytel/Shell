#!/bin/bash
# konvert binary number to decimal
number=$1
#decimal=$((2#$number))
decimal=$(bc <<< "ibase=2;$number")
echo "$decimal"
exit 0
#END
