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
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ Saying no to this option will only clone & install Traefikv2 with Authelia "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -ep 'Would you like to install traefikv2apps | [Y/N]: ' answer
if 
    [ "${answer}" == "y" ] || [ "${answer}" == "Y" ] || [ "${answer}" == "yes" ] || [ "${answer}" == "Yes" ] || [ "${answer}" == "YES" ]; then
sudocheck
clonetraefik
cloneapps; else
sudocheck
clonetraefik
fi
}
main
