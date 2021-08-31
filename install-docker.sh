#!/bin/bash

function startcommand() {
docker=$(docker --version)
if [[ "$docker" == "" ]]; then
    install_docker
else
    reinstall_docker
fi
}

function reinstall_docker() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━
[Y] UPDATE to lateste version
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
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl https://raw.githubusercontent.com/docker/docker-install/master/install.sh | sudo bash
sudo systemctl enable --now docker
sudo systemctl status docker | awk '$1 == "Active:" {print $2,$3}'

# add current user to docker group so there is no need to use sudo when running docker
sudo usermod -aG docker "$(whoami)"
sudo id -nG
}

startcommand
#<EOF>#