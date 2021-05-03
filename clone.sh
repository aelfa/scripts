#!/bin/bash
# Copyright (c) 2020, Aelfa
# All rights reserved.
# Useful script to clone & update git repos

# INFORMATION
    if [[ ! -x $(command -v git) ]];then sudo $(command -v apt) install git -yqq;fi
    REPO_PREFIX="https://github.com"
    ## Edit this to change the base
    REPO_BASE=/opt/data
    read -erp "ENTER GITHUB USER'S NAME: " GIT_USER
    read -erp "ENTER THE NAME OF USER'S REPO TO CLONE FROM: " GIT_REPO
    REPO_NAME=${GIT_REPO}
    REPO_OWNER=${GIT_USER}
    REPO_PATH=${REPO_BASE}/${REPO_OWNER}/${REPO_NAME}
    REPO_LINK=${REPO_PREFIX}/${REPO_OWNER}/${REPO_NAME}.git
    
# CLONE FUNCTION
clone () {
    sudo "$(command -v git)" clone --quiet "${REPO_LINK}" "${REPO_PATH}"
}

# UPDATE FUNCTION
update() {
    sudo "$(command -v git)" -C "${REPO_PATH}" pull
    sudo "$(command -v git)" -C "${REPO_PATH}" fetch --all --prune
    sudo "$(command -v git)" -C "${REPO_PATH}" reset --hard HEAD
    sudo "$(command -v git)" -C "${REPO_PATH}" pull
}

# PERMISSION FUNCTION
permissions() {
    sudo "$(command -v chown)" -cR 1000:1000 "${REPO_BASE}" 1>/dev/null 2>&1
    sudo "$(command -v chmod)" -cR 775 "${REPO_BASE}" 1>/dev/null 2>&1
}

# MAIN FUNCTION
main () {
    if [[ ! -d "${REPO_PATH}/.git" ]]; then 
    clone && permissions
    else
    update && permissions
    fi
}
main
