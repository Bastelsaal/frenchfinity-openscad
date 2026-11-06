//
// Welding table plate
//
// Hangs Frenchfinity holders on the side of a welding table: a plate with a slot on its front and
// pins on its back that fit into the holes of the table (D16 or D28 system, 50 or 100 mm grid).
//

welding_table_pin_chamfer = 1;

function welding_table_plate_params() = [
    ["w", welding_table_plate_width],
    ["h", welding_table_plate_height],
    ["d", welding_table_plate_depth],
    ["hd", welding_table_hole_diameter],
    ["hdi", welding_table_hole_distance]
];

function welding_table_pin_diameter() = welding_table_hole_diameter - welding_table_pin_clearance;

function welding_table_pin_positions(size) =
    ff_centered_positions(
        max(1, floor((size - welding_table_pin_diameter()) / welding_table_hole_distance) + 1),
        welding_table_hole_distance,
        size / 2
    );

// Pin along -y with a chamfered tip, origin at the center of its base.
module welding_table_pin() {
    diameter = welding_table_pin_diameter();

    rotate([90, 0, 0]) {
        translate([0, 0, -ff_eps])
            cylinder(d = diameter, h = welding_table_pin_length - welding_table_pin_chamfer + ff_eps);

        translate([0, 0, welding_table_pin_length - welding_table_pin_chamfer])
            cylinder(d1 = diameter, d2 = diameter - 2 * welding_table_pin_chamfer, h = welding_table_pin_chamfer);
    }
}

module feature_welding_table_plate() {
    assert(welding_table_plate_height >= ff_min_height(), str("welding_table_plate_height must be at least ", ff_min_height(), " mm."));
    assert(welding_table_plate_depth >= ff_slot_depth() + 2, str("welding_table_plate_depth must be at least ", ff_slot_depth() + 2, " mm."));
    assert(
        welding_table_plate_width >= welding_table_pin_diameter() && welding_table_plate_height >= welding_table_pin_diameter(),
        "The plate must be at least as large as one pin."
    );

    params       = welding_table_plate_params();
    label_top    = welding_table_plate_height - ff_slot_bottom_offset() - 2;
    label_bottom = 2;

    ff_echo_file_name("welding-table-plate", params);

    difference() {
        union() {
            translate([0, -welding_table_plate_depth, 0])
                cube([welding_table_plate_width, welding_table_plate_depth, welding_table_plate_height]);

            for (
                x = welding_table_pin_positions(welding_table_plate_width),
                z = welding_table_pin_positions(welding_table_plate_height)
            )
                translate([x, -welding_table_plate_depth, z])
                    welding_table_pin();
        }

        ff_slot(welding_table_plate_width, welding_table_plate_height);

        // On the front face below the slot, the back face is covered by the pins.
        ff_engrave_params(
            params,
            [welding_table_plate_width / 2, 0, (label_top + label_bottom) / 2],
            "front",
            max_width  = welding_table_plate_width - 6,
            max_height = label_top - label_bottom
        );
    }
}
