//
// Can holder
//
// A block with a deep round pocket for a spray can, a glue bottle, a marker or any other cylindrical
// item. The pocket leans forward by `can_holder_angle`, so the item tilts towards the room and is
// easy to grab. The top of the block is flat for `can_holder_padding_left` behind the pocket, then
// slopes down at a right angle to the pocket.
//
// The pocket is `can_holder_can_diameter` + `can_holder_can_padding` wide and `can_holder_can_inset`
// deep (measured along the pocket from the sloped top). `can_holder_padding` is the material around
// the pocket. With `can_holder_hole_bottom`, a window at the bottom of the front wall lets dirt and
// drops fall out of the pocket. The parameters are engraved into the back face below the tongue.
//

// Rounding of the edge between the sloped top and the front face and of the pocket rim (1.0).
can_holder_large_rounding = 4;
// Rounding of the outer side edges (1.0).
can_holder_small_rounding = 1;
// The window of the hole bottom variant is this part of can_holder_can_inset high (1.0).
can_holder_hole_bottom_height_ratio = 0.2;
// Minimum wall between the pocket and the back face.
can_holder_min_back_wall = 0.4;

function can_holder_params() = concat(
    [
        ["cd", can_holder_can_diameter],
        ["pl", can_holder_padding_left],
        ["ci", can_holder_can_inset],
        ["p", can_holder_padding],
        ["a", can_holder_angle]
    ],
    can_holder_hole_bottom ? [["", "hole-bottom"]] : []
);

function can_holder_width() = can_holder_can_diameter + 2 * can_holder_padding;

function can_holder_pocket_diameter() = can_holder_can_diameter + can_holder_can_padding;

// Wall in front of and behind the pocket, measured on the sloped top.
function can_holder_slope_wall() = can_holder_padding + can_holder_can_padding / 2;

// Length of the sloped top.
function can_holder_slope_length() = can_holder_pocket_diameter() + 2 * can_holder_slope_wall();

// Height of the front face, measured along the pocket.
function can_holder_front_length() = can_holder_can_inset + can_holder_padding;

function can_holder_top() =
    can_holder_slope_length() * sin(can_holder_angle) + can_holder_front_length() * cos(can_holder_angle);

// Thinnest wall between the bottom of the pocket and the back face.
function can_holder_back_wall() =
    can_holder_padding_left
        + can_holder_slope_wall() * cos(can_holder_angle)
        - can_holder_can_inset * sin(can_holder_angle);

// Height of the lowest point of the pocket's back wall.
function can_holder_pocket_back_z() =
    can_holder_top()
        - can_holder_slope_wall() * sin(can_holder_angle)
        - can_holder_can_inset * cos(can_holder_angle);

function can_holder_rim_rounding() =
    min(can_holder_large_rounding, max(0, can_holder_padding - can_holder_can_padding / 2 - 1));

function can_holder_front_rounding() = min(can_holder_large_rounding, can_holder_slope_wall() / 2);

function can_holder_window_rounding() =
    min(can_holder_large_rounding, can_holder_padding / 2, can_holder_can_inset / 10);

// Places children in the frame of the pocket: origin at the top edge of the back face, local z
// along the pocket axis (up), local y at a right angle to it towards the front, local x along x.
module can_holder_can_frame(top) {
    translate([0, 0, top])
        rotate([-can_holder_angle, 0, 0])
            children();
}

// Side view: flat top behind the pocket, sloped top, front face parallel to the pocket, flat bottom.
module can_holder_side_profile_2d(top) {
    slope_start = can_holder_padding_left;
    front_top   = [
        slope_start + can_holder_slope_length() * cos(can_holder_angle),
        top - can_holder_slope_length() * sin(can_holder_angle)
    ];
    front_bottom = front_top - can_holder_front_length() * [sin(can_holder_angle), cos(can_holder_angle)];
    corners      = concat(
        [[0, 0], [0, top]],
        can_holder_angle > 0 ? [[slope_start, top]] : [],
        [front_top, [front_bottom[0], 0]]
    );
    radii = concat([0, 0], can_holder_angle > 0 ? [0] : [], [can_holder_front_rounding(), 0]);

    polygon(round_corners(corners, radius = radii, $fn = 32));
}

// 2D rectangle from x = -ff_eps to `width` + ff_eps and from -`length` to ff_eps along y, the
// corners at the top rounded. It reaches ff_eps beyond the faces it rounds, so no faces coincide.
module can_holder_rounded_end_2d(width, length, rounding) {
    polygon(round_corners(
        [[-ff_eps, -length], [-ff_eps, ff_eps], [width + ff_eps, ff_eps], [width + ff_eps, -length]],
        radius = [0, rounding, rounding, 0],
        $fn = 16
    ));
}

// The body is the intersection of the side profile, a slab for the side faces and three
// extrusions that round the outer side edges.
module can_holder_body(width, top) {
    rounding    = can_holder_small_rounding;
    big         = 2 * (top + can_holder_slope_length() + can_holder_padding_left);
    slope_start = can_holder_padding_left * cos(can_holder_angle);
    top_cf      = can_holder_padding_left * sin(can_holder_angle);
    front_cf    = slope_start + can_holder_slope_length();

    intersection() {
        translate([-ff_eps, 0, 0])
            ff_profile_extrude(width + 2 * ff_eps)
                can_holder_side_profile_2d(top);

        translate([0, -big / 2, -big / 2])
            cube([width, big, big]);

        // Rounded edges between the flat top and the sides.
        translate([0, -1, top])
            rotate([-90, 0, 0])
                linear_extrude(height = big)
                    mirror([0, 1]) can_holder_rounded_end_2d(width, big, rounding);

        can_holder_can_frame(top) {
            // Rounded edges between the sloped top and the sides.
            translate([0, 0, top_cf])
                rotate([90, 0, 0])
                    linear_extrude(height = 2 * big, center = true)
                        can_holder_rounded_end_2d(width, big, rounding);

            // Rounded edges between the front face and the sides.
            translate([0, front_cf, 0])
                linear_extrude(height = 2 * big, center = true)
                    can_holder_rounded_end_2d(width, big, rounding);
        }
    }
}

// Cut body of the pocket along -z from z = 0, with a rounded rim. The rim ends 2 x ff_eps above
// the surface, so the cut crosses the surface instead of touching it.
module can_holder_pocket(diameter, depth, rounding) {
    radius = diameter / 2;
    steps  = 8;

    rotate_extrude($fn = ff_fn(radius + rounding))
        polygon(concat(
            [[0, -depth], [radius, -depth]],
            rounding > 0
                ? [
                    for (i = [0 : steps])
                        let(angle = 180 - 90 * i / steps)
                            [
                                radius + rounding + rounding * cos(angle),
                                -rounding + rounding * sin(angle) + 2 * ff_eps
                            ]
                ]
                : [[radius, 0]],
            [[radius + rounding, 1], [0, 1]]
        ));
}

// Cut body of the window: a box from the pocket axis through the front face, its edges on the
// front face rounded. Origin: bottom of the pocket on its axis, in the frame of the pocket. The box
// starts 1 mm in front of the axis, where its sides would only touch the pocket.
module can_holder_window(width, height, length, rounding) {
    steps = 6;

    translate([-width / 2, 1, -ff_eps])
        cube([width, length, height + ff_eps]);

    // Rounded edges: thin outlines of the opening, growing towards the front face, hulled in pairs.
    // The stack ends 2 x ff_eps in front of the face, so the cut crosses the face.
    if (rounding > 0)
        for (i = [0 : steps - 1])
            hull()
                for (step = [i, i + 1])
                    let(
                        depth  = rounding * (1 - step / steps),
                        grow   = rounding - sqrt(rounding * rounding - (rounding - depth) * (rounding - depth))
                    )
                        translate([-width / 2 - grow, length - depth + 2 * ff_eps, -grow])
                            cube([width + 2 * grow, ff_eps + (step == steps ? 1 : 0), height + 2 * grow]);
}

module can_holder_cuts(width, top) {
    slope_start = can_holder_padding_left * cos(can_holder_angle);
    top_cf      = can_holder_padding_left * sin(can_holder_angle);
    pocket_y    = slope_start + can_holder_slope_wall() + can_holder_pocket_diameter() / 2;
    front_cf    = slope_start + can_holder_slope_length();

    can_holder_can_frame(top) {
        translate([width / 2, pocket_y, top_cf])
            can_holder_pocket(can_holder_pocket_diameter(), can_holder_can_inset, can_holder_rim_rounding());

        if (can_holder_hole_bottom)
            translate([width / 2, pocket_y, top_cf - can_holder_can_inset])
                can_holder_window(
                    can_holder_pocket_diameter(),
                    can_holder_can_inset * can_holder_hole_bottom_height_ratio,
                    front_cf - pocket_y,
                    can_holder_window_rounding()
                );
    }
}

// Parameters on the back face below the tongue, clear of the pocket where the back wall is thin.
module can_holder_label(params, width, top) {
    tongue_bottom = top - ff_slot_bottom_offset() - 2;
    area_top      = can_holder_back_wall() >= text_depth + 1
        ? tongue_bottom
        : min(tongue_bottom, can_holder_pocket_back_z() - 1);
    area_bottom   = 2;

    if (area_top > area_bottom)
        ff_engrave_params(
            params,
            [width / 2, 0, (area_top + area_bottom) / 2],
            "back",
            max_width  = width - 4,
            max_height = area_top - area_bottom
        );
}

module feature_can_holder() {
    assert(can_holder_can_diameter > 0, "can_holder_can_diameter must be larger than 0.");
    assert(
        can_holder_padding - can_holder_can_padding / 2 >= 1,
        "can_holder_padding is too small: the side walls of the pocket would be thinner than 1 mm."
    );
    assert(can_holder_angle >= 0 && can_holder_angle <= 60, "can_holder_angle must be between 0 and 60 degrees.");
    assert(
        can_holder_back_wall() >= can_holder_min_back_wall,
        str(
            "The pocket breaks through the back face. Increase can_holder_padding_left to at least ",
            can_holder_padding_left - can_holder_back_wall() + can_holder_min_back_wall,
            " mm or reduce can_holder_can_inset or can_holder_angle."
        )
    );
    assert(
        can_holder_top() >= ff_min_height(),
        str("The holder is too low for the tongue, increase can_holder_can_inset.")
    );

    params = can_holder_params();
    width  = can_holder_width();
    top    = can_holder_top();

    ff_echo_file_name("can-holder", params);

    ff_holder(width, top)
        difference() {
            can_holder_body(width, top);
            can_holder_cuts(width, top);
            can_holder_label(params, width, top);
        }
}
