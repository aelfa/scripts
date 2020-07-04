#!/bin/sh
# Get the contents of the Preferences file, keep only what we need,  push to a temp, then use it in the curl command

OPTIMIZE_PLEX () {
sudo "${PLEX_PREFERENCES}" |  \
sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1 > /tmp/plex.tmp

curl --request PUT http://127.0.0.1:32400/library/optimize\?async=1\&X-Plex-Token=`cat /tmp/plex.tmp`

rm -f /tmp/plex.tmp
}
PLEX_PATHS () {
sudo docker inspect plex | grep config:rw | sed 's/\"//g' | tr -d ' ' | sed 's/\:.*//g' 2>&1 | tee /tmp/plex.info
PLEX_ROOT="$(cat /tmp/plex.info)"
PLEX_PREFERENCES="${PLEX_ROOT}/Library/Application Support/Plex Media Server/Preferences.xml"
}

PLEX_PATHS
OPTIMIZE_PLEX
rm -f /tmp/plex.info
