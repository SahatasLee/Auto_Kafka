#!/bin/bash
# Source the script containing the function
source ./fuc.sh

uat_folder="./uat/"

filename="KAFKATOPIC-"

new_topics_file() {
    folder="$1"
    env="$2"

    echo "$folder"
    echo $(get_latest_file_name "$folder")

    if [ -n $(get_latest_file_name "$folder") ]; then
        source_file="$folder/$(get_latest_file_name "$folder")"
        new_file "$source_file" "$filename" "$folder" "$env"
    else
        echo "No files found in folder: $folder"
    fi
}

# new_topics_file "$uat_folder" "uat"
new_topics_file "$dev_folder" "dev"