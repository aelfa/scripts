#!/bin/bash
function sudocheck () {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  fi
}
function clonetraefik () {
      if [[ ! -d "/opt/traefik" ]]; then
            sudo apt install git -yy
            sudo git clone --quiet https://github.com/doob187/Traefikv2 /opt/traefik
            sudo chown -cR 1000:1000 /opt/traefik/ 1>/dev/null 2>&1
            sudo chmod -cR 755 /opt/traefik >> /dev/null 1>/dev/null 2>&1
            sudo bash /opt/traefik/install.sh
    else
        git -C "/opt/traefik" pull
        git -C "/opt/traefik" fetch --all --prune
        git -C "/opt/traefik" reset --hard origin/master
        git -C "/opt/traefik" pull
        sudo bash /opt/traefik/install.sh
    fi
}
function cloneapps () {
  if [[ ! -d "/opt/apps" ]]; then
    sudo git clone --quiet https://github.com/doob187/traefikv2apps /opt/apps
    sudo chown -cR 1000:1000 /opt/apps/ 1>/dev/null 2>&1
    sudo chmod -cR 755 /opt/apps >> /dev/null 1>/dev/null 2>&1
    sudo bash /opt/apps/install.sh 
  else
        git -C "/opt/apps" pull
        git -C "/opt/apps" fetch --all --prune
        git -C "/opt/apps" reset --hard origin/master
        git -C "/opt/apps" pull
        sudo bash /opt/apps/install.sh
  fi
}
function main () {
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
read -ep 'Select option and press [ENTER]: ' answer
if [[ ${answer} == "exit" || ${answer} == "Exit" || ${answer} == "EXIT" || ${answer}  == "z" || ${answer} == "Z" ]];then exit;fi
if 
    [ "${answer}" == "1" ]; then
sudocheck
clonetraefik
elif [[ "${answer}" == "2" ]]; then 
sudocheck
cloneapps
fi
}
main
