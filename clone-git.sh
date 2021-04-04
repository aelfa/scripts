#!/bin/bash
# Copyright (c) 2020, Aelfa
# All rights reserved.
# Useful script to clone & update git repos
REPO_PREFIX="https://github.com/"
REPO_BASE=/opt/data/repos # Edit this to change the base of your repos
read -rp 'Name of the repo | ⚠️ CASE SENSITIVE | [EXAMPLE:scripts]: ' GIT_REPO
REPO_NAME=${GIT_REPO}
clone () {
    read -rp 'Author of the repo | ⚠️ CASE SENSITIVE | [EXAMPLE:aelfa]: ' GIT_USER
    REPO_AUTHOR=${GIT_USER}
    REPO_LINK=${REPO_PREFIX}/${REPO_AUTHOR}/${REPO_NAME}.git
    sudo "$(command -v git)" clone --quiet "${REPO_LINK}" "${REPO_BASE}/${REPO_NAME}"
}

update() {
    sudo "$(command -v git)" -C "${REPO_PATH}" pull
    sudo "$(command -v git)" -C "${REPO_PATH}" fetch --all --prune
    sudo "$(command -v git)" -C "${REPO_PATH}" reset --hard HEAD
    sudo "$(command -v git)" -C "${REPO_PATH}" pull
}
permissions() {
    sudo "$(command -v chown)" -cR 1000:1000 "${REPO_PATH}" 1>/dev/null 2>&1
    sudo "$(command -v chmod)" -cR 755 "${REPO_PATH}" 1>/dev/null 2>&1
}
main () {
    GITHUB_REPO=${GIT_REPO}
    
    REPO_PATH=${REPO_BASE}/${REPO_NAME}
    if [[ ! -d "${REPO_BASE}/${REPO_NAME}/.git" ]]; then 
    clone && permissions
    else
    update && permissions
    fi
}
main
