//
// Pliers holder
//
// Holds one pair of pliers hanging upright: one handle goes down through a slot shaped hole
// (pliers_holder_hole_diameter wide), the joint rests in a round trough across the top of the middle
// block and the other handle leans against the two arms at the bottom front. A back block carries
// the tongue. Like in Frenchfinity 1.0, pliers_holder_height is measured from the bottom to the top of
// the tongue, the part reaches about 6 mm higher. The middle block ends
// pliers_holder_opening_height_ratio x pliers_holder_height below the top of the tongue.
//

// Radius of the rounded vertical edges (Frenchfinity 1.0).
pliers_holder_rounding = 1;

// Radius of the rounded top edges (Frenchfinity 1.0: 1 mm). A bit smaller than the vertical one, so
// the rounded faces of the blocks never meet tangentially (that would leave non-manifold edges).
pliers_holder_top_rounding = 0.8;

// The body is built this much wider on both sides and then cut to its exact width, so its side faces
// lie exactly at x = 0 and x = width.
pliers_holder_side_overlap = ff_eps;

function pliers_holder_width() = pliers_holder_hole_diameter + 3 * pliers_holder_hole_border_padding;

// Total height: pliers_holder_height reaches up to the top of the tongue.
function pliers_holder_top() = pliers_holder_height + ff_tongue_top_offset();

// Top of the middle block.
function pliers_holder_middle_top() = pliers_holder_height * (1 - pliers_holder_opening_height_ratio);

// Front face of the back block: the center line of the back end of the hole.
function pliers_holder_back_depth() = pliers_holder_hole_border_padding + pliers_holder_hole_diameter / 2;

function pliers_holder_params() = concat(
    [
        ["h", pliers_holder_height],
        ["hd", pliers_holder_hole_diameter]
    ],
    // Not part of the Frenchfinity 1.0 file name: only listed when they differ from their default.
    ff_optional_params([
        ["d", pliers_holder_depth, 50],
        ["p", pliers_holder_hole_border_padding, 5],
        ["o", pliers_holder_opening_height_ratio, 0.4],
        ["t", pliers_holder_center_trough_height, 5],
        ["aw", pliers_holder_arms_width, 5],
        ["ah", pliers_holder_arms_height, 10],
        ["al", pliers_holder_arms_length, 30]
    ])
);

// Rectangle (x, y) from y = `from` to y = `to` over the whole width (plus the side overlap), its front
// corners rounded, as a BOSL2 path.
function pliers_holder_block_path(from, to) =
    let(overlap = pliers_holder_side_overlap, width = pliers_holder_width())
    round_corners(
        [[-overlap, from], [width + overlap, from], [width + overlap, to], [-overlap, to]],
        radius = [0, 0, pliers_holder_rounding, pliers_holder_rounding],
        method = "circle"
    );

// Footprint (x, y) of the bottom layer: middle block and arms. A U shaped gap as wide as the hole
// separates the arms, it widens towards the front so the arms end pliers_holder_arms_width wide.
function pliers_holder_bottom_path() =
    let(
        overlap = pliers_holder_side_overlap,
        width   = pliers_holder_width(),
        depth   = pliers_holder_depth,
        front   = depth + pliers_holder_arms_length,
        radius  = pliers_holder_hole_diameter / 2,
        arm     = pliers_holder_arms_width,
        tip     = arm / 2,
        gap     = arc(r = radius, cp = [width / 2, depth + radius], angle = [0, -180]),
        back    = -2 * pliers_holder_rounding
    )
    pliers_holder_arms_length == 0
        ? pliers_holder_block_path(back, depth)
        : round_corners(
            concat(
                [[-overlap, back], [width + overlap, back], [width + overlap, front], [width - arm, front]],
                gap,
                [[arm, front], [-overlap, front]]
            ),
            radius = concat([0, 0, tip, tip], repeat(0, len(gap)), [tip, tip]),
            method = "circle"
        );

// Cross section (x, z) of the round trough across the middle block, including the rounding of its
// edges. The part above the middle block starts just above its top face: coincident faces would leave
// non-manifold edges.
module pliers_holder_trough_2d() {
    r      = pliers_holder_top_rounding;
    width  = pliers_holder_width();
    top    = pliers_holder_middle_top();
    depth  = pliers_holder_center_trough_height;
    // The trough is a circular segment as wide as the hole plus one padding.
    chord  = pliers_holder_hole_diameter + pliers_holder_hole_border_padding;
    radius = (pow(chord / 2, 2) + depth * depth) / (2 * depth);

    offset(r = -r)
        offset(delta = r)
            union() {
                translate([width / 2 - chord / 2 - 3 * r, top + 0.01])
                    square([chord + 6 * r, radius]);

                translate([width / 2, top - depth + radius])
                    circle(r = radius, $fa = 2);
            }
}

module pliers_holder_trough_cut() {
    start = pliers_holder_back_depth() - ff_eps;

    if (pliers_holder_center_trough_height > 0)
        translate([0, start, 0])
            rotate([-90, 0, 0])
                mirror([0, 1, 0])
                    linear_extrude(height = pliers_holder_depth + 1 - start)
                        pliers_holder_trough_2d();
}

// Slot shaped hole from the back wall to the front wall, through the whole part.
module pliers_holder_hole() {
    padding = pliers_holder_hole_border_padding;
    radius  = pliers_holder_hole_diameter / 2;

    translate([0, 0, -1])
        linear_extrude(height = pliers_holder_top() + 2)
            hull()
                for (y = [padding + radius, pliers_holder_depth - padding - radius])
                    translate([pliers_holder_width() / 2, y])
                        circle(r = radius);
}

module pliers_holder_body() {
    r          = pliers_holder_rounding;
    top_r      = pliers_holder_top_rounding;
    arms       = pliers_holder_arms_height;
    middle_top = pliers_holder_middle_top();
    top        = pliers_holder_top();

    intersection() {
        difference() {
            union() {
                // Middle block and arms up to the top of the arms.
                ff_offset_sweep(pliers_holder_bottom_path(), height = arms, top = os_circle(r = top_r), steps = 6);

                // Middle block above the arms. Its front face is 0.01 mm behind the front of the bottom
                // layer, so it does not touch the U shaped gap between the arms.
                difference() {
                    up(arms / 2)
                        ff_offset_sweep(
                            pliers_holder_block_path(-2 * r, pliers_holder_depth - 0.01),
                            height = middle_top - arms / 2,
                            top    = os_circle(r = top_r),
                            steps  = 6
                        );

                    pliers_holder_trough_cut();
                }

                // Back block with the tongue.
                up(arms / 3)
                    ff_offset_sweep(
                        pliers_holder_block_path(-2 * r, pliers_holder_back_depth()),
                        height = top - arms / 3,
                        top    = os_circle(r = top_r),
                        steps  = 6
                    );
            }

            pliers_holder_hole();
        }

        translate([0, 0, -1])
            cube([pliers_holder_width(), pliers_holder_depth + pliers_holder_arms_length + 1, top + 2]);
    }
}

// Parameters on the back face below the tongue.
module pliers_holder_label(params) {
    width       = pliers_holder_width();
    area_top    = pliers_holder_top() - ff_slot_bottom_offset() - 2;
    area_bottom = 2;

    ff_engrave_params(
        params,
        [width / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = width - 4,
        max_height = area_top - area_bottom
    );
}

module feature_pliers_holder() {
    assert(
        pliers_holder_depth >= 2 * pliers_holder_hole_border_padding + pliers_holder_hole_diameter,
        str("pliers_holder_depth must be at least 2 x pliers_holder_hole_border_padding + pliers_holder_hole_diameter (",
            2 * pliers_holder_hole_border_padding + pliers_holder_hole_diameter, " mm).")
    );
    assert(
        pliers_holder_center_trough_height <= (pliers_holder_hole_diameter + pliers_holder_hole_border_padding) / 2,
        str("pliers_holder_center_trough_height must not be larger than half the trough width (",
            (pliers_holder_hole_diameter + pliers_holder_hole_border_padding) / 2, " mm).")
    );
    assert(
        pliers_holder_middle_top() - pliers_holder_center_trough_height >= pliers_holder_arms_height + 1,
        "The middle block is too low for the trough and the arms, decrease pliers_holder_opening_height_ratio, pliers_holder_center_trough_height or pliers_holder_arms_height."
    );
    assert(
        pliers_holder_arms_length == 0
            || pliers_holder_arms_length > pliers_holder_hole_diameter / 2 + pliers_holder_arms_width / 2,
        str("pliers_holder_arms_length must be 0 (no arms) or longer than ",
            pliers_holder_hole_diameter / 2 + pliers_holder_arms_width / 2, " mm.")
    );
    assert(
        pliers_holder_arms_width <= pliers_holder_width() / 2 - 1,
        str("pliers_holder_arms_width must not be larger than ", pliers_holder_width() / 2 - 1, " mm.")
    );

    params = pliers_holder_params();

    ff_echo_file_name("pliers-holder", params);

    difference() {
        ff_holder(pliers_holder_width(), pliers_holder_top())
            pliers_holder_body();

        pliers_holder_label(params);
    }
}
