#!/bin/bash
#####################################################
# script by ALPHA
#####################################################

#####################################################

sudo docker stop $(docker ps -a -q)

paths() { read -p "
Type old location for example if your movies were at /mnt/unionfs/movies just type movies:"  folder_path </dev/tty && read -p " type radarr or sonarr: " arr_name </dev/tty
}

paths

while [[ ! -d "/pg/unity/$folder_path" ]]; 
do echo "folder $folder_path does not exist !" && paths 
done

sudo sqlite3 "/pg/data/$arr_name/$arr_name.db" "UPDATE RootFolders SET Path = '/pg/unity/$folder_path/' WHERE Path = '/mnt/unionfs/$folder_path/'"

read -p "Do you want to change the root paths for your Plex Libraries Y/N:" answer </dev/tty

if [[ $answer='Y' || $answer='y' ]];
then sudo sqlite3 "/pg/data/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" "UPDATE media_parts SET file= replace(file, '/mnt/unionfs/', '/pg/unity/') where file like '%/mnt/unionfs/%'"
elif [[ $answer='N' || $answer='n' ]]
then exit 
fi

