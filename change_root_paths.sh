#!/bin/bash
#####################################################
# script by ALPHA
#####################################################

#STOP ALL DOCKER CONTAINERS
sudo docker stop $(docker ps -a -q)


#ROOT PATH *ARR

    ARR_PATHS () { read -ep "
Type old location for example if your movies were at /mnt/unionfs/movies just type movies: "  folder_path && read -ep " type radarr or sonarr: " arr_name
}

ARR_PATHS

while [[ ! -d "/pg/unity/$folder_path" ]]; do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ Folder $folder_path does not Exist! "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && ARR_PATHS;
done


sudo sqlite3 "/pg/data/$arr_name/$arr_name.db" "UPDATE RootFolders SET Path = '/pg/unity/$folder_path/' WHERE Path = '/mnt/unionfs/$folder_path/'"

#ROOT PATH PLEX
PLEX_PATHS () {
sudo docker inspect plex | grep config:rw | sed 's/\"//g' | tr -d ' ' | sed 's/\:.*//g' 2>&1 | tee /tmp/plex.info
PLEX_ROOT=$(cat /tmp/plex.info)
PLEX_PREFERENCES=$(PLEX_APPDATA_ROOT)/Library/Application Support/Plex Media Server/Preferences.xml)
PLEX_DATABASE=$(PLEX_APPDATA_ROOT)/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db
}

read -ep 'Do you want to change Plex Library Paths | [Y/N]: '  answer

if 
    [ "${answer}" == "y" ] || [ "${answer}" == "Y" ] || [ "${answer}" == "yes" ] || [ "${answer}" == "Yes" ] || [ "${answer}" == "YES" ]; 
then
    [ PLEX_PATHS ] && [ sudo sqlite3 "${PLEX_DATABASE}" "UPDATE media_parts SET file= replace(file, '/mnt/unionfs/', '/pg/unity/') where file like '%/mnt/unionfs/%'" ] && 
    [
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ Library Paths Changed "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ]; 
else 
    [
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ Library Paths Unchanged "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ];
fi

#DOCKER START CONTAINERS
sudo docker start $(docker ps -a -q)


