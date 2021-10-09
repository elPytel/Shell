#!/bin/bash
# By Pytel

DEBUG=true
#DEBUG=false

function setStart () { #( index )
	if [ $# -ne 1 ]; then
		echo "ERROR: ${NC}invalid args: [$*]" 1>&2
                return 1
        fi
	local index=$1
	if [ ${#index} -ne 6 ]; then
		echo "ERROR: ${NC}invalid len [$index]" 1>&2	
		return 2
	fi
	entry=$index
	return 0
}

entry="100000"
time="0.2"
dir="imgs"

# input args
case $# in
	0) ;;
	1) setStart $1 || exit 3;;
	*) echo -e "Invalid parametr!"; exit 1;;
esac

# does directory exist?
if [ ! -d "$dir" ]; then
	mkdir imgs
	$DEBUG && echo "Directory: $dir created."
fi

for i in {1..10}; do
	$DEBUG && echo "Next: $entry"
	page="https://prnt.sc/"$entry
	
	$DEBUG && echo -e "Page: $page"
	
	data=$(wget "$page" -q -O -)
	
	imgLine=$(echo $data | tr ">" "\n" | grep "image-id")
	imgLink=$(echo $imgLine | tr " " "\n" | grep "src" | cut -d "\"" -f 2)
	format=$(echo $imgLink | tr "." "\n" | tail -1)
	
	$DEBUG && echo "Img link: $imgLink"
	$DEBUG && echo "Format: $format"
	
	name="$entry.$format"
	# download img
	wget $imgLink -O $dir/$name --max-redirect=0
	
	# remove empty pictures
	size=$(ls -l $dir/$name | cut -d " " -f5)
	if [ $size -eq 0 ]; then
		rm $dir/$name
		$DEBUG && echo "Empty picture, removing: $name"
	fi

	entry=$(./next.sh $entry)
	sleep $time
done

echo "Done"
exit 0
# END
