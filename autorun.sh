#!/bin/bash
# By Pytel
# Auto run script on change

#DEBUG=true
DEBUG=false

VERBOSE=false

# colors
source $path/Shell/tools/colors.sh

if [[ $# -eq 0 ]]; then
    echo -e "${Red}ERROR${NC}: no file is specified"
    exit 1
fi

file="$1"

chmod +x $1 &&
echo $file | entr -c ./$file; echo ""

$DEBUG && echo "Done"
#END
