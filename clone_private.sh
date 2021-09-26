#!/bin/bash
# Author: Aelfa
# Description: Useful script to clone & update private git repos

# User/Group Information
readonly DETECTED_PUID=${SUDO_UID:-$UID}
readonly DETECTED_UNAME=$(id -un "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_PGID=$(id -g "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_UGROUP=$(id -gn "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_HOMEDIR=$(eval echo "~${DETECTED_UNAME}" 2>/dev/null || true)

# INFORMATION
if [[ ! -x $(command -v git) ]]; then sudo "$(command -v apt)" install git -yqq; fi
REPO_URL="git@github.com"
BASEDIR=/opt/.github/$GITHUB_REPO # edit this to change the base directory
read -erp "Owner of the github repository? " GITHUB_OWNER
read -erp "Name of the repository to clone from? " GITHUB_REPO
REPO_LINK=$REPO_URL:$GITHUB_OWNER/$GITHUB_REPO.git

# CLONE FUNCTION
clone() {
    eval "$(ssh-agent -s)"
    ssh-add "${DETECTED_HOMEDIR}/.ssh/id_ecdsa"
    "$(command -v git)" clone --quiet "$REPO_LINK" "$BASEDIR"
}

# UPDATE FUNCTION
update() {
    eval "$(ssh-agent -s)"
    ssh-add "${DETECTED_HOMEDIR}/.ssh/id_ecdsa"
    "$(command -v git)" -C "$BASEDIR" pull
    "$(command -v git)" -C "$BASEDIR" fetch --all --prune
    "$(command -v git)" -C "$BASEDIR" reset --hard HEAD
    "$(command -v git)" -C "$BASEDIR" pull
}
# PERMISSION FUNCTION
permissions() {
    "$(command -v chown)" -R "${DETECTED_PUID}":"${DETECTED_PGID}" "$BASEDIR" 1>/dev/null 2>&1
    "$(command -v chmod)" -R 775 "$BASEDIR" 1>/dev/null 2>&1
}

# MAIN FUNCTION
run() {
    if [[ ! -d $BASEDIR ]]; then "$(command -v mkdir)" -p "$BASEDIR"; fi
    if [[ ! -d $BASEDIR/.git ]]; then clone && permissions; else update && permissions; fi
}
if [[ ! -f $SSH_BASE/id_ecdsa ]]; then ssh_add && echo " Please add your ssh keys and restart the process " && exit; fi
run
