#!/bin/bash
#
# Merges an OpenSCAD file and every file it includes into a single file, e.g. for the MakerWorld
# customizer which only accepts one file. Includes of BOSL2 are kept, MakerWorld provides BOSL2.
#
# usage: merge_openscad_files_to_master.sh input.scad [output/path/file.scad]
#
# The output file name gets a timestamp prefix: output/path/2025-06-30_09-36-10_file.scad
#

set -euo pipefail

input_file="${1:-}"
output_file="${2:-}"

if [[ -z "$input_file" ]]; then
    echo "Usage: $0 input.scad [output/path/file.scad]"
    exit 1
fi

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

if [[ -z "$output_file" ]]; then
    output_file="${timestamp}_$(basename "$input_file")"
else
    output_file="$(dirname "$output_file")/${timestamp}_$(basename "$output_file")"
fi

mkdir -p "$(dirname "$output_file")"

# Prints a file, replacing every include with the content of the included file. Include paths are
# resolved relative to the including file, like OpenSCAD does.
process_file() {
    local file="$1"
    local directory
    directory="$(dirname "$file")"

    if [[ ! -f "$file" ]]; then
        echo "Included file not found: $file" >&2
        exit 1
    fi

    local include_pattern='^[[:space:]]*include[[:space:]]*<([^>]+\.scad)>'

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ $include_pattern ]]; then
            local include_file="${BASH_REMATCH[1]}"

            if [[ "$include_file" == *BOSL2/* ]]; then
                echo "include <BOSL2/${include_file#*BOSL2/}>"
                continue
            fi

            echo "// >>> BEGIN include <$include_file>"
            process_file "$directory/$include_file"
            echo "// <<< END include <$include_file>"
        else
            echo "$line"
        fi
    done < "$file"
}

process_file "$input_file" > "$output_file"

echo "$output_file"
