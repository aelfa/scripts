#!/bin/bash

function dockerprune() {

    echo "This script will remove all unused containers, networks, volumes, images and build cache."
    echo "Are you sure you want to continue? [Y/N]"
    read -r answer

    if [[ "$answer" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        # check if Docker is installed
        if command -v docker >/dev/null 2>&1; then
            sudo "$(which docker)" system prune -a --volumes --force
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "✅ Prune Completed Successfully"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        else
            echo "Docker is not installed on this machine. Please install Docker and try again."
            exit 1
        fi
    else
        echo "Aborting Docker Prune."
    fi
}
dockerprune
