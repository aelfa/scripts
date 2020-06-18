#!/bin/bash
#####################################################
# script by ALPHA
#####################################################
PLEX_APPDATA [] {

    echo "The Path where Plex appdata is stored 
EXAMPLE: /opt/appdata OR 
        /pg/data
NOTE: Don't include the trailing /
EXAMPLE: /opt/appdata NOT /opt/appdata"

    read -p "Enter Plex Appdata Path:"  plex_appdata_path </dev/tty

}

while [[ ! -d "$plex_appdata_path/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" ]]; 

do echo "Plex appdata is not stored under $plex_appdata_path/ !" && PLEX_APPDATA 

done

sudo sqlite3 "$plex_appdata_path/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" "UPDATE metadata_items SET created_at = originally_available_at WHERE DATETIME(created_at) > DATETIME('now');" &&

sudo sqlite3 "$plex_appdata_path/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" "UPDATE metadata_items SET added_at = originally_available_at WHERE DATETIME(added_at) > DATETIME('now');"
