#!/bin/bash
# Copyright (c) 2021, Aelfa
# All rights reserved.
# Useful script to clone & update git repos

# INFORMATION
    if [[ ! -x $(command -v git) ]];then sudo "$(command -v apt)" install git -yqq;fi
    REPO_URL="https://github.com"
    ## Edit this to change the base
    BASEDIR=/opt/.github
    read -erp "Owner of the github repository? " GITHUB_OWNER
    read -erp "Name of the repository to clone from? " GITHUB_REPO
    BASEDIR1=$BASEDIR/$GITHUB_OWNER/$GITHUB_REPO
    REPO_LINK=$REPO_URL/$GITHUB_OWNER/$GITHUB_REPO.git

# CLONE FUNCTION
clone () {
    sudo "$(command -v git)" clone --quiet "$REPO_LINK" "$BASEDIR1"
}

# UPDATE FUNCTION
update() {
    sudo "$(command -v git)" -C "$BASEDIR1" pull
    sudo "$(command -v git)" -C "$BASEDIR1" fetch --all --prune
    sudo "$(command -v git)" -C "$BASEDIR1" reset --hard HEAD
    sudo "$(command -v git)" -C "$BASEDIR1" pull
}

# PERMISSION FUNCTION
permissions() {
    sudo "$(command -v chown)" -cR 1000:1000 "$BASEDIR" 1>/dev/null 2>&1
    sudo "$(command -v chmod)" -cR 775 "$BASEDIR" 1>/dev/null 2>&1
}

# MAIN FUNCTION
run () {
    if [[ ! -d $BASEDIR ]];then sudo "$(command -v mkdir)" -p "$BASEDIR";fi
    if [[ ! -d $BASEDIR1/.git ]];then clone && permissions;else update && permissions;fi
}
run