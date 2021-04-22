#!/bin/bash
# By Hans-Henry Jakobsen
OUTFILE="mk-iprange.txt"
IPRANGE="192.168.0 
192.168.1"
EXCLUDE="192.168.0.1
192.168.0.2
192.168.1.1"

# Remove old OUTFILE
rm -f $OUTFILE

# Loop addresses, write to OUTFILE
for IP in $IPRANGE
do
        seq -f "$IP.%g" 1 255 >> ./$OUTFILE
done

# Exclude IP-addresses from file (inplace replacement)
for EX in $EXCLUDE
do
        sed --in-place "/$EX/d" ./$OUTFILE
done
