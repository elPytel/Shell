#!/bin/bash
# By Pytel

if [ $# -ne 1 ]; then
	echo "Missing argument: Which file?"
        exit 1
fi
link=$1
if [ -L $link ] ; then
   if [ -e $link ] ; then
      echo "Good link"
      exit 0
   else
      echo "Broken link"
      exit 2
   fi
elif [ -e $link ] ; then
   echo "Not a link"
   exit 3
else
   echo "Missing"
   exit 4
fi
#END
