#!/bin/bash
#####################################################
# script by ALPHA
#####################################################
PLEX_APPDATA_PATH [] {

    echo "The Path where Plex appdata is stored 
EXAMPLE: /opt/appdata OR 
        /pg/data
NOTE: Don't include the trailing /
EXAMPLE: /opt/appdata NOT /opt/appdata"

    read -p "Enter Plex Appdata Path:"  plex_appdata </dev/tty

}

while [[ ! -d "$plex_appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" ]]; 

do echo "Plex appdata is not stored under $plex_appdata/ !" && PLEX_APPDATA__PATH 

done

sudo sqlite3 "$plex_appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" "UPDATE metadata_items SET created_at = originally_available_at WHERE DATETIME(created_at) > DATETIME('now');" &&

sudo sqlite3 "$plex_appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" "UPDATE metadata_items SET added_at = originally_available_at WHERE DATETIME(added_at) > DATETIME('now');"
