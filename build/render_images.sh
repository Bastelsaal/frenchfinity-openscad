#!/bin/bash
#
# Renders the images of the README into docs/images/:
#
#   parts/<id>.png  every part with its default parameters
#   parts.png       all parts in one image
#   wall.png        a wall anchor on a wooden cleat, with some holders slid in
#
# usage: build/render_images.sh [part id ...]
#
#   Without part ids every part is rendered. The overview and the wall are rendered every time.
#
# Needs OpenSCAD (a development snapshot with the Manifold backend is a lot faster) and ImageMagick 7.
#

set -euo pipefail

cd "$(dirname "$0")/.."

for tool in openscad magick; do
    if ! command -v "$tool" > /dev/null; then
        echo "$tool not found." >&2
        exit 1
    fi
done

export OPENSCADPATH="$PWD/lib${OPENSCADPATH:+:$OPENSCADPATH}"

backend_arguments=()
if openscad --help 2>&1 | grep -q -- "--backend"; then
    backend_arguments=(--backend=manifold)
fi

part_color="#ff0042"   # Frenchfinity red
anchor_color="#1c1c1e"
wall_color="#f4f1ec"
wood_color="#e3bd82"
background="#f8f8f8"   # background of the OpenSCAD color scheme "Tomorrow"
output_directory="docs/images"
work_directory=$(mktemp -d)
trap 'rm -rf "$work_directory"' EXIT

mkdir -p "$output_directory/parts"

# The generator as one file, without the last line that renders the selected part, so the scenes
# below can call the parts themselves.
merged=$(build/merge_openscad_files_to_master.sh src/frenchfinity.scad "$work_directory/frenchfinity.scad")
grep -v '^render_selected_feature();$' "$merged" > "$work_directory/generator.scad"

# All part ids from the "feature" dropdown, in the order of the dropdown.
all_features=$(grep -m 1 -E '^feature *=' src/frenchfinity.scad | sed -E 's/.*\/\/ *\[(.*)\].*/\1/' | tr ',' '\n' | sed -E 's/:.*//; s/^ *//; s/ *$//')
features=("$@")
if [[ ${#features[@]} -eq 0 ]]; then
    read -r -d '' -a features <<< "$all_features" || true
fi

# Camera: looking at the front of the part (the side facing the room) from the left and from above.
# Plates whose hooks or pins sit on their back are shown from behind.
camera_of() {
    case "$1" in
        ikea_skadis_plate | welding_table_plate)  echo "0,0,0,62,0,25,0" ;;
        letter)                                   echo "0,0,0,80,0,195,0" ;;
        gridfinity_adapter)                       echo "0,0,0,50,0,205,0" ;;
        *)                                        echo "0,0,0,62,0,205,0" ;;
    esac
}

# Renders a scene into a PNG, crops it to the content and fits it into width x height.
# usage: render_png <scene.scad> <output.png> <width> <height> <camera> [OpenSCAD arguments ...]
render_png() {
    local scene="$1" output="$2" width="$3" height="$4" camera="$5"
    shift 5

    if ! openscad ${backend_arguments[@]+"${backend_arguments[@]}"} -o "$work_directory/raw.png" \
        --imgsize=2400,1800 --viewall --autocenter --camera="$camera" --colorscheme=Tomorrow \
        "$@" "$scene" > "$work_directory/openscad.log" 2>&1; then
        cat "$work_directory/openscad.log" >&2
        exit 1
    fi

    magick "$work_directory/raw.png" -trim +repage \
        -resize "$((width * 88 / 100))x$((height * 88 / 100))" \
        -background "$background" -gravity center -extent "${width}x${height}" \
        +dither -colors 160 "$output"
}

cat > "$work_directory/part.scad" << EOF
include <$work_directory/generator.scad>

color("$part_color")
    render(convexity = 10)
        render_selected_feature();
EOF

for feature in "${features[@]}"; do
    render_png "$work_directory/part.scad" "$output_directory/parts/$feature.png" 640 480 \
        "$(camera_of "$feature")" -D "feature=\"$feature\""
    echo "$output_directory/parts/$feature.png"
done

# All parts in one image, in the order of the dropdown.
overview=()
for feature in $all_features; do
    if [[ ! -f "$output_directory/parts/$feature.png" ]]; then
        echo "Image of $feature is missing, render it first: $0 $feature" >&2
        exit 1
    fi

    overview+=("$output_directory/parts/$feature.png")
done

columns=9
rows=()
for ((i = 0; i < ${#overview[@]}; i += columns)); do
    rows+=("$work_directory/row_$i.png")
    magick "${overview[@]:i:columns}" -resize 300x225 -background "$background" +append "$work_directory/row_$i.png"
done

magick "${rows[@]}" -background "$background" -gravity center -append \
    +dither -colors 128 -strip "$output_directory/parts.png"
echo "$output_directory/parts.png"

# A wall anchor hooked onto a wooden cleat, with some holders slid into its slot. The holders hang
# with their top edge at the top edge of the anchor, like they do on a real wall.
cat > "$work_directory/wall.scad" << EOF
include <$work_directory/generator.scad>

// [width, top edge] of the holders, from left to right.
holders = [
    [bit_holder_width(), bit_holder_top()],
    [screw_driver_width(), screwdriver_height],
    [screw_driver_width(), screwdriver_height],
    [pliers_holder_width(), pliers_holder_top()],
    [box_outer_width(), box_top()],
    [hook_width, hook_height]
];

// The holders are spread evenly along the anchor.
holder_gap = (wall_anchor_width - ff_sum([for (holder = holders) holder[0]])) / (len(holders) + 1);

function holder_x(i) = i == 0 ? holder_gap : holder_x(i - 1) + holders[i - 1][0] + holder_gap;

module hang(i) {
    translate([holder_x(i), 0, wall_anchor_height - holders[i][1]])
        color("$part_color")
            render(convexity = 10)
                children();
}

// Wall and wooden cleat. The bevel of the cleat carries the bevel of the anchor.
color("$wall_color")
    translate([-30, -wall_anchor_depth - 12, -110])
        cube([wall_anchor_width + 60, 12, 190]);

color("$wood_color")
    translate([-30, 0, 0])
        ff_extrude_along_x(wall_anchor_width + 60)
            polygon([[-wall_anchor_depth, -70], [0, -70], [0, wall_anchor_depth], [-wall_anchor_depth, 0]]);

color("$anchor_color")
    render(convexity = 10)
        feature_wall_anchor();

hang(0) feature_bit_holder();
hang(1) feature_screw_driver();
hang(2) feature_screw_driver();
hang(3) feature_pliers_holder();
hang(4) feature_box();
hang(5) feature_hook();
EOF

render_png "$work_directory/wall.scad" "$output_directory/wall.png" 1600 900 "0,0,0,74,0,197,0" \
    -D 'wall_anchor_width = 280' -D 'render_text = false'
echo "$output_directory/wall.png"
