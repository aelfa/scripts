#!/bin/bash
# Author: Aelfa
# Description: Useful script to clone & update git repos

# User/Group Information
readonly DETECTED_PUID=${SUDO_UID:-$UID}
readonly DETECTED_UNAME=$(id -un "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_PGID=$(id -g "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_UGROUP=$(id -gn "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_HOMEDIR=$(eval echo "~${DETECTED_UNAME}" 2>/dev/null || true)

# INFORMATION
if [[ ! -x $(which git) ]]; then sudo "$(which apt)" install git -yqq; fi
REPO_URL="https://github.com"
BASEDIR=/opt/.github # edit this to change the base directory
read -erp "Owner of the github repository? " GITHUB_OWNER
read -erp "Name of the repository to clone from? " GITHUB_REPO
BASEDIR1=$BASEDIR/$GITHUB_OWNER-$GITHUB_REPO
REPO_LINK=$REPO_URL/$GITHUB_OWNER/$GITHUB_REPO.git

# CLONE FUNCTION
clone() {
    sudo "$(which git)" clone --quiet "$REPO_LINK" "$BASEDIR1"
}

# UPDATE FUNCTION
update() {
    sudo "$(which git)" -C "$BASEDIR1" pull
    sudo "$(which git)" -C "$BASEDIR1" fetch --all --prune
    sudo "$(which git)" -C "$BASEDIR1" reset --hard HEAD
    sudo "$(which git)" -C "$BASEDIR1" pull
}

# PERMISSION FUNCTION
permissions() {
    "$(which chown)" -R "${DETECTED_PUID}":"${DETECTED_PGID}" "$BASEDIR" 1>/dev/null 2>&1
    "$(which chmod)" -R 775 "$BASEDIR" 1>/dev/null 2>&1
}

# MAIN FUNCTION
run() {
    if [[ ! -d $BASEDIR ]]; then sudo "$(which mkdir)" -p "$BASEDIR"; fi
    if [[ ! -d $BASEDIR1/.git ]]; then clone && permissions; fi
    if [[ -d $BASEDIR1/.git ]]; then update && permissions; fi
}
run
