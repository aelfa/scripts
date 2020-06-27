#!/bin/bash
#####################################################
# script by ALPHA
#####################################################

sudo docker inspect plex | grep config:rw | sed 's/\"//g' | tr -d ' ' | sed 's/\:.*//g' 2>&1 | tee /tmp/plex.info
PLEX_ROOT="$(cat /tmp/plex.info)"
PLEX_PREFERENCES="${PLEX_ROOT}/Library/Application Support/Plex Media Server/Preferences.xml"
PLEX_DATABASE="${PLEX_ROOT}/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"

read -ep 'Modify Plex Library Dates to Original | [Y/N]: '  answer

if 
    [ "${answer}" == "y" ] || [ "${answer}" == "Y" ] || [ "${answer}" == "yes" ] || [ "${answer}" == "Yes" ] || [ "${answer}" == "YES" ]; then
    [ sudo sqlite3 "${PLEX_DATABASE}" "UPDATE metadata_items SET created_at = originally_available_at WHERE DATETIME(created_at) > DATETIME('now');" ] && [ sudo sqlite3 "${PLEX_DATABASE}" "UPDATE metadata_items SET added_at = originally_available_at WHERE DATETIME(added_at) > DATETIME('now');" ] && 
    echo                                 
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ Library Dates Changed to Original "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; else
    echo 
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ No Changes Made "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
fi


