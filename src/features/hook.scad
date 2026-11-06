//
// Hook
//
// A J shaped hook for cables, hoses, bags and anything else with a loop. A flat back plate with
// the tongue runs down from the top edge (hook_height is the total height) into a half circle
// whose outer diameter is hook_hook_diameter, so the hook reaches hook_hook_diameter from the
// wall. Its free end rises hook_hook_end_height above the center of the half circle and ends in
// a round tip. Everything is hook_thickness thick and hook_width wide, the edges on the inside of
// the hook (where the load hangs) are fully rounded like in Frenchfinity 1.0.
//
// The hook is one extruded side view, the roundings are cut from it: pieces that touch in a face
// leave non manifold edges in the exported mesh.
//

// The top face of the back plate drops towards the front by this angle (Frenchfinity 1.0).
hook_top_slope = 6;

function hook_params() = [
    ["w", hook_width],
    ["h", hook_height],
    ["hd", hook_hook_diameter],
    ["t", hook_thickness],
    ["heh", hook_hook_end_height]
];

function hook_radius() = hook_hook_diameter / 2;

// Radius of the rounded inner edges: half the thickness, like the round tip.
function hook_rounding() = hook_thickness / 2;

// z of the center of the round tip.
function hook_tip_z() = hook_radius() + hook_hook_end_height - hook_rounding();

// z of the top face of the back plate at the distance y from the mounting plane.
function hook_top_at(y) = hook_height - y * tan(hook_top_slope);

// How far the rounding cuts may reach into the opening of the hook.
function hook_reach() = min(1, (hook_hook_diameter - 2 * hook_thickness) / 2 - 0.01);

// Side view (y, z): back plate, half ring, free end and round tip.
module hook_profile_2d() {
    r  = hook_radius();
    t  = hook_thickness;
    rc = hook_rounding();
    zc = hook_tip_z();

    polygon([[0, r], [t, r], [t, hook_top_at(t)], [0, hook_height]]);

    intersection() {
        translate([r, r])
            difference() {
                circle(r = r);
                circle(r = r - t);
            }

        translate([-1, -1])
            square([2 * r + 2, r + 1]);
    }

    if (zc > r)
        translate([2 * r - t, r])
            square([t, zc - r]);

    translate([2 * r - rc, zc])
        circle(r = rc);
}

// Cut that rounds an inner edge: the region of the corner (u <= 0 is outside the side face,
// v <= 0 is the free space in front of the inner face) outside the rounding circle. The circle is
// moved 0.01 mm towards the corner, so it crosses both faces instead of touching them.
module hook_edge_cut_2d(radius, reach) {
    difference() {
        translate([-1, -reach])
            square([1 + radius, reach + radius]);

        translate([radius - 0.01, radius - 0.01])
            circle(r = radius);
    }
}

// Rounding cuts of the inner edges on the side x = 0.
module hook_rounding_cuts() {
    r     = hook_radius();
    t     = hook_thickness;
    rc    = hook_rounding();
    zc    = hook_tip_z();
    reach = hook_reach();
    // The front view of the tip gets rounded corners with a slightly larger radius: equal
    // cylinders that cross at right angles touch tangentially.
    rf    = rc + 0.2;
    // The straight cuts start a quarter segment of the inner circle below the center of the half
    // ring (its vertices lie whole or half segments away from it), a cut that ends in the plane
    // of a row of vertices leaves non manifold edges. ff_fn(radius, 5) is the number of segments
    // OpenSCAD uses for that circle.
    start = r - (r - t) * sin(90 / ff_fn(r - t, 5));

    // Back plate: corner at y = t, the free space lies at y > t.
    translate([0, t, start])
        mirror([0, 1, 0])
            linear_extrude(height = hook_height + 1 - start)
                hook_edge_cut_2d(rc, reach);

    // Free end and the inner side of the tip: corner at y = 2r - t, the free space at y < 2r - t.
    translate([0, 2 * r - t, start])
        linear_extrude(height = zc + rc + 1 - start)
            hook_edge_cut_2d(rc, reach);

    // Half ring: rotate_extrude coordinates X = distance from the axis, Y = position along the
    // axis (x). It reaches 2 degrees into the straight parts, its circle is 0.02 mm larger, so it
    // stays inside their cuts where they overlap.
    multmatrix([[0, 0, 1, 0], [-1, 0, 0, r], [0, -1, 0, r], [0, 0, 0, 1]])
        rotate([0, 0, -2])
            rotate_extrude(angle = 184)
                translate([r - t, 0])
                    rotate([0, 0, 90])
                        mirror([0, 1, 0])
                            hook_edge_cut_2d(rc + 0.02, min(reach, r - t - 0.01));

    // Front view of the tip: rounded top corners.
    translate([0, 2 * r + 1, 0])
        rotate([90, 0, 0])
            linear_extrude(height = t + 1 + reach)
                difference() {
                    translate([-1, zc])
                        square([1 + rf, rc + 1]);

                    translate([rf - 0.01, zc])
                        circle(r = rf);
                }
}

// Parameters on the back face of the back plate, reading upwards.
module hook_label(params) {
    area_top    = hook_height - ff_slot_bottom_offset() - 2;
    area_bottom = hook_radius() + 1;

    ff_engrave_params(
        params,
        [hook_width / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = hook_width - 2,
        max_height = area_top - area_bottom,
        rotation   = 90
    );
}

module feature_hook() {
    assert(hook_width >= hook_thickness + 1, "hook_width must be at least hook_thickness + 1 mm.");
    assert(hook_thickness >= 1, "hook_thickness must be at least 1 mm.");
    assert(
        hook_hook_diameter >= 2 * hook_thickness + 1,
        "hook_hook_diameter must be at least 2 x hook_thickness + 1 mm, otherwise the hook has no opening."
    );
    assert(
        hook_hook_end_height >= hook_rounding(),
        "hook_hook_end_height must be at least hook_thickness / 2 (the round tip)."
    );
    assert(
        hook_height >= hook_radius() + ff_min_height(),
        str(
            "hook_height must be at least hook_hook_diameter / 2 + ",
            ff_min_height(),
            " mm, so the straight back plate carries the tongue."
        )
    );

    params = hook_params();

    ff_echo_file_name("hook", params);

    difference() {
        ff_holder(hook_width, hook_height)
            ff_profile_extrude(hook_width)
                hook_profile_2d();

        hook_rounding_cuts();

        translate([hook_width, 0, 0])
            mirror([1, 0, 0])
                hook_rounding_cuts();

        hook_label(params);
    }
}
