get_latest_file_name() {
    folder_path="$1"

    # Check if the folder exists
    if [ ! -d "$folder_path" ]; then
        echo "Error: Folder '$folder_path' not found."
        return 1
    fi

    # Get the latest file using 'ls' with reverse sorting by modification time and then take the first line
    latest_file=$(ls -t "$folder_path" | head -n 1)

    echo "$latest_file"
}

new_file() {
    source_file="$1"
    filename="$2"
    folder="$3"
    env="$4"

    # Extract the number from the source filename
    number=$(echo "$source_file" | grep -oE '[0-9]+')

    # Check if the number extraction was successful
    if [[ -z "$number" ]]; then
        echo "Error: Failed to extract number from filename."
        exit 1
    fi

    # Increment the number
    new_number=$((number + 1))
    new_file="${filename}${new_number}.yml"

    content=$(new_content $env)

    echo -e $content > "$folder/$new_file"

    echo "Created new file at $folder: $new_file"
}

new_content() {
    env="$1"

    # Check if topics.txt exists
    if [ ! -f "topics.txt" ]; then
        echo "Error: File 'topics.txt' not found."
        exit 1
    fi

    new_content=""

    # Loop through each line in topics.txt
    while IFS= read -r topic || [[ -n "$topic" ]]; do
        # Check if the line is not empty
        if [ -n "$topic" ]; then
            # echo "Processing topic: $topic"
            
            # Read the YAML content
            new_content=$new_content"apiVersion: kafka.strimzi.io/v1beta2\nkind: KafkaTopic\nmetadata:\n\tname: $topic\n\tlabels:\n\t\tstrimzi.io/cluster: kafka-cluster-$env\nspec:\n\tpartitions: 3\n\treplicas: 3\n\tconfig:\n\t\tretention.ms: 604800000\n\t\tcleanup.policy: compact,delete\n\t\tcompression.type: zstd\n---\n"

        fi
    done < "topics.txt"

    # Output the modified YAML content
    echo "$new_content"
}