#!/bin/bash

# check for ip changes with cron
# crontab -e, please don't use sudo crontab -e
# check for ip changes every 5 minutes
# */5 * * * * /usr/bin/bash "/home/YOUR_USER/change_ip.sh" >> /home/YOUR_USER/cron.log
# or daily
# @daily /usr/bin/bash "/home/YOUR_USER/change_ip.sh" >> /home/YOUR_USER/cron.log

cloud_provider=oci # replace with the appropriate cloud provider 

if [[ $EUID == 0 ]]; then
  echo "You must execute as a user or as root, please don't use sudo"
  exit 0
fi

log_file="$HOME/ips.txt"
tf_vars_file="$HOME/cloudblock/$cloud_provider/$cloud_provider.tfvars"

current_ipv4="$(dig +short myip.opendns.com @resolver1.opendns.com)"
last_ipv4="$(tail -1 "$log_file" | awk -F, '{print $2}')"

if [ "$current_ipv4" = "$last_ipv4" ]; then
  echo "IP has not changed ($current_ipv4)"
else
  echo "IP has changed: $current_ipv4"
  echo "$(date),$current_ipv4" >>"$log_file"
  sed -i "s#^mgmt_cidr = .*#mgmt_cidr = \"$current_ipv4/32\"#" "$tf_vars_file"
  cd "$HOME/cloudblock/$cloud_provider" && terraform apply -auto-approve -var-file="$cloud_provider.tfvars"
fi
