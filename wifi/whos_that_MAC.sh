#!/bin/bash
# By Pytel
# Uses API on https://macvendors.com/ to get info on MAC.

#DEBUG=true
DEBUG=false

VERBOSE=false

MAC=$1
webAPI="https://api.macvendors.com"
vendor=$(wget "$webAPI/$MAC" -q -O -)

echo $vendor

$VERBOSE && echo "Done"
exit 0
# END
