#!/bin/bash
# Copyright (c) 2021, Aelfa
# All rights reserved.
# Useful script to clone & update git repos

# INFORMATION
    if [[ ! -x $(command -v git) ]];then sudo "$(command -v apt)" install git -yqq;fi
    rp="https://github.com"
    ## Edit this to change the base
    storage=/opt/data
    read -erp "Owner of the github repository? " gu
    read -erp "Name of the repository to clone from? " gr
    rn=${gr}
    ro=${gu}
    rp=${storage}/${ro}/${rn}
    rl=${rp}/${ro}/${rn}.git

# CLONE FUNCTION
clone () {
    sudo "$(command -v git)" clone --quiet "${rl}" "${rp}"
}

# UPDATE FUNCTION
update() {
    sudo "$(command -v git)" -C "${rp}" pull
    sudo "$(command -v git)" -C "${rp}" fetch --all --prune
    sudo "$(command -v git)" -C "${rp}" reset --hard HEAD
    sudo "$(command -v git)" -C "${rp}" pull
}

# PERMISSION FUNCTION
permissions() {
    sudo "$(command -v chown)" -cR 1000:1000 "${storage}" 1>/dev/null 2>&1
    sudo "$(command -v chmod)" -cR 775 "${storage}" 1>/dev/null 2>&1
}

# MAIN FUNCTION
run () {
    if [[ ! -d "${rp}/.git" ]];then clone && permissions;else update && permissions;fi
}
run