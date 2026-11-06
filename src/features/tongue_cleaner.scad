//
// Tongue cleaner
//
// A hand tool that cleans slots, e.g. the slots milled into wooden anchors with the M5 T-slot
// router bit. Its front edge has the cross section of a tongue (head and neck) and is cut into
// barbed teeth, so it slides into a slot from its end and scrapes out chips and dust when it is
// pulled through. The teeth of each half point towards the middle, so the tool cleans in both
// directions. The neck widens into a flat handle with a hole for the fingers.
// `tongue_cleaner_width` is the length of the toothed edge, the handle and the hole grow with it.
//
// Orientation: the cleaner lies flat. The toothed edge runs along x at the place where a holder
// carries its tongue (its back at y = -ff_tongue_depth(), the mounting plane at y = 0), the handle
// extends to +y and the lowest point (the bottom of the head) is at z = 0.
//

// Distance between two teeth.
tongue_cleaner_tooth_pitch = 5;
// How far a tooth reaches along the edge, the rest of the pitch is the gap to the next tooth.
tongue_cleaner_tooth_length = 3.5;
// How deep the teeth are cut into the head of the tongue.
tongue_cleaner_tooth_depth = 3;
// Width of the tooth-free block in the middle of the edge.
tongue_cleaner_center_width = 10;
// Minimum width of the tooth-free blocks at both ends of the edge.
tongue_cleaner_end_width = 5;
// Length of the straight part of the handle, measured from the mounting plane. The half ellipse
// that closes the handle and the center of the finger hole start here.
tongue_cleaner_handle_length = 60;
// Distance of the finger hole to the sides of the handle.
tongue_cleaner_hole_margin = 15;
tongue_cleaner_hole_height = 50.4;

function tongue_cleaner_params() = [
    ["w", tongue_cleaner_width]
];

// Dimensions of the tongue cross section (ff_tongue_2d), they place the handle, the teeth and the label.
function tongue_cleaner_head_height() = ff_head_height() - 2 * print_tolerance;
function tongue_cleaner_head_depth()  = ff_head_depth() - 2 * print_tolerance;
function tongue_cleaner_neck_depth()  = ff_neck_depth() + print_tolerance;
// The handle is as thick as the neck of a tongue, a hair thinner so its faces do not lie in the
// faces of the neck it overlaps (that leaves non manifold edges).
function tongue_cleaner_thickness()   = ff_neck_height() - 2 * print_tolerance - 2 * ff_eps;
function tongue_cleaner_back()        = -ff_tongue_depth();
// Center line of the head and the handle.
function tongue_cleaner_center_z()    = tongue_cleaner_head_height() / 2;

function tongue_cleaner_teeth_per_side() =
    max(0, floor(
        (tongue_cleaner_width / 2 - tongue_cleaner_center_width / 2 - tongue_cleaner_end_width) / tongue_cleaner_tooth_pitch
    ));

// x positions of the flat back sides of the teeth on the left half, the teeth point to +x.
function tongue_cleaner_tooth_bases() =
    let(count = tongue_cleaner_teeth_per_side())
    count < 1 ? [] : [
        for (i = [1 : count])
            tongue_cleaner_width / 2 - tongue_cleaner_center_width / 2 - i * tongue_cleaner_tooth_pitch
    ];

// Outline of the handle in the (x, y) plane. It starts at the back of the head and stays ff_eps
// inside the ends and the back of the head, so no faces coincide.
function tongue_cleaner_handle_path() =
    let(
        w     = tongue_cleaner_width,
        e     = ff_eps,
        y0    = tongue_cleaner_back() + e,
        yc    = tongue_cleaner_handle_length,
        steps = 64
    )
    concat(
        [[e, y0], [w - e, y0]],
        [for (i = [0 : steps]) let(a = 180 * i / steps) [w / 2 + (w / 2 - e) * cos(a), yc + yc * sin(a)]]
    );

function tongue_cleaner_hole_path() =
    let(
        a     = tongue_cleaner_width / 2 - tongue_cleaner_hole_margin,
        b     = tongue_cleaner_hole_height / 2,
        steps = 96
    )
    [for (i = [0 : steps - 1]) let(t = 360 * i / steps) [tongue_cleaner_width / 2 + a * cos(t), tongue_cleaner_handle_length + b * sin(t)]];

// Material that stays in the toothed part of the head, in the (x, z) plane with z = 0 on the
// center line: the blocks at the ends and in the middle and the triangular teeth.
module tongue_cleaner_teeth_2d() {
    w      = tongue_cleaner_width;
    height = tongue_cleaner_head_height() + 2 * ff_eps;
    bases  = tongue_cleaner_tooth_bases();
    last   = len(bases) > 0 ? bases[len(bases) - 1] : w / 2 - tongue_cleaner_center_width / 2;

    translate([-ff_eps, -height / 2]) square([last + ff_eps, height]);
    translate([w - last, -height / 2]) square([last + ff_eps, height]);
    translate([w / 2 - tongue_cleaner_center_width / 2, -height / 2]) square([tongue_cleaner_center_width, height]);

    for (x = bases) {
        polygon([[x, -height / 2], [x + tongue_cleaner_tooth_length, 0], [x, height / 2]]);
        polygon([[w - x, -height / 2], [w - x, height / 2], [w - x - tongue_cleaner_tooth_length, 0]]);
    }
}

// Cut body of the gaps between the teeth.
module tongue_cleaner_teeth_cut() {
    height = tongue_cleaner_head_height() + 2;

    translate([0, tongue_cleaner_back() + tongue_cleaner_tooth_depth, tongue_cleaner_center_z()])
        rotate([90, 0, 0])
            linear_extrude(height = tongue_cleaner_tooth_depth + 1)
                difference() {
                    translate([-1, -height / 2]) square([tongue_cleaner_width + 2, height]);
                    tongue_cleaner_teeth_2d();
                }
}

// Head and neck of the toothed edge: a tongue without the filament channel.
module tongue_cleaner_head() {
    translate([0, 0, tongue_cleaner_center_z()])
        ff_extrude_along_x(tongue_cleaner_width)
            ff_tongue_2d(filament = false);
}

// Flat handle with fully rounded edges.
module tongue_cleaner_handle() {
    thickness = tongue_cleaner_thickness();
    rounding  = thickness / 2 - 0.01;

    translate([0, 0, tongue_cleaner_center_z() - thickness / 2])
        ff_offset_sweep(
            tongue_cleaner_handle_path(),
            height = thickness,
            bottom = os_circle(r = rounding),
            top    = os_circle(r = rounding),
            steps  = 8
        );
}

// Finger hole with rounded edges.
module tongue_cleaner_hole_cut() {
    thickness = tongue_cleaner_thickness();
    rounding  = thickness / 2 - 0.01;

    translate([0, 0, tongue_cleaner_center_z() - thickness / 2])
        ff_offset_sweep(
            tongue_cleaner_hole_path(),
            height = thickness,
            bottom = os_circle(r = -rounding, extra = 1),
            top    = os_circle(r = -rounding, extra = 1),
            steps  = 8
        );
}

// Parameters on the top face of the handle, between the head and the finger hole.
module tongue_cleaner_label(params) {
    area_front = -tongue_cleaner_neck_depth() + 4;
    area_back  = tongue_cleaner_handle_length - tongue_cleaner_hole_height / 2 - 4;

    ff_engrave_params(
        params,
        [tongue_cleaner_width / 2, (area_front + area_back) / 2, tongue_cleaner_center_z() + tongue_cleaner_thickness() / 2],
        "top",
        max_width  = tongue_cleaner_width - 24,
        max_height = area_back - area_front
    );
}

module feature_tongue_cleaner() {
    assert(
        tongue_cleaner_width >= tongue_cleaner_center_width + 2 * (tongue_cleaner_end_width + tongue_cleaner_tooth_pitch),
        str("tongue_cleaner_width must be at least ", tongue_cleaner_center_width + 2 * (tongue_cleaner_end_width + tongue_cleaner_tooth_pitch), " mm.")
    );
    assert(
        tongue_cleaner_head_depth() > tongue_cleaner_tooth_depth + 0.5,
        "The head of the slot profile is too shallow for the teeth."
    );

    params = tongue_cleaner_params();

    ff_echo_file_name("tongue-cleaner", params);

    difference() {
        union() {
            tongue_cleaner_head();
            tongue_cleaner_handle();
        }

        tongue_cleaner_teeth_cut();
        tongue_cleaner_hole_cut();
        tongue_cleaner_label(params);
    }
}
