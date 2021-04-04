#!/bin/bash
# Copyright (c) 2020, Aelfa
# All rights reserved.
# Useful script to clone & update git repos

# INFORMATION
    REPO_PREFIX="https://github.com"
    REPO_BASE=/opt/data # Edit this to change the base of your repos
    echo " ⚠️ The script assumes the repos are located in a base location "
    read -rp 'Author of the repo | ⚠️ CASE SENSITIVE | [EXAMPLE:aelfa]: ' GIT_USER
    read -rp 'Name of the repo | ⚠️ CASE SENSITIVE | [EXAMPLE:scripts]: ' GIT_REPO
    REPO_NAME=${GIT_REPO}
    REPO_AUTHOR=${GIT_USER}
    REPO_PATH=${REPO_BASE}/${REPO_AUTHOR}/${REPO_NAME}
    REPO_LINK=${REPO_PREFIX}/${REPO_AUTHOR}/${REPO_NAME}.git
    
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
