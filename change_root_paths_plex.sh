#!/bin/bash

MERGERFS_PATH () {
    read -ep 'OLD MERGERFS DIRECTORY | [EXAMPLE:/mnt/unionfs/]: ' OLD_MERGERFS_LOCATION
    read -ep 'NEW MERGERFS DIRECTORY | [EXAMPLE:/pg/unity/]: ' NEW_MERGERFS_LOCATION
    if [[ ! -d "${NEW_MERGERFS_LOCATION}" ]]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ ${NEW_MERGERFS_LOCATION} is not a valid mergerfs path "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" || [ MERGERFS_PATH ];
done
}

PLEX_PATHS () {
sudo docker inspect plex | grep config:rw | sed 's/\"//g' | tr -d ' ' | sed 's/\:.*//g' 2>&1 | tee /tmp/plex.info
PLEX_ROOT="$(cat /tmp/plex.info)"
PLEX_PREFERENCES="${PLEX_ROOT}/Library/Application Support/Plex Media Server/Preferences.xml"
PLEX_DATABASE="${PLEX_ROOT}/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"
}

read -ep 'Do you want to change Plex Library Paths | [Y/N]: '  answer

if 
    [ "${answer}" == "y" ] || [ "${answer}" == "Y" ] || [ "${answer}" == "yes" ] || [ "${answer}" == "Yes" ] || [ "${answer}" == "YES" ]; then
    PLEX_PATHS
    sudo docker stop plex
    MERGERFS_PATHS
    sudo sqlite3 "${PLEX_DATABASE}" "UPDATE media_parts SET file= replace(file, '${OLD_MERGERFS_LOCATION}', '${NEW_MERGERFS_LOCATION}') where file like '%${OLD_MERGERFS_LOCATION}%'" &&
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ Library Paths Changed "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; else 
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ Library Paths Unchanged "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
fi
sudo docker start plex