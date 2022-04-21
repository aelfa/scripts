#!/bin/bash
# Author: Aelfa
# Run every 5 minutes with cron
# check for ip changes every 5 minutes
# crontab -e, please don't use sudo crontab -e
# */5 * * * * /usr/bin/bash "/home/YOUR_USER/change_ip.sh" >> /home/YOUR_USER/cron.log

cloudprovider=oci #type the name to your cloudprovider example azure, aws, oci

if [[ $EUID == 0 ]]; then
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          ⛔  You must execute as a user or as root, please don't use sudo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  exit 0
fi

############################# SYSTEM INFORMATION #######################
readonly DETECTED_PUID=${SUDO_UID:-$UID}
readonly DETECTED_UNAME=$(id -un "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_HOMEDIR=$(eval echo "~${DETECTED_UNAME}" 2>/dev/null || true)
LOG_FILE="$DETECTED_HOMEDIR/ips.txt"
BASEDIR="$DETECTED_HOMEDIR/cloudblock/$cloudprovider"
BASEFILE="$BASEDIR/$cloudprovider.tfvars"
########################################################################

CURRENT_IPV4="$(dig +short myip.opendns.com @resolver1.opendns.com)"
LAST_IPV4="$(tail -1 "$LOG_FILE" | awk -F, '{print $2}')"

if [ "$CURRENT_IPV4" = "$LAST_IPV4" ]; then
  echo "IP has not changed ($CURRENT_IPV4)"
else
  echo "IP has changed: $CURRENT_IPV4"
  echo "$(date),$CURRENT_IPV4" >>"$LOG_FILE"
  sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"$CURRENT_IPV4/32\"#" "$BASEFILE"
  cd "$BASEDIR" && terraform apply -auto-approve -var-file="$cloudprovider.tfvars"
fi
#EOF
