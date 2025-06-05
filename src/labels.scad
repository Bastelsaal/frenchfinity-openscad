function hintFileName(labels) =
    let(flat = flattenLabels(labels),
        name = str("frenchfinity_", feature, "_", joinLabels(flat), ".stl"))
    echo("filename proposal:", name)
    flat;

function flattenLabels(arr) =
    [for (item = arr) 
        if (is_list(item)) str(joinLabels(item)) else item];

function joinLabels(labels, i = 0) =
    i >= len(labels)
        ? ""
        : str(labels[i], i < len(labels)-1 ? "_" : "", joinLabels(labels, i + 1));

module labelVertical (text, width_box, y, x = 0) {
    if (render_text) {
        y_rotation = x > 0 ? 180 : 0;
        
        translate([width_box, x, y])
            xrot(90)
            yrot(y_rotation)
                text3d(text, size=text_size, height=text_depth, anchor=CENTER);
    }
}