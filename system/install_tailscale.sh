#!/bin/bash
# shellcheck shell=bash
# Copyright (c) 2021, Aelfa
# All rights reserved.
TS_KEY=YOUR_TS_KEY
if [[ ! -x $(which tailscale) ]]; then
    "$(which curl)" -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
    "$(which curl)" -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list
    "$(which apt)" update && "$(which apt)" install tailscale -yy
    "$(which tailscale)" up --authkey ${TS_KEY} --advertise-exit-node --accept-dns=false
fi
