#!/bin/bash
# By Pytel

# option to choose one question or continues conversation
# -c | --chat
# -q | --question
# -h | --help

DEBUG=false
VERBOSE=false
TTS=false
LANGUAGE="cs"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'    # No Color

function printHelp() {
    echo -e "Usage: ./ChatGPT.sh [OPTION]"
    echo -e "Chat with ChatGPT."
    echo -e ""
    echo -e "Options:"
    echo -e "-h, --help       Print this help message."
    echo -e "-c, --chat       Continuously prompt the user for input."
    echo -e "-q, --question   Ask a question."
    echo -e "-t, --tts        Use text to speech."
    echo -e "-l, --language   Set language for text to speech."
    echo -e "-d, --debug      Print debug messages."
    echo -e "-v, --verbose    Print verbose messages."
}

# Function to send a request to the API and receive the response
function send_request() { # ( api_key, prompt )
    local ENDPOINT="https://api.openai.com/v1/completions"
    local API_KEY=$1
    local text=$2

    # If prompt is not provided, ask the user for input
    if [ -z "$text" ]; then
        # Prompt the user for input
        read -p "You: \n" text
    fi
    
    # Prepare the request data
    data=$(cat <<EOF
    {
        "model": "text-davinci-003",
        "prompt": "$text",
        "max_tokens": 512,
        "temperature": 0.5,
        "top_p": 1
    }
EOF
)
    $DEBUG && echo -e "Data: \n$data"

    # Send the API request and get the response
    response=$(curl "$ENDPOINT"\
        -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "$data" 2>/dev/null)
    
    # Extract the response text from the JSON response
    $DEBUG && echo -e "Response: \n$response"
    response_text=$(echo "$response" | jq '.choices[0].text' | tr -d '"' | sed 's/^\\n//')

    # Print the response text
    echo -e "ChatGPT: $response_text"

    # Text to speech
    if $TTS; then
        tts $LANGUAGE "$(echo -e $response_text | tr '\n' ' ' )"
    fi
}

function chat() {
    echo "Chat with ChatGPT."
    echo "Type 'exit' to quit."
    echo ""

    # Continuously prompt the user for input
    while true; do
        # Prompt the user for input
        echo -e "You: "
        read text

        echo ""

        # Exit if the user types 'exit'
        if [ "$text" == "exit" ]; then
            exit 0
        fi

        send_request $API_KEY "$text"
        echo ""
    done

    echo "Exiting..."
    exit 0
}

function question() { # ( question )
    local question=$1

    # If prompt is not provided, ask the user for input
    if [ -z "$question" ]; then
        # Prompt the user for input
        read -p "Question: " question
    fi

    send_request $API_KEY "$question"

    echo "Exiting..."
    exit 0
}

function tts() { # ( lang text )
    local lang=$1
    local text=$2
    espeak-ng -v $lang "$text"
}

# check list of dependencies
DEPENDENCIES=$(cat dependencies.txt)
for dep in $DEPENDENCIES; do
    if ! [ -x "$(command -v $dep)" ]; then
        echo -e "${RED}Error:${NC} lib is not installed: $BLUE${dep}$NC" >&2
        echo -e "${GREEN}Install it with:$NC sudo apt install $dep" >&2
        exit 4
    fi
done

# load API key from file
API_KEY=$(cat API_KEY.conf)

# check if API key is set
if [ -z $API_KEY ]; then
    echo "Error: API key is not set." >&2
    exit 3
fi

# FSM for parsing input options
$DEBUG && echo "Args: [$@]"
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# parse options
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug) 	DEBUG=true;;
		-v | --verbose) VERBOSE=true;;
        -t | --tts) 	TTS=true;;
        -l | --language) shift; LANGUAGE=$1;;
        -c | --chat) 	chat; exit 0;;
        -q | --question) shift; question "$1"; exit 0;;
		*) send_request $API_KEY "$arg"; exit 0;;
	esac

	# next arg
	shift
	arg=$1
done

# if no option is given, start chat
chat

echo "Exiting..."
exit 0