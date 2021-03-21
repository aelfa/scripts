#!/bin/bash
sudocheck() {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  fi
if [[ ! -x $(command -v git) ]];then $(command -v apt) install git -yqq 1>/dev/null 2>&1;fi
}
clonetraefik() {
  if [[ ! -d "/opt/traefik" ]]; then
    sudo $(command -v git) clone --quiet https://github.com/doob187/Traefikv2 /opt/traefik
    sudo $(command -v chown) -cR 1000:1000 /opt/traefik/ 1>/dev/null 2>&1
    sudo $(command -v chmod) -cR 755 /opt/traefik 1>/dev/null 2>&1
    sudo $(command -v bash) /opt/traefik/install.sh
  else
    $(command -v git) -C "/opt/traefik" pull
    $(command -v git) -C "/opt/traefik" fetch --all --prune
    $(command -v git) -C "/opt/traefik" reset --hard origin/master
    $(command -v git) -C "/opt/traefik" pull
    sudo $(command -v bash) /opt/traefik/install.sh
  fi
}
cloneapps() {
  if [[ ! -d "/opt/apps" ]]; then
    sudo $(command -v git) clone --quiet https://github.com/doob187/traefikv2apps /opt/apps
    sudo $(command -v chown) -cR 1000:1000 /opt/apps/ 1>/dev/null 2>&1
    sudo $(command -v chmod) -cR 755 /opt/apps 1>/dev/null 2>&1
    sudo $(command -v bash) /opt/apps/install.sh
  else
    $(command -v git) -C "/opt/apps" pull
    $(command -v git) -C "/opt/apps" fetch --all --prune
    $(command -v git) -C "/opt/apps" reset --hard origin/master
    $(command -v git) -C "/opt/apps" pull
    sudo $(command -v bash) /opt/apps/install.sh
  fi
}
main () {
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                      🚀 Install doob187
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[1] Deploy Traefik + Authelia
[2] Install Apps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ EXIT ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -ep "Select option and press [ENTER]: " answer

if [[ ${answer} == "exit" || ${answer} == "Exit" || ${answer} == "EXIT" || ${answer}  == "z" || ${answer} == "Z" ]];then exit;fi
if [[ ${answer} == "" ]]; then sudocheck && main;fi
if [[ ${answer} == "1" ]];then sudocheck && clonetraefik && main;fi
if [[ ${answer} == "2" ]];then sudocheck && cloneapps && main;fi
}
main
