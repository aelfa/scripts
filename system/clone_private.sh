#!/bin/bash
# Author: Aelfa
# Description: Useful script to clone & update private git repos
# Please note this script assumes your key is named id_ecdsa and added to your ssh directory and github.

# User/Group Information
readonly DETECTED_PUID=${SUDO_UID:-$UID}
readonly DETECTED_UNAME=$(id -un "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_PGID=$(id -g "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_UGROUP=$(id -gn "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_HOMEDIR=$(eval echo "~${DETECTED_UNAME}" 2>/dev/null || true)
SSH_BASE="${DETECTED_HOMEDIR}"/.ssh

# INFORMATION
if [[ ! -x $(which git) ]]; then sudo "$(which apt)" install git -yqq; fi
REPO_URL="git@github.com"
read -erp "Owner of the github repository? " GITHUB_OWNER
read -erp "Name of the repository to clone from? " GITHUB_REPO
BASEDIR=/opt/.github/${GITHUB_REPO} # edit this to change the base directory
REPO_LINK=$REPO_URL:$GITHUB_OWNER/$GITHUB_REPO.git

# CLONE FUNCTION
clone() {
  eval "$(ssh-agent -s)"
  ssh-add "${DETECTED_HOMEDIR}/.ssh/id_ecdsa"
  "$(which git)" clone --quiet "$REPO_LINK" "$BASEDIR"
}

# UPDATE FUNCTION
update() {
  eval "$(ssh-agent -s)"
  ssh-add "${DETECTED_HOMEDIR}/.ssh/id_ecdsa"
  "$(which git)" -C "$BASEDIR" pull
  "$(which git)" -C "$BASEDIR" fetch --all --prune
  "$(which git)" -C "$BASEDIR" reset --hard HEAD
  "$(which git)" -C "$BASEDIR" pull
}
# PERMISSION FUNCTION
permissions() {
  "$(which chown)" -R "${DETECTED_PUID}":"${DETECTED_PGID}" "$BASEDIR" 1>/dev/null 2>&1
  "$(which chmod)" -R 775 "$BASEDIR" 1>/dev/null 2>&1
}

ssh_add() {
  if [[ ! -d "$SSH_BASE" ]]; then
    mkdir "$SSH_BASE"
    chmod 700 "$SSH_BASE"
    touch "$SSH_BASE"/authorized_keys
    chmod 600 "$SSH_BASE"/authorized_keys
    chown -R "${DETECTED_PUID}":"${DETECTED_PGID}" "$SSH_BASE"
  else
    echo " ssh directroy exists "
  fi
}

# MAIN FUNCTION
run() {
  if [[ ! -f $SSH_BASE/id_ecdsa ]]; then ssh_add && echo " Please add your ssh keys and restart the process " && exit; fi
  if [[ ! -d $BASEDIR ]]; then "$(which mkdir)" -p "$BASEDIR"; fi
  if [[ ! -d $BASEDIR/.git ]]; then clone && permissions; else update && permissions; fi
}
run
