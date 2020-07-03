#!/bin/bash

sudo docker inspect plex | grep config:rw | sed 's/\"//g' | tr -d ' ' | sed 's/\:.*//g' 2>&1 | tee /tmp/plex.info
PLEX_ROOT="$(cat /tmp/plex.info)"
PLEX_PREFERENCES="${PLEX_ROOT}/Library/Application Support/Plex Media Server/Preferences.xml"
sudo cp -rv ${PLEX_PREFERENCES} /pg/data/uploader/