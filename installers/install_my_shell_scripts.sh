#!/bin/bash
# By Pytel

# Skript pro vytvoreni sym linku do /usr/local/bin pro adresar Shell

#DEBUG=true
DEBUG=false

source_dir="/home/$USER/Shell"
destination_dir="/usr/local/bin/Shell"

# test if source dir exists
if [ ! -d "${source_dir}" ]; then
    echo -e "Source directory does not exist!"
    exit 1
fi

# test if destination dir exists
if [ -L "${destination_dir}" ]; then
    echo -e "Destination link already exists!"
    exit 2
fi

# create destination dir
echo "Creating link to ${source_dir} in ${destination_dir}"
sudo ln -s "${source_dir}" "${destination_dir}"