#!/bin/bash
# By Pytel

# option to choose one question or continues conversation
# -c | --chat
# -q | --question
# -h | --help

DEBUG=false
VERBOSE=false

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
}

# Function to send a request to the API and receive the response
function send_request() { # ( api_key, prompt )
    local ENDPOINT="https://api.openai.com/v1/engines/chat-davinci/jobs"
    local API_KEY=$1
    local text=$2

    # If prompt is not provided, ask the user for input
    if [ -z "$text" ]; then
        # Prompt the user for input
        read -p "You: " text
    fi
    
    # Prepare the request data
    data=$(cat <<EOF
    {
        "prompt": "$text",
        "max_tokens": 100,
        "temperature": 0.5,
        "top_p": 1
    }
EOF
)
    
    # Send the API request and get the response
    response=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY" -d "$data" "$ENDPOINT")

    # Extract the response text from the JSON response
    response_text=$(echo "$response" | jq '.choices[0].text' | tr -d '"')

    # Print the response text
    echo "ChatGPT: $response_text"
}

function chat() {
    echo "Chat with ChatGPT."
    echo "Type 'exit' to quit."
    echo ""

    # Continuously prompt the user for input
    while true; do
        # Prompt the user for input
        read -p "You: " text

        # Exit if the user types 'exit'
        if [ "$text" == "exit" ]; then
            exit 0
        fi

        send_request $API_KEY $text
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

    send_request $API_KEY $question

    echo "Exiting..."
    exit 0
}

# check list of dependencies
DEPENDENCIES=$(cat dependencies.txt)
for dep in $DEPENDENCIES; do
    if ! [ -x "$(command -v $dep)" ]; then
        echo -e "${RED}Error: $BLUE$dep$NC is not installed." >&2
        echo -e "${GREEN}Install it with:$NC sudo apt install $BLUE$dep$NC" >&2
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
        -c | --chat) 	chat; exit 0;;
        -q | --question) shift; question $1; exit 0;;
		*) send_request $API_KEY $arg; exit 0;;
	esac

	# next arg
	shift
	arg=$1
done

# if no option is given, start chat
chat

echo "Exiting..."
exit 0