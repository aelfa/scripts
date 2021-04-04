#!/bin/bash
# Copyright (c) 2020, Aelfa
# All rights reserved.
# Useful script to clone & update git repos
echo " ⚠️ This script assumes you have a base path set for your repos | [DEFAULT:/opt/data/repos] "
GITHUB_PREFIX=https://github.com
REPO_BASE=/opt/data/repos # Edit this to change the base of your repos
clone () {
    sudo "$(command -v git)" clone --quiet "${REPO_LINK}" "${REPO_BASE}"
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
    read -rp 'Name of the repo | ⚠️ CASE SENSITIVE | [EXAMPLE:scripts]: ' GIT_REPO
    REPO_PATH=${REPO_BASE/GITHUB_REPO}
    if [[ ! -d "{$REPO_BASE/$GITHUB_REPO}.git" ]]; then
    GITHUB_USER=${GIT_USER}
    read -rp 'Author of the repo | ⚠️ CASE SENSITIVE | [EXAMPLE:aelfa]: ' GIT_USER 
    REPO_LINK=${$GITHUB_PREFIX/$GITHUB_USER/$GITHUB_REPO}.git
    clone && permissions
    else
    update && permissions
    fi
}
main
