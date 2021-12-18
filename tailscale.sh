#!/bin/bash
# shellcheck shell=bash
# Copyright (c) 2021, Aelfa
# All rights reserved.
TS_KEY=YOUR_TS_KEY
if [[ ! -x $(command -v tailscale) ]]; then
    "$(command -v curl)" -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
    "$(command -v curl)" -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list
    "$(command -v apt)" update && "$(command -v apt)" install tailscale -yy
    "$(command -v tailscale)" up --authkey ${TS_KEY} --advertise-exit-node --accept-dns=false
fi
