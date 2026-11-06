//
// Screw plate
//
// For walls without French cleats: a plate with a slot on its front and countersunk screw holes.
// The holes are spread over the plate, `screw_plate_screw_distance` mm apart horizontally, with one
// row close to the top and one close to the bottom (plus rows in between on tall plates).
//

function screw_plate_params() = [
    ["w", screw_plate_width],
    ["h", screw_plate_height],
    ["d", screw_plate_depth],
    ["std", screw_plate_screw_thread_diameter],
    ["shd", screw_plate_screw_head_diameter],
    ["shh", screw_plate_screw_head_height]
];

function screw_plate_columns() =
    ff_centered_positions(
        max(1, floor((screw_plate_width - 2 * screw_plate_screw_edge_distance) / screw_plate_screw_distance) + 1),
        screw_plate_screw_distance,
        screw_plate_width / 2
    );

function screw_plate_rows() =
    let(
        lowest  = screw_plate_screw_edge_distance,
        highest = screw_plate_height - ff_slot_bottom_offset() - screw_plate_screw_edge_distance,
        count   = max(1, floor((highest - lowest) / screw_plate_screw_distance) + 1)
    )
    // Top row first.
    [for (z = ff_distributed_positions(count, highest, lowest)) z];

module screw_plate_screw_holes() {
    for (x = screw_plate_columns(), z = screw_plate_rows())
        translate([x, 0, z])
            rotate([-90, 0, 0])
                ff_countersunk_hole(
                    screw_plate_screw_thread_diameter + print_tolerance,
                    screw_plate_screw_head_diameter + print_tolerance,
                    screw_plate_screw_head_height,
                    screw_plate_depth + 1
                );
}

// Parameters on the back face, between the two upper rows of screw holes (or below a single row).
module screw_plate_label(params) {
    rows        = screw_plate_rows();
    clearance   = screw_plate_screw_thread_diameter / 2 + 2;
    area_top    = rows[0] - clearance;
    area_bottom = len(rows) > 1 ? rows[1] + clearance : 2;

    ff_engrave_params(
        params,
        [screw_plate_width / 2, -screw_plate_depth, (area_top + area_bottom) / 2],
        "back",
        max_width  = screw_plate_width - 6,
        max_height = area_top - area_bottom
    );
}

module feature_screw_plate() {
    assert(
        screw_plate_height >= ff_min_height() + screw_plate_screw_head_diameter + 2,
        str("screw_plate_height must be at least ", ff_min_height() + screw_plate_screw_head_diameter + 2, " mm.")
    );
    assert(
        screw_plate_depth >= ff_slot_depth() + 2 && screw_plate_depth > screw_plate_screw_head_height + 1,
        str("screw_plate_depth must be at least ", max(ff_slot_depth() + 2, screw_plate_screw_head_height + 1), " mm.")
    );

    params = screw_plate_params();

    ff_echo_file_name("screw-plate", params);

    difference() {
        translate([0, -screw_plate_depth, 0])
            cube([screw_plate_width, screw_plate_depth, screw_plate_height]);

        ff_slot(screw_plate_width, screw_plate_height);
        screw_plate_screw_holes();
        screw_plate_label(params);
    }
}
