#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Copyright (c) 2021, MrDoob
# All rights reserved.

##usercheck
if [ "$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')" ]; then
    usermod -aG sudo "$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')"
    sudo usermod -s /bin/bash "$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')"
    sudo usermod -aG video "$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')"
    sudo usermod -aG docker "$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo " ✅ PASSED ! We found the user UID " "$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⌛ INFO ! "
    echo " ⌛ INFO ! Only lowercase and dont empty parts"
    echo " ⌛ INFO ! Enter a password (8+ chars)"
    echo " ⌛ INFO ! "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    read -rp "Enter username : " username
    read -s -rp "Enter password : " password
    echo ""
    $(which grep) -E "^$username" /etc/passwd >/dev/null
    pass=$(perl -e 'print crypt($ARGV[0], "password")' "$password")
    $(which useradd) -m -p "$pass" "$username"
    $(which usermod) -aG sudo "$username"
    $(which sudo) usermod -s /bin/bash "$username"
    $(which usermod) -aG video "$username"
    $(which usermod) -aG docker "$username"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ PASSED ! User has been added to system!"
    echo " ✅ PASSED ! Your Username : " "$username"
    echo " ✅ PASSED ! Your Password : " "$password"
    echo " ✅ PASSED ! "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
😂 What a Lame name: $(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
exit 0
