//
// Locksmith corner holder
//
// Holds a locksmith's square (an L shaped steel square with a thin blade and a thick stock). An
// arm rises from the back plate at locksmith_corner_holder_angle degrees. Along its top runs a
// groove for the blade: locksmith_corner_holder_angle_stick_width + 2 x tolerance wide and
// locksmith_corner_holder_angle_stick_height deep, open at the front end, so the blade slides in
// from the front and the stock hangs down in front of the holder. The arm is
// locksmith_corner_holder_angle_foot_width + 2 x side padding wide and
// locksmith_corner_holder_holder_width + 2 x side padding + 15 mm long (Frenchfinity 1.0), its
// front end is as high as the groove plus a wall below it. The back plate is twice the height of
// the blade high.
//

// The arm is this much longer than the holder width and the paddings (Frenchfinity 1.0).
locksmith_corner_holder_arm_extension = 15;
// Radius of the rounded edges of the groove and of the top front corner of the arm.
locksmith_corner_holder_rounding = 2;

function locksmith_corner_holder_params() = [
    ["asw", locksmith_corner_holder_angle_stick_width],
    ["afw", locksmith_corner_holder_angle_foot_width],
    ["hw", locksmith_corner_holder_holder_width],
    ["ash", locksmith_corner_holder_angle_stick_height],
    ["a", locksmith_corner_holder_angle],
    ["tol", locksmith_corner_holder_tolerance],
    ["sp", locksmith_corner_holder_side_padding],
    ["wt", locksmith_corner_holder_wall_thickness]
];

function locksmith_corner_holder_width() =
    locksmith_corner_holder_angle_foot_width + 2 * locksmith_corner_holder_side_padding;

function locksmith_corner_holder_plate_height() =
    max(2 * locksmith_corner_holder_angle_stick_height, ff_min_height());

function locksmith_corner_holder_arm_length() =
    locksmith_corner_holder_holder_width + 2 * locksmith_corner_holder_side_padding + locksmith_corner_holder_arm_extension;

// Height of the front end of the arm, measured at right angles to the arm.
function locksmith_corner_holder_end_height() =
    locksmith_corner_holder_angle_stick_height + locksmith_corner_holder_wall_thickness;

function locksmith_corner_holder_groove_width() =
    locksmith_corner_holder_angle_stick_width + 2 * locksmith_corner_holder_tolerance;

// Point of the side view (y, z) in the frame of the arm: s along its top edge from the top of the
// back plate, t at right angles to it (up).
function locksmith_corner_holder_point(s, t) =
    let(a = locksmith_corner_holder_angle)
    [
        locksmith_corner_holder_wall_thickness + s * cos(a) - t * sin(a),
        locksmith_corner_holder_plate_height() + s * sin(a) + t * cos(a)
    ];

// Side view (y, z): back plate and arm, the top front corner of the arm rounded.
module locksmith_corner_holder_profile_2d() {
    wt     = locksmith_corner_holder_wall_thickness;
    length = locksmith_corner_holder_arm_length();

    square([wt, locksmith_corner_holder_plate_height()]);

    polygon(round_corners(
        [
            locksmith_corner_holder_point(0, 0),
            locksmith_corner_holder_point(length, 0),
            locksmith_corner_holder_point(length, -locksmith_corner_holder_end_height()),
            [wt, 0]
        ],
        method = "circle",
        // A bit larger than the rounding of the groove edges: equal radii meet tangentially at
        // the front end, which leaves non manifold edges.
        radius = [0, locksmith_corner_holder_rounding + 0.1, 0, 0],
        $fn = 32
    ));
}

// Maps the frame of the arm to the part: x stays, y runs along the top edge of the arm, z is at
// right angles to it, the origin is the top edge of the arm at the back plate.
module locksmith_corner_holder_arm_frame() {
    translate([0, locksmith_corner_holder_wall_thickness, locksmith_corner_holder_plate_height()])
        rotate([locksmith_corner_holder_angle, 0, 0])
            children();
}

// Cross section (x, t) of the groove from x0 to x1, its top edges (t = 0) rounded.
module locksmith_corner_holder_groove_section_2d(x0, x1, bottom, r) {
    translate([x0, bottom])
        square([x1 - x0, 10 - bottom]);

    for (side = [[x0, -1], [x1, 1]])
        difference() {
            translate([side[1] > 0 ? side[0] - ff_eps : side[0] - r, -r])
                square([r + ff_eps, r + 10]);

            translate([side[0] + side[1] * r, -r])
                circle(r = r);
        }
}

// Side view (s, t) of the groove: open at the front end and at the top, the inner corner at the
// back and the front edge of the floor are rounded.
module locksmith_corner_holder_groove_side_2d(length, depth, r) {
    // The rounding of the floor meets the front face a bit above its end, so the two do not
    // touch tangentially.
    center = [length - r + 0.05, -depth - r];

    offset(r = min(r, depth / 2))
        offset(delta = -min(r, depth / 2))
            translate([0, -depth])
                square([length + 10, depth + 10]);

    difference() {
        translate(center)
            square([r + 10, r + ff_eps]);

        translate(center)
            circle(r = r);
    }
}

// Cut body of the groove, like the box pockets the intersection of a cross section along the arm
// and a side view across it.
module locksmith_corner_holder_groove() {
    width  = locksmith_corner_holder_width();
    groove = locksmith_corner_holder_groove_width();
    depth  = locksmith_corner_holder_angle_stick_height;
    length = locksmith_corner_holder_arm_length();
    r      = locksmith_corner_holder_rounding;
    x0     = (width - groove) / 2;

    locksmith_corner_holder_arm_frame()
        intersection() {
            translate([0, length + 10, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = length + 11)
                        locksmith_corner_holder_groove_section_2d(x0, x0 + groove, -depth - r - 1, r);

            translate([x0 - r - 1, 0, 0])
                ff_extrude_along_x(groove + 2 * r + 2)
                    locksmith_corner_holder_groove_side_2d(length, depth, r);
        }
}

// Parameters on the underside of the arm, along it.
module locksmith_corner_holder_label(params) {
    width  = locksmith_corner_holder_width();
    start  = [locksmith_corner_holder_wall_thickness, 0];
    end    = locksmith_corner_holder_point(locksmith_corner_holder_arm_length(), -locksmith_corner_holder_end_height());
    angle  = atan2(end[1] - start[1], end[0] - start[0]);
    length = norm(end - start);
    middle = (start + end) / 2;

    translate([width / 2, middle[0], middle[1]])
        rotate([angle, 0, 0])
            ff_engrave_params(
                params,
                [0, 0, 0],
                "bottom",
                max_width  = width - 4,
                max_height = length - 10,
                per_line   = 3,
                rotation   = -90
            );
}

module feature_locksmith_corner_holder() {
    a = locksmith_corner_holder_angle;

    assert(a >= 0 && a <= 75, "locksmith_corner_holder_angle must be between 0 and 75 degrees.");
    assert(locksmith_corner_holder_wall_thickness >= 2, "locksmith_corner_holder_wall_thickness must be at least 2 mm.");
    assert(
        locksmith_corner_holder_angle_foot_width >= locksmith_corner_holder_groove_width() + 2,
        "locksmith_corner_holder_angle_foot_width must be larger than the groove (angle_stick_width + 2 x tolerance)."
    );
    assert(locksmith_corner_holder_angle_stick_height >= 3, "locksmith_corner_holder_angle_stick_height must be at least 3 mm.");

    params = locksmith_corner_holder_params();
    width  = locksmith_corner_holder_width();

    ff_echo_file_name("locksmith-corner-holder", params);

    difference() {
        ff_holder(width, locksmith_corner_holder_plate_height())
            ff_profile_extrude(width)
                locksmith_corner_holder_profile_2d();

        locksmith_corner_holder_groove();

        locksmith_corner_holder_label(params);
    }
}
