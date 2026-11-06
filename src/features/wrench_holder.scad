//
// Wrench holder
//
// Holds open-end wrenches hanging one behind the other: two rails reach forward from a back block and
// the heads of the wrenches rest on them, kept apart by teeth on the inner faces of the rails. The
// cross section of the rails follows the Frenchfinity 1.0 design (shaped for the angled jaw of an
// open-end wrench) and is scaled by wrench_holder_scale to the size of the wrenches. The rails are
// wrench_holder_width long (Frenchfinity 1.0 calls this length "width"), the teeth are
// wrench_holder_wrench_width + wrench_holder_slot_separator_width apart, as many as
// ceil(width x scale / (wrench width + separator height)) + 1 like in 1.0. The back block is rounded
// at its top front edge and carries the tongue, the parameters are engraved into its bottom face.
//

// Depth of the back block (Frenchfinity 1.0).
wrench_holder_back_depth = 15;

// The back block reaches this high above the top of the rails (Frenchfinity 1.0).
wrench_holder_back_height = 7.394;

// Radius of the rounded top front edge of the back block (Frenchfinity 1.0).
wrench_holder_hump_radius = 12;

// Height of the rails at scale 1 (Frenchfinity 1.0).
wrench_holder_rail_height = 11.25;

// Length of the tongue: wrench_holder_tongue_base + wrench_holder_tongue_per_scale x scale (1.0).
wrench_holder_tongue_base      = 20.5;
wrench_holder_tongue_per_scale = 14.12;

// Width of the teeth at their top, measured from the inner edge of the rail, per mm of separator width
// and for a separator factor of 1 (Frenchfinity 1.0: slot_separator_width x 2 / 1 / 0.6 depending on
// the scale). The inner edge of the left teeth is vertical, the one of the right teeth leans outwards by
// wrench_holder_right_tooth_slope per mm.
wrench_holder_left_tooth_per_separator  = 8.73 / 2 / 3;
wrench_holder_right_tooth_per_separator = 3.48 / 3;
wrench_holder_right_tooth_slope         = 0.198;

// Segments per arc of the rail profile.
wrench_holder_arc_segments = 24;

function wrench_holder_params() = [
    ["ww", wrench_holder_wrench_width],
    ["w", wrench_holder_width],
    ["s", wrench_holder_scale]
];

// Points of the circular arc from p0 to p1 with radius r. `side` (1 or -1) picks the center on the
// left or right of the chord.
function wrench_holder_arc(p0, p1, r, side) =
    let(
        n      = wrench_holder_arc_segments,
        chord  = p1 - p0,
        length = norm(chord),
        normal = [-chord[1], chord[0]] / length,
        center = (p0 + p1) / 2 + side * sqrt(r * r - length * length / 4) * normal,
        a0     = atan2(p0[1] - center[1], p0[0] - center[0]),
        a1     = atan2(p1[1] - center[1], p1[0] - center[0]),
        da     = (a1 - a0 + 540) % 360 - 180
    )
    [for (i = [0 : n]) center + r * [cos(a0 + da * i / n), sin(a0 + da * i / n)]];

// Cross sections at scale 1, in a (x, z) frame with x = 0 in the middle of the holder and z = 0 at the
// top of the rails (traced from the Frenchfinity 1.0 sketch).
function wrench_holder_left_outer() = wrench_holder_arc([-24.25, 0], [-14.12, -11.25], 34.509, 1);
function wrench_holder_right_outer() = wrench_holder_arc([19.66, -11.25], [24.24, 0], 34.036, -1);

function wrench_holder_left_rail_points() = concat(
    wrench_holder_left_outer(),
    wrench_holder_arc([-5.98, -11.25], [-10.146, -6.738], 19.633, 1),
    wrench_holder_arc([-12.618, -4.795], [-17.13, 0], 26.361, -1)
);

function wrench_holder_right_rail_points() = concat(
    wrench_holder_right_outer(),
    wrench_holder_arc([17.36, 0], [13.62, -11.25], 32.447, 1)
);

// Region between the outer faces of both rails (the back block below the top of the rails).
function wrench_holder_hull_points() = concat(wrench_holder_left_outer(), wrench_holder_right_outer());

function wrench_holder_body_width() = 48.49 * wrench_holder_scale;

function wrench_holder_tongue_length() =
    wrench_holder_tongue_base + wrench_holder_tongue_per_scale * wrench_holder_scale;

// Width of the part: the tongue is wider than the body on small scales.
function wrench_holder_part_width() = max(wrench_holder_body_width(), wrench_holder_tongue_length());

// Top of the part, chosen so the lowest point (rails or tongue) is at z = 0.
function wrench_holder_top() =
    max(
        wrench_holder_back_height + wrench_holder_rail_height * wrench_holder_scale,
        ff_tongue_bottom_offset()
    );

function wrench_holder_rail_top() = wrench_holder_top() - wrench_holder_back_height;

function wrench_holder_depth() = wrench_holder_back_depth + wrench_holder_width;

// Places a scale 1 cross section on the part.
module wrench_holder_place_2d() {
    translate([wrench_holder_part_width() / 2, wrench_holder_rail_top()])
        scale(wrench_holder_scale)
            children();
}

module wrench_holder_back_block() {
    width  = wrench_holder_part_width();
    top    = wrench_holder_top();
    depth  = wrench_holder_back_depth;
    radius = wrench_holder_hump_radius;

    intersection() {
        ff_extrude_along_y(0, depth)
            union() {
                wrench_holder_place_2d()
                    polygon(wrench_holder_hull_points());

                translate([(width - wrench_holder_body_width()) / 2, wrench_holder_rail_top() - ff_eps])
                    square([wrench_holder_body_width(), wrench_holder_back_height + ff_eps]);
            }

        // Rounded top front edge.
        ff_profile_extrude(width)
            union() {
                translate([-1, -1])
                    square([depth - radius + 1, top + 1]);

                translate([-1, -1])
                    square([depth + 1, top - radius + 1]);

                translate([depth - radius, top - radius])
                    circle(r = radius, $fa = 3);
            }
    }
}

// The rails start at the front face of the back block and are 0.01 mm smaller than its outline:
// coincident faces or edges would leave non-manifold edges.
module wrench_holder_rails() {
    ff_extrude_along_y(wrench_holder_back_depth, wrench_holder_depth())
        wrench_holder_place_2d()
            offset(delta = -0.01 / wrench_holder_scale) {
                polygon(wrench_holder_left_rail_points());
                polygon(wrench_holder_right_rail_points());
            }
}

// Number of teeth (Frenchfinity 1.0: calculated_slot_count + 1).
function wrench_holder_tooth_count() =
    ceil(wrench_holder_width * wrench_holder_scale / (wrench_holder_wrench_width + wrench_holder_slot_separator_height)) + 1;

// Cross section of the teeth: the part of the space between the rails that reaches up to a line next to
// the inner top edge of each rail. A hair smaller than the rails, so their faces never coincide.
module wrench_holder_teeth_2d() {
    s      = wrench_holder_scale;
    left   = wrench_holder_slot_separator_width * wrench_holder_left_tooth_per_separator
             * (s > 0.79 ? 2 : s > 0.55 ? 1 : 0.6);
    right  = wrench_holder_slot_separator_width * wrench_holder_right_tooth_per_separator
             * (s > 0.55 ? 1 : 0.6);
    slope  = wrench_holder_right_tooth_slope;

    wrench_holder_place_2d()
        offset(delta = -0.01 / s)
            intersection() {
                polygon(wrench_holder_hull_points());

                union() {
                    translate([-30, -20])
                        square([30 - 17.13 + left / s, 20]);

                    polygon([
                        [17.36 - right / s, 0],
                        [30, 0],
                        [30, -20],
                        [17.36 - right / s + 20 * slope, -20]
                    ]);
                }
            }
}

module wrench_holder_teeth() {
    pitch  = wrench_holder_wrench_width + wrench_holder_slot_separator_width;
    length = wrench_holder_slot_separator_height;
    front  = wrench_holder_depth();

    for (i = [0 : wrench_holder_tooth_count() - 1]) {
        from = front - length - i * pitch;

        // Teeth inside the back block are left out.
        if (from + length > wrench_holder_back_depth)
            ff_extrude_along_y(max(from, wrench_holder_back_depth), from + length)
                wrench_holder_teeth_2d();
    }
}

module wrench_holder_tongue() {
    length = wrench_holder_tongue_length();

    translate([(wrench_holder_part_width() - length) / 2, 0, 0])
        ff_tongue(length, wrench_holder_top());
}

// Parameters on the bottom face of the back block, reading along the depth.
module wrench_holder_label(params) {
    s     = wrench_holder_scale;
    // Flat bottom of the back block between the outer faces of the rails.
    left  = -14.12 * s;
    right = 19.66 * s;

    ff_engrave_params(
        params,
        [
            wrench_holder_part_width() / 2 + (left + right) / 2,
            wrench_holder_back_depth / 2,
            wrench_holder_rail_top() - wrench_holder_rail_height * s
        ],
        "bottom",
        max_width  = right - left - 2,
        max_height = wrench_holder_back_depth - 2,
        rotation   = 90
    );
}

module feature_wrench_holder() {
    assert(wrench_holder_scale > 0, "wrench_holder_scale must be larger than 0.");
    assert(wrench_holder_width > 0, "wrench_holder_width must be larger than 0.");
    assert(
        wrench_holder_wrench_width + wrench_holder_slot_separator_width > wrench_holder_slot_separator_height,
        "The slots between the teeth must be wider than the teeth."
    );

    params = wrench_holder_params();

    ff_echo_file_name("wrench-holder", params);

    difference() {
        union() {
            wrench_holder_back_block();
            wrench_holder_rails();
            wrench_holder_teeth();
            wrench_holder_tongue();
        }

        wrench_holder_label(params);
    }
}
