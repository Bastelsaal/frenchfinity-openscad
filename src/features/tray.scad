//
// Tray
//
// An open tray with rounded corners for small parts (contributed by JGoodwillieV). All sizes are
// outer sizes, the walls and the floor are tray_wall_thickness thick. The tongue is centered on the
// back wall and a third of the tray wide (at least 40 mm, at most 100 mm), but never wider than the
// flat part of the back wall between the rounded corners.
//

function tray_params() = [
    ["w", tray_width],
    ["d", tray_depth],
    ["h", tray_height],
    ["wt", tray_wall_thickness],
    ["r", tray_corner_radius]
];

// Corner radius, limited so the straight parts of the walls never vanish.
function tray_radius() = max(0, min(tray_corner_radius, (min(tray_width, tray_depth) - 1) / 2));

function tray_tongue_width() = min(tray_width - 2 * tray_radius(), max(40, min(100, tray_width / 3)));

// Outline of the tray in the (x, y) plane, the back wall lies on y = 0.
module tray_outline_2d() {
    r = tray_radius();

    translate([r, r])
        offset(r = r)
            square([tray_width - 2 * r, tray_depth - 2 * r]);
}

module tray_body() {
    difference() {
        linear_extrude(height = tray_height)
            tray_outline_2d();

        // The inner outline is the outer one moved inwards by the wall thickness, so the walls keep
        // their thickness in the corners, too.
        translate([0, 0, tray_wall_thickness])
            linear_extrude(height = tray_height)
                offset(delta = -tray_wall_thickness)
                    tray_outline_2d();
    }
}

// Parameters on the bottom face, along the longer side of it. A rectangle inset by r * (1 - 1 / sqrt(2))
// touches the rounded corners with its corners, the label keeps 2 mm more distance.
module tray_label(params) {
    margin = 2 + tray_radius() * (1 - 1 / sqrt(2));

    ff_engrave_params(
        params,
        [tray_width / 2, tray_depth / 2, 0],
        "bottom",
        max_width  = tray_width - 2 * margin,
        max_height = tray_depth - 2 * margin,
        rotation   = tray_depth > tray_width ? 90 : 0
    );
}

module feature_tray() {
    assert(tray_wall_thickness >= 1, "tray_wall_thickness must be at least 1 mm.");
    assert(
        tray_width >= 2 * tray_wall_thickness + 1 && tray_depth >= 2 * tray_wall_thickness + 1,
        "tray_width and tray_depth must be larger than two walls."
    );
    assert(
        tray_height >= ff_slot_bottom_offset() + 0.5,
        str("tray_height must be at least ", ff_slot_bottom_offset() + 0.5, " mm to carry the tongue.")
    );
    assert(tray_tongue_width() >= 10, "tray_corner_radius is too large: the flat part of the back wall must be at least 10 mm wide for the tongue.");

    params       = tray_params();
    tongue_width = tray_tongue_width();

    ff_echo_file_name("tray", params);

    difference() {
        union() {
            tray_body();

            translate([(tray_width - tongue_width) / 2, 0, 0])
                ff_tongue(tongue_width, tray_height);
        }

        // Skip the text if the floor is too thin for it.
        if (tray_wall_thickness > 2 * text_depth)
            tray_label(params);
    }
}
