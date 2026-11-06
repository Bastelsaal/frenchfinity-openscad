//
// Nussbaum SL Smart Lift plate
//
// Turns a column of a Nussbaum SL Smart Lift (car lift) into a Frenchfinity wall: a plate with a
// slot along its top edge, like a wall anchor, that is screwed to the column with four screws.
// The screw holes match the threaded holes of the column: they sit in the corners of the hole
// pattern of the column, `nussbaum_sl_smart_lift_plate_hole_distance_from_outside` mm inside
// its outer edges, and have a counterbore with a rounded seat for the screw heads. A rim on the
// back of the plate fits around a rectangular feature of the column and locates the plate.
//
// Orientation: like a wall anchor, the front face with the slot is the mounting plane y = 0, the
// plate extends to -y (towards the column). x = 0 is the edge of the plate next to the screw holes.
//

// Hole pattern of the column: [x, z] of its lower left corner and its [width, height], measured
// from the lower left corner of the plate (seen from the back).
nussbaum_sl_smart_lift_plate_hole_area_position = [15, 7];
nussbaum_sl_smart_lift_plate_hole_area_size     = [61, 157];
// The upper hole at the smaller x sits 1 mm further out on the lift (as measured for 1.0).
nussbaum_sl_smart_lift_plate_upper_hole_shift   = -1;
// Counterbore for the screw heads and the radius of its rounded seat.
nussbaum_sl_smart_lift_plate_head_diameter      = 11;
nussbaum_sl_smart_lift_plate_head_depth         = 4;
nussbaum_sl_smart_lift_plate_seat_rounding      = 3;
// Locating rim on the back: position of its lower left corner, outer size, wall, height and the
// radius of its outer corners.
nussbaum_sl_smart_lift_plate_rim_position       = [15.5, 25.5];
nussbaum_sl_smart_lift_plate_rim_size           = [60, 119];
nussbaum_sl_smart_lift_plate_rim_wall           = 3.5;
nussbaum_sl_smart_lift_plate_rim_height         = 6;
nussbaum_sl_smart_lift_plate_rim_rounding       = 2;

function nussbaum_sl_smart_lift_plate_params() = [
    ["w", nussbaum_sl_smart_lift_plate_width],
    ["h", nussbaum_sl_smart_lift_plate_height],
    ["d", nussbaum_sl_smart_lift_plate_depth],
    ["hd", nussbaum_sl_smart_lift_plate_hole_diameter],
    ["ho", nussbaum_sl_smart_lift_plate_hole_distance_from_outside]
];

// [x, z] of the four screw holes.
function nussbaum_sl_smart_lift_plate_holes() =
    let(
        p     = nussbaum_sl_smart_lift_plate_hole_area_position,
        s     = nussbaum_sl_smart_lift_plate_hole_area_size,
        inset = nussbaum_sl_smart_lift_plate_hole_distance_from_outside,
        left  = p[0] + inset,
        right = p[0] + s[0] - inset,
        lower = p[1] + inset,
        upper = p[1] + s[1] - inset
    )
    [[left, lower], [right, lower], [left + nussbaum_sl_smart_lift_plate_upper_hole_shift, upper], [right, upper]];

// Half profile (radius, depth below the front face) of a screw hole: the shaft, the counterbore
// and the rounded seat between them, which is a quarter circle tangent to the shaft.
function nussbaum_sl_smart_lift_plate_hole_profile() =
    let(
        r     = nussbaum_sl_smart_lift_plate_hole_diameter / 2,
        R     = nussbaum_sl_smart_lift_plate_head_diameter / 2,
        round = nussbaum_sl_smart_lift_plate_seat_rounding,
        floor = nussbaum_sl_smart_lift_plate_head_depth,
        // the seat circle is centered at [r + round, floor + rise] and cut by the counterbore wall
        rise  = round > R - r ? sqrt(round * round - pow(r + round - R, 2)) : round,
        // angle of the first point of the seat (on the counterbore wall or on a flat floor),
        // the seat ends tangent to the shaft at -180 degrees
        start = atan2(-rise, min(R, r + round) - (r + round)),
        steps = 12,
        depth = nussbaum_sl_smart_lift_plate_depth + 1
    )
    concat(
        [[0, -1], [R, -1], [R, floor]],
        R - r > round ? [[r + round, floor]] : [],
        [for (i = [1 : steps]) let(a = start + (-180 - start) * i / steps)
            [r + round + round * cos(a), floor + rise + round * sin(a)]],
        [[r, depth], [0, depth]]
    );

// Screw hole along -y, its counterbore opens in the front face.
module nussbaum_sl_smart_lift_plate_hole() {
    rotate([90, 0, 0])
        rotate_extrude($fn = 48)
            polygon(nussbaum_sl_smart_lift_plate_hole_profile());
}

module nussbaum_sl_smart_lift_plate_rim() {
    size     = nussbaum_sl_smart_lift_plate_rim_size;
    wall     = nussbaum_sl_smart_lift_plate_rim_wall;
    rounding = nussbaum_sl_smart_lift_plate_rim_rounding;

    translate([
        nussbaum_sl_smart_lift_plate_rim_position[0],
        -nussbaum_sl_smart_lift_plate_depth + ff_eps,
        nussbaum_sl_smart_lift_plate_rim_position[1]
    ])
        rotate([90, 0, 0])
            linear_extrude(height = nussbaum_sl_smart_lift_plate_rim_height + ff_eps)
                difference() {
                    offset(r = rounding) offset(delta = -rounding) square(size);
                    translate([wall, wall]) square([size[0] - 2 * wall, size[1] - 2 * wall]);
                }
}

// Parameters on the back face, inside the rim.
module nussbaum_sl_smart_lift_plate_label(params) {
    p    = nussbaum_sl_smart_lift_plate_rim_position;
    size = nussbaum_sl_smart_lift_plate_rim_size;
    wall = nussbaum_sl_smart_lift_plate_rim_wall;

    ff_engrave_params(
        params,
        [p[0] + size[0] / 2, -nussbaum_sl_smart_lift_plate_depth, p[1] + size[1] / 2],
        "back",
        max_width  = size[0] - 2 * wall - 6,
        max_height = size[1] - 2 * wall - 6
    );
}

module feature_nussbaum_sl_smart_lift_plate() {
    width  = nussbaum_sl_smart_lift_plate_width;
    height = nussbaum_sl_smart_lift_plate_height;
    depth  = nussbaum_sl_smart_lift_plate_depth;
    holes  = nussbaum_sl_smart_lift_plate_holes();
    head   = nussbaum_sl_smart_lift_plate_head_diameter;
    rim    = nussbaum_sl_smart_lift_plate_rim_position + nussbaum_sl_smart_lift_plate_rim_size;

    assert(
        nussbaum_sl_smart_lift_plate_hole_diameter < head - 1,
        str("nussbaum_sl_smart_lift_plate_hole_diameter must be smaller than ", head - 1, " mm (the counterbore).")
    );
    assert(
        depth >= max(ff_slot_depth(), nussbaum_sl_smart_lift_plate_head_depth + nussbaum_sl_smart_lift_plate_seat_rounding) + 2,
        str("nussbaum_sl_smart_lift_plate_depth must be at least ", max(ff_slot_depth(), nussbaum_sl_smart_lift_plate_head_depth + nussbaum_sl_smart_lift_plate_seat_rounding) + 2, " mm.")
    );
    assert(
        min([for (h = holes) min(h[0], h[1])]) >= head / 2 + 1,
        "nussbaum_sl_smart_lift_plate_hole_distance_from_outside is too small, the screw holes reach the edge of the plate."
    );
    assert(
        width >= max(rim[0], max([for (h = holes) h[0]]) + head / 2) + 2,
        str("nussbaum_sl_smart_lift_plate_width must be at least ", max(rim[0], max([for (h = holes) h[0]]) + head / 2) + 2, " mm.")
    );
    assert(
        height - ff_slot_bottom_offset() >= max(rim[1], max([for (h = holes) h[1]]) + head / 2) + 2,
        str("nussbaum_sl_smart_lift_plate_height must be at least ", max(rim[1], max([for (h = holes) h[1]]) + head / 2) + 2 + ff_slot_bottom_offset(), " mm, the slot would cut the screw holes.")
    );

    params = nussbaum_sl_smart_lift_plate_params();

    ff_echo_file_name("nussbaum-sl-smart-lift-plate", params);

    difference() {
        union() {
            translate([0, -depth, 0])
                cube([width, depth, height]);

            nussbaum_sl_smart_lift_plate_rim();
        }

        ff_slot(width, height);

        for (h = holes)
            translate([h[0], 0, h[1]])
                nussbaum_sl_smart_lift_plate_hole();

        nussbaum_sl_smart_lift_plate_label(params);
    }
}
