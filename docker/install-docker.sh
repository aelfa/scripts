#!/bin/bash

function startcommand() {
    # Check if Docker is installed
    docker=$(docker --version)
    if [[ "$docker" == "" ]]; then
        install_docker
    else
        update_docker
    fi
}

function update_docker() {
    tee <<-EOF
━━━━━━━━━━━━━━━━━━
[Y] UPDATE to latest version
[Z] Exit
━━━━━━━━━━━━━━━━━━
EOF
    read -p '↘️  Type Y or Z | Press [ENTER]: ' typed </dev/tty

    case $typed in
    Y) install_docker ;;
    y) install_docker ;;
    z) clear && exit ;;
    Z) clear && exit ;;
    *) badinput ;;
    esac
}

function install_docker() {
    # Check the OS version
    os=$(uname -s)
    if [ "$os" == "Linux" ]; then
        # Check the Linux distribution
        distro=$(lsb_release -i -s)
        if [ "$distro" == "Ubuntu" ]; then
            # Install Docker on Ubuntu
            sudo apt-get update
            sudo apt-get install -y docker.io
            sudo systemctl enable --now docker
            sudo systemctl status docker | awk '$1 == "Active:" {print $2,$3}'
        elif [ "$distro" == "CentOS" ]; then
            # Install Docker on CentOS
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce
            sudo systemctl enable --now docker
            sudo systemctl status docker | awk '$1 == "Active:" {print $2,$3}'
        else
            echo "This script does not support your Linux distribution."
            exit 1
        fi
    elif [ "$os" == "Darwin" ]; then
        # Install Docker on macOS
        brew install docker
    else
        echo "This script does not support your OS."
        exit 1
    fi

    # add current user to docker group so there is no need to use sudo when running docker
    sudo usermod -aG docker "$(whoami)"
    sudo id -nG
}

startcommand
