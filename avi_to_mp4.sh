#!/bin/sh
# By Pytel


for file in $(ls | grep ".avi" | cut -d "." -f 1); do
	old_file=${file}.avi
	new_file=${file}.mp4
	echo "$old_file -> $new_file"
	ffmpeg -i $file.avi $file.mp4
	rm $old_file
done

exit 0
# END
