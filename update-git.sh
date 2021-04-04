# shellcheck shell=bash
# Copyright (c) 2020, Aelfa
# All rights reserved.
# shellcheck disable=SC2086
# shellcheck disable=SC2006
# Useful script to update already cloned git repos
update () {
read -ep "Destination containing git repo to update [ENTER]: " answer  
    $(command -v git) -C "${answer}" pull
    $(command -v git) -C "${answer}" fetch --all --prune
    $(command -v git) -C "${answer}" reset --hard origin/master
    $(command -v git) -C "${answer}" pull
    sudo "$(command -v chown)" -cR 1000:1000 "${answer}" 1>/dev/null 2>&1
    sudo "$(command -v chmod)" -cR 755 "${answer}" 1>/dev/null 2>&1 
 }
update
