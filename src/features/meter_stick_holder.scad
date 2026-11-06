//
// Meter stick holder
//
// An open box for folded meter sticks (folding rules) that lie flat on top of each other:
// meter_slots sticks of meter_length x meter_height x meter_width (the thickness of a folded
// stick), plus meter_tolerance on every side. A long opening in the lower part of the front wall
// shows the lowest stick, a finger hole of finger_hole_diameter in the front wall and in the floor
// pushes the stack up or pulls a stick out. All outer edges except the ones on the wall are
// rounded, the top edges of the box as well.
//

// Radius of the rounded edges (Frenchfinity 1.0).
meter_stick_holder_rounding = 2;

function meter_stick_holder_params() = [
    ["ms", meter_stick_holder_meter_slots],
    ["ml", meter_stick_holder_meter_length],
    ["mh", meter_stick_holder_meter_height],
    ["mw", meter_stick_holder_meter_width],
    ["mt", meter_stick_holder_meter_tolerance],
    ["wt", meter_stick_holder_wall_thickness],
    ["fhd", meter_stick_holder_finger_hole_diameter]
];

function meter_stick_holder_size() =
    let(
        wall      = meter_stick_holder_wall_thickness,
        tolerance = meter_stick_holder_meter_tolerance
    )
    [
        meter_stick_holder_meter_length + 2 * tolerance + 2 * wall,
        meter_stick_holder_meter_height + 2 * tolerance + 2 * wall,
        max(
            meter_stick_holder_meter_slots * meter_stick_holder_meter_width + 2 * tolerance + 2 * wall,
            ff_tongue_bottom_offset()
        )
    ];

// Top of the opening in the front wall: one and a half sticks above the floor (Frenchfinity 1.0).
function meter_stick_holder_opening_top() = meter_stick_holder_wall_thickness + 1.5 * meter_stick_holder_meter_width;

// Outline (x, z) of the opening in the front wall and the finger hole as a BOSL2 region, all
// corners rounded.
function meter_stick_holder_opening_region(size, r) =
    let(
        wall    = meter_stick_holder_wall_thickness,
        top     = meter_stick_holder_opening_top(),
        finger  = meter_stick_holder_finger_hole_diameter,
        opening = [[wall, wall], [size[0] - wall, wall], [size[0] - wall, top], [wall, top]],
        outline = finger > 0 ? union([opening], [move([size[0] / 2, top], circle(d = finger))]) : [opening]
    )
    force_region(offset(offset(offset(outline, r = r), r = -2 * r), r = r));

// Cut body of the opening and the finger hole in the front wall. Their edges are rounded on the
// front face and, where the front wall has an edge, on the inner face (Frenchfinity 1.0).
module meter_stick_holder_opening(size, r) {
    wall   = meter_stick_holder_wall_thickness;
    region = meter_stick_holder_opening_region(size, r);

    // Straight through the wall, flared on the front face.
    translate([0, size[1], 0])
        rotate([90, 0, 0])
            ff_offset_sweep(region, height = wall + 1, bottom = os_circle(r = -r, extra = 1), steps = 8);

    // Flared on the inner face, but not where the opening meets the floor and the side walls.
    intersection() {
        translate([0, size[1] - wall + r + 1, 0])
            rotate([90, 0, 0])
                ff_offset_sweep(region, height = r + 1, top = os_circle(r = -r, extra = 1), steps = 8);

        translate([wall + r, size[1] - wall - r - 2, wall + r])
            cube([size[0] - 2 * wall - 2 * r, r + 3, size[2]]);
    }
}

// Cut body of the finger hole in the floor, centered on the front face, with rounded edges.
module meter_stick_holder_floor_hole(size, r) {
    translate([size[0] / 2, size[1], 0])
        ff_offset_sweep(
            circle(d = meter_stick_holder_finger_hole_diameter),
            height = meter_stick_holder_wall_thickness,
            bottom = os_circle(r = -r, extra = 1),
            top    = os_circle(r = -r, extra = 1),
            steps  = 8
        );
}

// Rounded inner edges between the floor and the side walls (Frenchfinity 1.0).
module meter_stick_holder_floor_fillets(size, r) {
    wall = meter_stick_holder_wall_thickness;

    translate([0, size[1], 0])
        rotate([90, 0, 0])
            linear_extrude(height = size[1] - wall + ff_eps)
                for (side = [[wall, 1], [size[0] - wall, -1]])
                    ff_fillet_2d([side[0], wall], [side[1], 1], r);
}

module meter_stick_holder_label(params, size) {
    area_top    = size[2] - ff_slot_bottom_offset() - 2;
    area_bottom = 2;

    ff_engrave_params(
        params,
        [size[0] / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = size[0] - 20,
        max_height = area_top - area_bottom,
        per_line   = 4
    );
}

module feature_meter_stick_holder() {
    size   = meter_stick_holder_size();
    wall   = meter_stick_holder_wall_thickness;
    r      = min(meter_stick_holder_rounding, wall / 2.5);
    finger = meter_stick_holder_finger_hole_diameter;
    params = meter_stick_holder_params();

    assert(wall >= 1, "meter_stick_holder_wall_thickness must be at least 1 mm.");
    assert(
        finger <= size[0] - 2 * wall - 4 * r,
        "meter_stick_holder_finger_hole_diameter is larger than the inside of the box."
    );
    assert(
        meter_stick_holder_opening_top() + finger / 2 <= size[2] - wall,
        "The finger hole reaches the top edge: reduce meter_stick_holder_finger_hole_diameter."
    );

    ff_echo_file_name("meter-stick-holder", params);

    difference() {
        union() {
            ff_holder(size[0], size[2])
                difference() {
                    // Rounded front edges (+y is BACK in BOSL2) and bottom side edges.
                    cuboid(size, rounding = r, edges = [BACK, BOTTOM + LEFT, BOTTOM + RIGHT], anchor = FRONT + LEFT + BOTTOM);

                    // Box interior, its top edges rounded.
                    ff_rounded_pocket(wall, wall, size[0] - 2 * wall, size[1] - 2 * wall, wall, size[2], r);
                }

            meter_stick_holder_floor_fillets(size, r);
        }

        meter_stick_holder_opening(size, r);

        if (finger > 0)
            meter_stick_holder_floor_hole(size, r);

        meter_stick_holder_label(params, size);
    }
}
