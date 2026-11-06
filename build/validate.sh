#!/bin/bash
#
# Renders every part of the generator with its default parameters and fails if a part does not
# render, prints a warning or an error.
#
# usage: build/validate.sh [--png] [file.scad] [-- extra OpenSCAD arguments]
#
#   file.scad   defaults to src/frenchfinity.scad, pass a merged file from dist/ to validate the
#               file that gets uploaded to MakerWorld
#   --png       also renders a preview image of every part
#
# The STL (and PNG) files are written to dist/validation/.
#

set -uo pipefail

cd "$(dirname "$0")/.."

render_png=false
input_file="src/frenchfinity.scad"
extra_arguments=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --png) render_png=true ;;
        --) shift; extra_arguments=("$@"); break ;;
        *) input_file="$1" ;;
    esac
    shift
done

output_directory="dist/validation"
mkdir -p "$output_directory"

# Merged files include <BOSL2/std.scad> like MakerWorld expects, so BOSL2 has to be on the library path.
export OPENSCADPATH="$PWD/lib${OPENSCADPATH:+:$OPENSCADPATH}"

# The manifold backend of newer OpenSCAD versions renders a lot faster than CGAL.
backend_arguments=()
if openscad --help 2>&1 | grep -q -- "--backend"; then
    backend_arguments=(--backend=manifold)
fi

# All part ids from the "feature" dropdown: feature = "..."; // [id:Label, id:Label]
features=$(grep -m 1 -E '^feature *=' "$input_file" | sed -E 's/.*\/\/ *\[(.*)\].*/\1/' | tr ',' '\n' | sed -E 's/:.*//; s/^ *//; s/ *$//')

failed=0

for feature in $features; do
    log_file="$output_directory/$feature.log"
    start=$(date +%s)

    openscad ${backend_arguments[@]+"${backend_arguments[@]}"} -o "$output_directory/$feature.stl" -D "feature=\"$feature\"" ${extra_arguments[@]+"${extra_arguments[@]}"} "$input_file" > "$log_file" 2>&1
    exit_code=$?
    seconds=$(( $(date +%s) - start ))

    if [[ $exit_code -ne 0 ]] || grep -q -E "WARNING|ERROR" "$log_file"; then
        echo "FAIL  $feature (${seconds}s)"
        grep -E "WARNING|ERROR" "$log_file" | head -5 | sed 's/^/      /'
        failed=$((failed + 1))
        continue
    fi

    file_name=$(grep -o 'filename proposal:", "[^"]*"' "$log_file" | sed -E 's/.*", "//; s/"$//')
    echo "OK    $feature (${seconds}s) $file_name"

    if $render_png; then
        openscad ${backend_arguments[@]+"${backend_arguments[@]}"} -o "$output_directory/$feature.png" --imgsize=800,600 \
            --viewall --autocenter --colorscheme=Tomorrow -D "feature=\"$feature\"" \
            ${extra_arguments[@]+"${extra_arguments[@]}"} "$input_file" > /dev/null 2>&1
    fi
done

if [[ $failed -gt 0 ]]; then
    echo "$failed part(s) failed."
    exit 1
fi

echo "All parts rendered."
