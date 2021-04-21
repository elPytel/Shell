#!/bin/bash
# konvert decimal number to binary
number=$1
binary=$(bc <<< "obase=2;$number")
echo $binary
exit 0
#END
