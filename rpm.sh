#!/bin/bash
#####################################################
# script by ALPHA
#####################################################

#PLEX__APPDATA_PATH
PLEX_APPDATA_PATH [] {

    echo "The Path where Plex appdata is stored" 
    echo "EXAMPLE: /opt/appdata OR" 
    echo "/pg/data"
    echo "NOTE: Don't include the trailing /"
    echo "EXAMPLE: /opt/appdata NOT /opt/appdata"
read -p "Enter Plex Appdata Path:"  plex_appdata </dev/tty
}


#STOP ALL DOCKER CONTAINERS
sudo docker stop $(docker ps -a -q)


#ROOT PATH *ARR

    paths() { read -p "
Type old location for example if your movies were at /mnt/unionfs/movies just type movies: "  folder_path </dev/tty &&     read -p " type radarr or sonarr: " arr_name </dev/tty
}

paths

while [[ ! -d "/pg/unity/$folder_path" ]]; do 
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ Folder $folder_path does not Exist! "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && paths
done


sudo sqlite3 "/pg/data/$arr_name/$arr_name.db" "UPDATE RootFolders SET Path = '/pg/unity/$folder_path/' WHERE Path = '/mnt/unionfs/$folder_path/'"

#ROOT PATH PLEX
read -p 'Do you want to change Plex Library Paths | [Y/N]: '  typed </dev/tty

#CASE
case ${typed} in

    y|Y|yes|Yes|YES)
        CHANGEROOT=true
        ;;
    n|N|no|No|NO)
        CHANGEROOT=false
        ;;
    *)
        CHANGEROOT=false # default
        ;;

esac



if [ "${answer}" == "y" ] || [ "${answer}" == "Y" ] || [ "${answer}" == "yes" ] || [ "${answer}" == "Yes" ] || [ "${answer}" == "YES" ]; then
    CHANGEROOT=true
else
    CHANGEROOT=false
fi

if [ ${CHANGEROOT} ]; then
  PLEX__APPDATA_PATH;
while 
[[ ! -d "$plex_appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" ]]; do  
echo "Plex appdata is not stored under $plex_appdata/ !" && PLEX_APPDATA__PATH 
    sudo sqlite3 "$plex_appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" "UPDATE media_parts SET file= replace(file, '/mnt/unionfs/', '/pg/unity/') where file like '%/mnt/unionfs/%'" && echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ Library Paths Changed "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; 
done
else 
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ⚠️ Library Paths Unchanged "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
fi


#DOCKER START CONTAINERS
sudo docker start $(docker ps -a -q)


