//
// Wall anchor
//
// A 3D printed French cleat. Its bevel hooks onto the wooden cleats of the wall, the slot along its
// front face carries the holders. Countersunk holes in the back wall of the slot (one per
// `wall_anchor_screw_distance` mm of width, two for the default anchor) allow screwing it to the wall.
//

function wall_anchor_front_height() = wall_anchor_height - wall_anchor_depth * tan(wall_anchor_bottom_angle);

function wall_anchor_params() = [
    ["w", wall_anchor_width],
    ["h", wall_anchor_height],
    ["d", wall_anchor_depth],
    ["a", wall_anchor_bottom_angle]
];

// Side profile in the (y, z) plane: the back face lies against the wall, the front face is the
// mounting plane.
module wall_anchor_profile_2d() {
    path = [
        [-wall_anchor_depth, 0],
        [0, wall_anchor_depth * tan(wall_anchor_bottom_angle)],
        [0, wall_anchor_height],
        [-wall_anchor_depth, wall_anchor_height]
    ];

    polygon(round_corners(path, radius = [wall_anchor_bevel_rounding, 0, 0, 0], $fn = 32));
}

// Countersunk holes from the back wall of the slot to the back face of the anchor.
module wall_anchor_screw_holes() {
    count = floor(wall_anchor_width / wall_anchor_screw_distance);

    for (x = ff_centered_positions(count, wall_anchor_screw_distance, wall_anchor_width / 2))
        translate([x, -ff_slot_depth(), ff_slot_z(wall_anchor_height)])
            rotate([-90, 0, 0])
                ff_countersunk_hole(
                    wall_anchor_screw_thread_diameter + print_tolerance,
                    wall_anchor_screw_head_diameter + print_tolerance,
                    wall_anchor_screw_head_height + print_tolerance,
                    wall_anchor_depth - ff_slot_depth() + 1,
                    clearance = 0.5
                );
}

// Parameters on the back face, below the screw holes.
module wall_anchor_label(params) {
    area_top    = ff_slot_z(wall_anchor_height) - wall_anchor_screw_thread_diameter / 2 - 1.5;
    area_bottom = wall_anchor_bevel_rounding + 1.5;

    ff_engrave_params(
        params,
        [wall_anchor_width / 2, -wall_anchor_depth, (area_top + area_bottom) / 2],
        "back",
        max_width  = wall_anchor_width - 6,
        max_height = area_top - area_bottom
    );
}

module feature_wall_anchor() {
    assert(
        wall_anchor_front_height() >= ff_slot_bottom_offset() + 1,
        str(
            "The front face of the wall anchor is too small for the slot. Increase wall_anchor_height to at least ",
            ff_slot_bottom_offset() + 1 + wall_anchor_depth * tan(wall_anchor_bottom_angle),
            " mm."
        )
    );
    assert(
        wall_anchor_depth >= ff_slot_depth() + wall_anchor_screw_head_height + 2,
        "wall_anchor_depth is too small for the slot."
    );

    params = wall_anchor_params();

    ff_echo_file_name("wall-anchor", params);

    difference() {
        ff_profile_extrude(wall_anchor_width)
            wall_anchor_profile_2d();

        ff_slot(wall_anchor_width, wall_anchor_height);

        if (wall_anchor_render_screw_holes)
            wall_anchor_screw_holes();

        wall_anchor_label(params);
    }
}
