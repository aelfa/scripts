#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Copyright (c) 2020, MrDoob
# All rights reserved.

function sudocheck() {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  fi
}
function updateall() {
package_list="update upgrade dist-upgrade autoremove autoclean "
for i in ${package_list}; do
    sudo apt $i -yqq 1>/dev/null 2>&1
    echo "$i is running , please wait"
    sleep 1
done
## install pass
sudo apt install pass -yqq 1>/dev/null 2>&1
}
function hublogin() {
 clear
 echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 echo " ⌛ INFO ! "
 echo " ⌛ INFO ! Type your Docker Hub Username"
 echo " ⌛ INFO ! Type your Docker Hub passwort"
 echo " ⌛ INFO ! "
 echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 echo ""
 read -p "Enter username : " DOCKER_USER
 read -s -p "Enter password : " DOCKER_PASS
 sudo docker login --username=$DOCKER_USER --password=$DOCKER_PASS
 echo ""
 echo ""
 echo "Log-In Done"
}

sudocheck
updateall
hublogin
