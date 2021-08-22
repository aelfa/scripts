#!/bin/bash

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " STOPPING ALL DOCKER CONTAINERS "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && sudo docker stop $(docker ps -a -q)

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ Strictly follow the EXAMPLE format while typing your paths "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

MERGERFS_PATH () {
    read -ep 'OLD MERGERFS DIRECTORY | [EXAMPLE:/mnt/unionfs]: ' OLD_MERGERFS_LOCATION
    read -ep 'NEW MERGERFS DIRECTORY | [EXAMPLE:/pg/unity]: ' NEW_MERGERFS_LOCATION
if [[ ! -d "${NEW_MERGERFS_LOCATION}" ]]; then
    echo " ⚠️ ${NEW_MERGERFS_LOCATION} is not a valid mergerfs path " && MERGERFS_PATH;
fi
}


ARR_PATHS () {
    read -ep 'MEDIA FOLDER NAME | [EXAMPLE:movies or tv]: '  MEDIA_LOCATION
    read -ep 'ARR NAME | [EXAMPLE:sonarr or radarr]: ' ARR_NAME
    read -ep 'APPDATA LOCATION | [EXAMPLE:/pg/data or /opt/appdata]: ' APPDATA_LOCATION
if [[ ! -d "${NEW_MERGERFS_LOCATION}/${MEDIA_LOCATION}/" ]]; then
    echo " ⚠️ ${NEW_MERGERFS_LOCATION}/${MEDIA_LOCATION}/ is not a valid path " && ARR_PATHS;
fi
}


read -ep 'Do you want to change root paths for your Arrs | [Y/N]: ' answer
if
    [ "${answer}" == "y" ] || [ "${answer}" == "Y" ] || [ "${answer}" == "yes" ] || [ "${answer}" == "Yes" ] || [ "${answer}" == "YES" ]; then
    MERGERFS_PATH
    ARR_PATHS
sudo sqlite3 "${APPDATA_LOCATION}/${ARR_NAME}/${ARR_NAME}.db" "UPDATE RootFolders SET Path = '${NEW_MERGERFS_LOCATION}/${MEDIA_LOCATION}/' WHERE Path = '${OLD_MERGERFS_LOCATION}/${MEDIA_LOCATION}/'" &&
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ Database Paths Changed "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" || echo " ⚠️ Failed to change Database paths."; else
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ No Changes Made "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " STARTING ALL DOCKER CONTAINERS "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && sudo docker start $(docker ps -a -q)