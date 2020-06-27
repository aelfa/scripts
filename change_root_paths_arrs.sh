#!/bin/bash

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

#DOCKER START CONTAINERS
sudo docker start $(docker ps -a -q)


