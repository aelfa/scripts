#!/bin/bash
#####################################################
# script by pho
#####################################################

# basic settings
BASEDIR=/mnt/downloads                         # edit this to change the base
TARGET_FOLDER="$BASEDIR/{sabnzbd,nzbget,nzb}/" # find files in this folders
FIND_SAMPLE_SIZE='100M'                        # files smaller then this are seen as samples and get deleted

# advanced settings
FIND=$(which find)
FIND_BASE_CONDITION_WANTED='-type f -amin +600'
FIND_BASE_CONDITION_UNWANTED='-type f'
FIND_ADD_NAME='-o -iname'
FIND_DEL_NAME='! -iname'
FIND_ACTION='-not -path "*_UNPACK_*" -delete > /dev/null 2>&1'
command="${FIND} ${TARGET_FOLDER} -mindepth 1 ${FIND_BASE_CONDITION_WANTED} -size -${FIND_SAMPLE_SIZE} ${FIND_ACTION}"
#echo "Executing ${command}"
eval "${command}"

WANTED_FILES=(
    '*.mkv'
    '*.mpg'
    '*.mpeg'
    '*.avi'
    '*.mp4'
    '*.mp3'
    '*.flac'
    '*.srt'
    '*.idx'
    '*.sub'
)
UNWANTED_FILES=(
    '*.nfo'
    '*.jpeg'
    '*.jpg'
    '*.gif'
    '*.rar'
    '*sample.*'
    '*.sh'
    '*.pdf'
    '*.doc'
    '*.docx'
    '*.xls'
    '*.xlsx'
    '*.xml'
    '*.html'
    '*.htm'
    '*.exe'
    '*.nzb'
)
#Folder Setting
condition="-iname '${UNWANTED_FILES[0]}'"
for ((i = 1; i < ${#UNWANTED_FILES[@]}; i++)); do
    condition="${condition} ${FIND_ADD_NAME} '${UNWANTED_FILES[i]}'"
done
command="${FIND} ${TARGET_FOLDER} -mindepth 1 ${FIND_BASE_CONDITION_UNWANTED} \( ${condition} \) ${FIND_ACTION}"
#echo "Executing ${command}"
eval "${command}"

for ((i = 0; i < ${#WANTED_FILES[@]} - 1; i++)); do
    condition2="${condition2} ${FIND_DEL_NAME} '${WANTED_FILES[i]}'"
done
command="${FIND} ${TARGET_FOLDER} -mindepth 1 ${FIND_BASE_CONDITION_WANTED} \( ${condition2} \) ${FIND_ACTION}"
#echo "Executing ${command}"
eval "${command}"

command="${FIND} ${TARGET_FOLDER} -mindepth 1 -type d -empty ${FIND_ACTION}"
#echo "Executing ${command}"
eval "${command}"
