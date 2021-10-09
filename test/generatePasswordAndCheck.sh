#/bin/bash

generatePassword() {
	local cCharacters
	cCharacters=${1:-32}
	local s=""
	
	# Here we produce 28 characters each time
	until s="$s$(dd bs=21 count=1 if=/dev/urandom 2>/dev/null | LC_CTYPE=C tr -cd "a-z0-9\-_#+")"
		  ((${#s} >= cCharacters)); do :; done
	
	echo "${s:0:$cCharacters}"
}

generatePassword 12
generatePassword
generatePassword 100

pwnedCheck() {
	local pwd="$1"
	local hash
	hash=$(echo -n "$pwd" | sha1sum | cut -c -40)
	local expected=${hash#?????}
	local prefix=${hash%$expected}
	local match

	match="$(curl -s "https://api.pwnedpasswords.com/range/${prefix}" | grep -i "^$expected:")" || return 1 
	echo "${match#*:}" | tr -d '\r'
}

occ="$(pwnedCheck "1234")"
echo "The password '1234' has $occ occurences."

genPass="$(generatePassword)"
occ="$(pwnedCheck "$genPass")"
if [[ -z "$occ" ]]; then
	echo "The password '$genPass' has no occurences."
else
	echo "The password '$genPass' has $occ occurences."
fi
