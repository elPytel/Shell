#!/bin/bash
# By Pytel
# Script for instalation of:
# Docker 

#DEBUG=true
DEBUG=false

BASEDIR=$(dirname "$0")     # adresa k tomuto skriptu
user=$(. $BASEDIR/get_curent_user.sh)
path="/home/$user"        	# cesta k /home/user

# colors
source $path/Shell/tools/colors.sh

# Help print
function printHelp () {
	echo -e "USE:"
	echo -e "  $(echo "$0" | tr "/" "\n" | tail -n 1) COMMANDs"
	echo ""
	echo -e "COMMANDs:"
	echo -e "  -h --help \t print this text"
	echo -e "  -d --debug\t enable debug output"
	echo -e "  -v --verbose\t enable vebrose mode"
    echo -e "  -i --install\t install docker"
    echo -e "  -u --uninstall uninstal docker"
    echo -e "  -D --desktop\t install docker desktop"
    echo -e "  -t --test \t run docker Hello World!"
}

# Installing dependencies
function installApps () { # ( class_name [app, ...] )
    local class_name="$1"
    shift
    local apps=$@

    # update
    sudo apt update

    # install
    $VERBOSE && echo "Installing ${Blue}$class_name${NC}:"
    for app in $apps; do
        $path/Shell/tools/install_app.sh $app || exit $?
    done
}

# installation
function install () { #(  )
    installApps "dependencies" $dependencies

    # install docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    $VERBOSE && echo $(apt-cache policy docker-ce)

    $path/Shell/tools/install_app.sh docker-ce
    $VERBOSE && echo $(sudo systemctl status docker)

    # install docker compose
    mkdir -p ~/.docker/cli-plugins/
    curl -SL $download_link_compose -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    $VERBOSE && echo $(docker compose version)

    # add user mode
    $VERBOSE && echo "Enable docker in user-mode."
    sudo groupadd docker || true
    sudo usermod -aG docker $user
    newgrp docker

    echo "Now idealy restart your pc (or relog-in)."
}

function installDesktop () { # (  )
    installApps "dependencies" $dependencies

    # Add Docker’s official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Use the following command to set up the repository:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    packages="docker-ce docker-ce-cli containerd.io docker-compose-plugin"
    installApps "docker packages" $packages

    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
}

function uninstall () { #(  )
    $VERBOSE && dpkg -l | grep -i docker

    $VERBOSE && echo "Uninstalling apps:"
    for app in $apps; do
        $VERBOSE && echo -e "App: ${Blue}$app${NC}"
        sudo apt-get purge -y $app
        sudo apt-get autoremove -y $app
	done
    
    $VERBOSE && echo "Removing file structures..."
    sudo groupdel docker
    sudo rm -rf /etc/docker || true
    sudo rm -rf /var/lib/docker || true
    sudo rm -rf /var/lib/containerd || true
    sudo rm -rf /var/run/docker.sock || true
    sudo rm /etc/apparmor.d/docker || true

    echo -e "Try to run: ${Blue}docker${NC}"
    echo $(docker || true)
    return 0
}

function testDocker () { #(  )
    docker run hello-world
}

download_link_compose="https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64"

dependencies="apt-transport-https curl ca-certificates software-properties-common gnupg lsb-release"
apps="docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin containerd.io"

$DEBUG && echo "Args: [$*]"

# input args
case $# in
	0) printHelp; exit 2;;
	*) arg=$1;;
esac

# parse input
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug)	DEBUG=true;;
		-v | --verbose)	VERBOSE=true;;
		-i | --install)	install || exit 3;;
		-u | --uninstall) uninstall || exit 4;;
        -D | --desktop) installDesktop || exit 5;;
        -t | --test)    testDocker || exit 6;;
		*) echo -e "Unknown parametr: $arg"; exit 1;;
	esac

	# next arg
	shift
	arg=$1
done

$VERBOSE && echo "Done"
exit 0
#END
