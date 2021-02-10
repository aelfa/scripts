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

function clone() {
    sudo rm -rf /opt/pgclone
    curl -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | sudo bash
    sudo docker volume create -d local-persist -o mountpoint=/mnt --name=unionfs 
    sudo git clone --quiet https://github.com/aelfa/pgclone.git /opt/pgclone
    sudo chown -cR 1000:1000 /opt/pgclone/ 1>/dev/null 2>&1
    sudo chmod -cR 755 /opt/pgclone >> /dev/null 1>/dev/null 2>&1
    sudo bash /opt/pgclone/pgclone.sh
}
sudocheck
clone
