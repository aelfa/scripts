#!/bin/bash
#####################################################
# script by ALPHA
#####################################################

sudo docker stop sonarr && sudo docker stop radarr

paths() { read -p "
Type old location for example if your movies were at /mnt/unionfs/movies just type movies:"  folder_path </dev/tty && read -p " type radarr or sonarr: " arr_name </dev/tty
}
paths

while [[ ! -d "/pg/unity/$folder_path" ]]; 
do echo "folder $folder_path does not exist !" && paths 
done

sudo sqlite3 "/pg/data/$arr_name/$arr_name.db" "UPDATE RootFolders SET Path = '/pg/unity/$folder_path/' WHERE Path = '/mnt/unionfs/$folder_path/'"

sudo docker start sonarr && sudo docker start radarr