#!/bin/bash
# Copyright (c) 2021, Aelfa
# All rights reserved.
# Useful script to update already cloned git repos

path() {
    read -r -ep 'LOCATION TO YOUR GIT REPO: ' repo_path
    if [[ ! -d "${repo_path}/.git" ]]; then
    echo " ⚠️ ${repo_path} IS NOT A GIT REPO " && path;
    fi
}

update() {
    sudo "$(command -v git)" -C "${repo_path}" pull
    sudo "$(command -v git)" -C "${repo_path}" fetch --all --prune
    sudo "$(command -v git)" -C "${repo_path}" reset --hard HEAD
    sudo "$(command -v git)" -C "${repo_path}" pull
}
permissions() {
    sudo "$(command -v chown)" -cR 1000:1000 "${repo_path}" 1>/dev/null 2>&1
    sudo "$(command -v chmod)" -cR 755 "${repo_path}" 1>/dev/null 2>&1
}
path
update
permissions
