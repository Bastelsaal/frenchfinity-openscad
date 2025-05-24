#!/bin/bash

input_file="$1"
output_file="$2"

if [[ -z "$input_file" ]]; then
    echo "Usage: $0 input.scad [output/path/file.scad]"
    exit 1
fi

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

if [[ -z "$output_file" ]]; then
    output_file="${timestamp}_$(basename "$input_file")"
else
    output_dir=$(dirname "$output_file")
    output_name=$(basename "$output_file")
    output_file="${output_dir}/${timestamp}_${output_name}"
fi

mkdir -p "$(dirname "$output_file")"

process_file() {
    local file="$1"
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ include\ *\<(.+\.scad)\> ]]; then
            include_file="${BASH_REMATCH[1]}"

            if [[ "$include_file" == lib/BOSL2/* ]]; then
                echo "include <${include_file#lib/}>"
                continue
            fi

            if [[ "$include_file" == lib/* ]]; then
                echo "$line"
                continue
            fi

            echo "// >>> BEGIN include <$include_file>"
            process_file "$include_file"
            echo "// <<< END include <$include_file>"
        else
            echo "$line"
        fi
    done < "$file"
}

process_file "$input_file" > "$output_file"
