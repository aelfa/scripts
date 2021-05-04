#!/bin/bash
# shellcheck shell=bash
# Copyright (c) 2021, Aelfa
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
