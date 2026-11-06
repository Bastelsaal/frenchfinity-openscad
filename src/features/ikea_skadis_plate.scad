//
// IKEA Skadis plate
//
// Hangs Frenchfinity holders on an IKEA Skadis pegboard: a plate with a slot on its front and
// hooks on its back that reach through the 5 x 15 mm holes of the pegboard (every 40 mm).
//

ikea_skadis_hole_distance   = 40;
ikea_skadis_hole_width      = 5;
ikea_skadis_hole_height     = 15;
ikea_skadis_board_thickness = 5;
ikea_skadis_peg_clearance_x = 0.3;
ikea_skadis_peg_clearance_z = 1;
ikea_skadis_peg_neck_height = 7.5;
// Distance from the top edge of the plate to the top of the hooks (Frenchfinity 1.0).
ikea_skadis_peg_offset      = 9.344;

function ikea_skadis_plate_params() = [
    ["w", ikea_skadis_plate_width],
    ["h", ikea_skadis_plate_height],
    ["d", ikea_skadis_plate_depth]
];

function ikea_skadis_peg_positions() =
    ff_centered_positions(
        max(1, floor(ikea_skadis_plate_width / ikea_skadis_hole_distance)),
        ikea_skadis_hole_distance,
        ikea_skadis_plate_width / 2
    );

// L shaped hook: a neck through the pegboard and a hook that drops down behind it. Origin is the
// top of the hook at the back face of the plate.
module ikea_skadis_peg() {
    width       = ikea_skadis_hole_width - ikea_skadis_peg_clearance_x;
    hook_height = ikea_skadis_hole_height - ikea_skadis_peg_clearance_z;
    depth       = ikea_skadis_board_thickness + 0.2;

    translate([-width / 2, -depth, -ikea_skadis_peg_neck_height])
        cube([width, depth + ff_eps, ikea_skadis_peg_neck_height]);

    translate([-width / 2, -2 * depth, -hook_height])
        cube([width, depth + ff_eps, hook_height]);
}

module feature_ikea_skadis_plate() {
    assert(
        ikea_skadis_plate_height >= max(ff_min_height(), ikea_skadis_peg_offset + ikea_skadis_hole_height),
        "ikea_skadis_plate_height is too small."
    );
    assert(ikea_skadis_plate_depth >= ff_slot_depth() + 2, str("ikea_skadis_plate_depth must be at least ", ff_slot_depth() + 2, " mm."));

    params       = ikea_skadis_plate_params();
    label_top    = ikea_skadis_plate_height - ikea_skadis_peg_offset - ikea_skadis_hole_height - 2;
    label_bottom = 2;

    ff_echo_file_name("ikea-skadis-plate", params);

    difference() {
        union() {
            translate([0, -ikea_skadis_plate_depth, 0])
                cube([ikea_skadis_plate_width, ikea_skadis_plate_depth, ikea_skadis_plate_height]);

            for (x = ikea_skadis_peg_positions())
                translate([x, -ikea_skadis_plate_depth, ikea_skadis_plate_height - ikea_skadis_peg_offset])
                    ikea_skadis_peg();
        }

        ff_slot(ikea_skadis_plate_width, ikea_skadis_plate_height);

        ff_engrave_params(
            params,
            [ikea_skadis_plate_width / 2, -ikea_skadis_plate_depth, (label_top + label_bottom) / 2],
            "back",
            max_width  = ikea_skadis_plate_width - 6,
            max_height = label_top - label_bottom
        );
    }
}
