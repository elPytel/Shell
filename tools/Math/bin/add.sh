#!/bin/bash
# secte binrani hodnoty
A=$1
B=$2
echo "ibase=2;obase=2; $A+$B" | bc -l
exit 0
#END
