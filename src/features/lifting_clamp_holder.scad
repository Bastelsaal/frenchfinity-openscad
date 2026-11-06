//
// Lifting clamp holder
//
// Hangs lifting clamps (board lifters with a flat foot plate) below a shelf: the foot plate of
// foot_width x foot_length x foot_height slides into a pocket from the front and rests on two lips,
// the body of the clamp hangs down through an opening of opening_width between them. The holder
// points lifting_clamp_holder_angle degrees upwards, so the clamp does not slide out by itself.
// All walls around the pocket are 10 mm thick, the pocket is `tolerance` larger than the foot on
// every side.
//

// Thickness of the walls around the pocket (Frenchfinity 1.0 "padding").
lifting_clamp_holder_padding = 10;
// Radius of the rounded edges of the pocket and the opening (Frenchfinity 1.0).
lifting_clamp_holder_rounding = 1;

function lifting_clamp_holder_params() = [
    ["fw", lifting_clamp_holder_foot_width],
    ["fh", lifting_clamp_holder_foot_height],
    ["fl", lifting_clamp_holder_foot_length],
    ["a", lifting_clamp_holder_angle],
    ["t", lifting_clamp_holder_tolerance],
    ["ow", lifting_clamp_holder_opening_width]
];

// [width, length (from the wall to the front), thickness] of the holder before it is tilted.
function lifting_clamp_holder_size() =
    let(
        padding   = lifting_clamp_holder_padding,
        tolerance = lifting_clamp_holder_tolerance
    )
    [
        lifting_clamp_holder_foot_width + 2 * padding,
        lifting_clamp_holder_foot_length + 2 * tolerance + padding,
        lifting_clamp_holder_foot_height + 2 * tolerance + 2 * padding
    ];

// Top edge on the wall: the holder is tilted around it, its lowest point (the lower back edge)
// ends up at z = 0.
function lifting_clamp_holder_top() = lifting_clamp_holder_size()[2] * cos(lifting_clamp_holder_angle);

// Cross section (x, z) of the pocket and the opening below it as a BOSL2 region, with the top of
// the holder at z = 0. The corners are rounded, also the ones where the opening leaves the bottom
// face (the region reaches below the bottom face for that).
function lifting_clamp_holder_cut_region(size, r) =
    let(
        padding       = lifting_clamp_holder_padding,
        pocket_width  = lifting_clamp_holder_foot_width + 2 * lifting_clamp_holder_tolerance,
        pocket_height = lifting_clamp_holder_foot_height + 2 * lifting_clamp_holder_tolerance,
        opening       = lifting_clamp_holder_opening_width,
        pocket        = rect([pocket_width, pocket_height], anchor = BACK),
        shapes        = [
            [move([size[0] / 2, -padding], pocket)],
            [move([size[0] / 2, -padding - pocket_height + r], rect([opening, size[2]], anchor = BACK))],
            [move([size[0] / 2, -size[2]], rect([size[0] + 10, 5], anchor = BACK))]
        ]
    )
    force_region(offset(offset(offset(union(shapes), r = r), r = -2 * r), r = r));

// The holder before it is tilted: top back edge on the x axis, extending to +y and down to -z.
module lifting_clamp_holder_body(size, r) {
    padding = lifting_clamp_holder_padding;

    difference() {
        // Rounded front edges (+y is BACK in BOSL2).
        cuboid(size, rounding = r, edges = BACK, anchor = FRONT + LEFT + TOP);

        // Pocket and opening, their edges on the front face are rounded as well.
        translate([0, size[1], 0])
            rotate([90, 0, 0])
                ff_offset_sweep(
                    lifting_clamp_holder_cut_region(size, r),
                    height = size[1] - padding,
                    bottom = os_circle(r = -r, extra = 1),
                    steps  = 6
                );

        // Parameters on the ceiling of the pocket, readable from below through the opening.
        ff_engrave_params(
            lifting_clamp_holder_params(),
            [size[0] / 2, (size[1] + padding) / 2, -padding],
            "bottom",
            max_width  = lifting_clamp_holder_opening_width - 4,
            max_height = size[1] - padding - 6
        );
    }
}

module feature_lifting_clamp_holder() {
    size   = lifting_clamp_holder_size();
    top    = lifting_clamp_holder_top();
    angle  = lifting_clamp_holder_angle;
    params = lifting_clamp_holder_params();
    r      = lifting_clamp_holder_rounding;

    assert(
        lifting_clamp_holder_opening_width > 2 * r + 1,
        "lifting_clamp_holder_opening_width is too small."
    );
    assert(
        lifting_clamp_holder_opening_width <= lifting_clamp_holder_foot_width - 4,
        "lifting_clamp_holder_opening_width must be smaller than lifting_clamp_holder_foot_width, the foot rests on both sides of the opening."
    );

    ff_echo_file_name("lifting-clamp-holder", params);

    ff_holder(size[0], top) {
        translate([0, 0, top])
            rotate([angle, 0, 0])
                lifting_clamp_holder_body(size, r);

        // Fills the wedge between the wall and the tilted back face.
        cube([size[0], size[2] * sin(angle) + ff_eps, top]);
    }
}
