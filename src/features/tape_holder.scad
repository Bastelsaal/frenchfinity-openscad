//
// Tape holder
//
// Holds one roll of tape (duct tape, masking tape, packing tape ...) between two side walls. The
// roll rests on two thin rods, so it turns while the tape is pulled out to the front. The rods
// carry every roll from `tape_holder_max_tape_diameter` (full) down to
// `tape_holder_min_tape_diameter` (empty), the top edge of the side walls curves down to the front
// so the roll is easy to reach.
//
// `tape_holder_tape_width` is the width of the roll, `tape_holder_padding` the clearance around it
// (sides, back and below the empty roll). The rods are `tape_holder_rest_diameter` thick, walls and
// back plate `tape_holder_wall_thickness`. The parameters are engraved into the back face.
//

// The rods touch the empty roll this many degrees left and right of its lowest point (1.0).
tape_holder_rest_angle = 45;
// The side walls are this much of the full roll diameter lower at the front than at the back (1.0).
tape_holder_front_drop_ratio = 0.25;
// Shape of the top edge of the side walls: Bezier control points, normalised from the back (0, 0)
// to the front (1, -1), fitted to the 1.0 parts (within 0.3 mm on average).
tape_holder_curve_controls = [[0, 0], [0.1145, 0], [0.2182, -0.588], [0.6332, -0.8367], [1, -1]];
// Rounding of the front corners of the side walls (1.0).
tape_holder_corner_rounding = 5;

function tape_holder_params() = [
    ["tw", tape_holder_tape_width],
    ["matd", tape_holder_max_tape_diameter],
    ["mitd", tape_holder_min_tape_diameter],
    ["rd", tape_holder_rest_diameter]
];

function tape_holder_width() = tape_holder_tape_width + 2 * (tape_holder_wall_thickness + tape_holder_padding);

function tape_holder_depth() = tape_holder_wall_thickness + tape_holder_padding + tape_holder_max_tape_diameter;

function tape_holder_front_drop() = tape_holder_max_tape_diameter * tape_holder_front_drop_ratio;

// Center of the empty roll.
function tape_holder_roll_y() = tape_holder_wall_thickness + tape_holder_padding + tape_holder_max_tape_diameter / 2;

function tape_holder_roll_z() = tape_holder_padding + tape_holder_min_tape_diameter / 2;

function tape_holder_height() = tape_holder_roll_z() + tape_holder_front_drop();

// Distance from the center of the empty roll to the center of a rod.
function tape_holder_rest_distance() = (tape_holder_min_tape_diameter + tape_holder_rest_diameter) / 2;

function tape_holder_rod_positions() = [
    for (side = [-1, 1])
        [
            tape_holder_roll_y() + side * tape_holder_rest_distance() * sin(tape_holder_rest_angle),
            tape_holder_roll_z() - tape_holder_rest_distance() * cos(tape_holder_rest_angle)
        ]
];

// Side view of a side wall (y, z): flat top above the back plate, then the top edge curves down to
// the front. The front corners are rounded.
module tape_holder_wall_2d() {
    wall   = tape_holder_wall_thickness;
    depth  = tape_holder_depth();
    height = tape_holder_height();
    length = depth - wall;
    drop   = tape_holder_front_drop();
    curve  = bezier_curve(
        [for (control = tape_holder_curve_controls) [wall + control[0] * length, height + control[1] * drop]],
        40
    );
    corner = min(tape_holder_corner_rounding, drop / 2, height / 4);

    offset(r = corner)
        offset(delta = -corner)
            polygon(concat([[0, 0], [0, height]], curve, [[depth, 0]]));
}

module tape_holder_body(width) {
    wall   = tape_holder_wall_thickness;
    height = tape_holder_height();
    radius = tape_holder_rest_diameter / 2;

    // Back plate.
    cube([width, wall, height]);

    // Side walls.
    for (x = [0, width - wall])
        translate([x, 0, 0])
            ff_profile_extrude(wall)
                tape_holder_wall_2d();

    // Rods for the roll, reaching half into the walls.
    for (rod = tape_holder_rod_positions())
        translate([wall / 2, rod[0], rod[1]])
            rotate([0, 90, 0])
                cylinder(r = radius, h = width - wall, $fn = ff_fn(radius, 16));
}

module feature_tape_holder() {
    assert(
        tape_holder_min_tape_diameter <= tape_holder_max_tape_diameter,
        "tape_holder_min_tape_diameter must not be larger than tape_holder_max_tape_diameter."
    );
    assert(
        tape_holder_rod_positions()[0][1] - tape_holder_rest_diameter / 2 >= 1,
        "The rods would reach through the bottom: increase tape_holder_min_tape_diameter or tape_holder_padding."
    );
    assert(
        tape_holder_height() >= ff_min_height(),
        str("The holder is too low for the tongue, increase tape_holder_max_tape_diameter or tape_holder_min_tape_diameter.")
    );

    params      = tape_holder_params();
    width       = tape_holder_width();
    height      = tape_holder_height();
    area_top    = height - ff_slot_bottom_offset() - 2;
    area_bottom = 2;

    ff_echo_file_name("tape-holder", params);

    ff_holder(width, height)
        difference() {
            tape_holder_body(width);

            if (area_top > area_bottom)
                ff_engrave_params(
                    params,
                    [width / 2, 0, (area_top + area_bottom) / 2],
                    "back",
                    max_width  = width - 4,
                    max_height = area_top - area_bottom
                );
        }
}
