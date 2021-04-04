#!/bin/bash
# Copyright (c) 2020, Aelfa
# All rights reserved.
# Useful script to update already cloned git repos

paths() {
    read  -r -ep 'ENTER repo location | [EXAMPLE:/opt/scripts/test]: ' repo_path
    if [[ ! -f "${repo_path}/.git" ]]; then
    echo " ⚠️ ${repo_path} is not a git repo location " && paths;
    fi
}

update() {
    sudo "$(command -v git)" -C "${repo_path}" pull
    sudo "$(command -v git)" -C "${repo_path}" fetch --all --prune
    sudo "$(command -v git)" -C "${repo_path}" reset --hard HEAD
    sudo "$(command -v git)" -C "${repo_path}" pull
}
paths
update
