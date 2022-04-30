#!/bin/bash
# By Pytel
# Skript pro instalaci cmus
# cmus - a small, fast and powerful console music player for Unix-like operating systems.
# https://cmus.github.io/#home

DEBUG=false

source ../tools/colors.sh

app=cmus
../tools/install_app.sh $app

exit $?
#END
