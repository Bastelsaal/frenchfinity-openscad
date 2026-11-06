//
// Hammer holder
//
// Holds one hammer hanging head up: the handle hangs down through a U shaped gap
// (hammer_holder_handle_hole_width wide), the head rests on the bottom plate in a shallow crater that
// keeps it centered. A lip at the front (hammer_holder_drop_protection_height high,
// hammer_holder_drop_protection_width thick) keeps the head from sliding off. The resting area is
// hammer_holder_hammer_width + 2 x hammer_holder_hammer_padding + hammer_holder_drop_protection_width
// + 2 mm deep (Frenchfinity 1.0). A back plate that gets thinner towards the top carries the tongue.
//

// The resting area is this much deeper than hammer width, paddings and lip (Frenchfinity 1.0).
hammer_holder_area_extra = 2;

// Segments of the crater profile.
hammer_holder_crater_segments = 24;

// Depth of the area the head rests on.
function hammer_holder_area_depth() =
    hammer_holder_hammer_width + 2 * hammer_holder_hammer_padding + hammer_holder_drop_protection_width
    + hammer_holder_area_extra;

function hammer_holder_depth() =
    hammer_holder_back_thickness + hammer_holder_area_depth() + hammer_holder_drop_protection_width;

function hammer_holder_params() = concat(
    [
        ["w", hammer_holder_width],
        ["hw", hammer_holder_hammer_width],
        ["hhw", hammer_holder_handle_hole_width],
        ["dph", hammer_holder_drop_protection_height],
        ["dpw", hammer_holder_drop_protection_width]
    ],
    // Not part of the Frenchfinity 1.0 file name: only listed when they differ from their default.
    ff_optional_params([
        ["h", hammer_holder_height, 50],
        ["bh", hammer_holder_bottom_height, 15],
        ["cd", hammer_holder_crater_depth, 1.5],
        ["hp", hammer_holder_hammer_padding, 2],
        ["bt", hammer_holder_back_thickness, 10],
        ["bw", hammer_holder_back_angle_width_top, 4]
    ])
);

// Crater profile from the back plate to the lip: depth x (1 - |d|^3) over the relative distance d from
// the middle (close to the spline of Frenchfinity 1.0).
function hammer_holder_crater_points() =
    let(
        start = hammer_holder_back_thickness,
        depth = hammer_holder_area_depth(),
        top   = hammer_holder_bottom_height,
        n     = hammer_holder_crater_segments
    )
    [
        for (i = [1 : n - 1])
            let(d = 2 * i / n - 1)
                [start + depth * i / n, top - hammer_holder_crater_depth * (1 - pow(abs(d), 3))]
    ];

// Side profile (y, z) of the bottom plate with the crater and the lip at the front.
module hammer_holder_bottom_profile_2d() {
    depth  = hammer_holder_depth();
    lip    = hammer_holder_drop_protection_width;
    top    = hammer_holder_bottom_height;
    crater = hammer_holder_crater_points();

    polygon(concat(
        [
            [0, 0],
            [depth, 0],
            [depth, top + hammer_holder_drop_protection_height],
            [depth - lip, top + hammer_holder_drop_protection_height],
            [depth - lip, top]
        ],
        [for (i = [len(crater) - 1 : -1 : 0]) crater[i]],
        [
            [hammer_holder_back_thickness, top],
            [0, top]
        ]
    ));
}

// Side profile (y, z) of the back plate, thinner towards the top. It reaches a bit into the bottom plate
// and its front face meets the crater 0.01 mm in front of the crater's edge: faces or edges that
// coincide with the bottom plate would leave non-manifold edges.
module hammer_holder_back_profile_2d() {
    sink   = 0.1;
    foot   = hammer_holder_back_thickness + 0.01;
    slope  = (foot - hammer_holder_back_angle_width_top) / (hammer_holder_height - hammer_holder_bottom_height);

    polygon([
        [0, hammer_holder_bottom_height - sink],
        [foot + slope * sink, hammer_holder_bottom_height - sink],
        [hammer_holder_back_angle_width_top, hammer_holder_height],
        [0, hammer_holder_height]
    ]);
}

// U shaped gap for the handle through the bottom plate and the lip, centered in the resting area and
// open to the front. Like in Frenchfinity 1.0 it does not cut the back plate.
module hammer_holder_handle_gap() {
    radius = hammer_holder_handle_hole_width / 2;
    center = [hammer_holder_width / 2, hammer_holder_back_thickness + hammer_holder_area_depth() / 2];

    translate([0, 0, -1])
        linear_extrude(height = hammer_holder_bottom_height + hammer_holder_drop_protection_height + 2)
            hull() {
                translate(center)
                    circle(r = radius);

                translate([center[0] - radius, hammer_holder_depth() + 1])
                    square([2 * radius, 1]);
            }
}

module hammer_holder_body() {
    difference() {
        ff_profile_extrude(hammer_holder_width)
            hammer_holder_bottom_profile_2d();

        hammer_holder_handle_gap();
    }

    ff_profile_extrude(hammer_holder_width)
        hammer_holder_back_profile_2d();
}

// Parameters on the back face below the tongue.
module hammer_holder_label(params) {
    area_top    = hammer_holder_height - ff_slot_bottom_offset() - 2;
    area_bottom = 2;

    ff_engrave_params(
        params,
        [hammer_holder_width / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = hammer_holder_width - 4,
        max_height = area_top - area_bottom
    );
}

module feature_hammer_holder() {
    assert(
        hammer_holder_handle_hole_width <= hammer_holder_width - 4,
        str("hammer_holder_handle_hole_width must be at most hammer_holder_width - 4 mm (", hammer_holder_width - 4, " mm).")
    );
    assert(
        hammer_holder_back_thickness + hammer_holder_area_depth() / 2 - hammer_holder_handle_hole_width / 2 >= 2,
        "The handle gap reaches the mounting plane, decrease hammer_holder_handle_hole_width or increase hammer_holder_hammer_width."
    );
    assert(
        hammer_holder_crater_depth < hammer_holder_bottom_height,
        "hammer_holder_crater_depth must be smaller than hammer_holder_bottom_height."
    );
    assert(
        hammer_holder_back_angle_width_top <= hammer_holder_back_thickness,
        "hammer_holder_back_angle_width_top must not be larger than hammer_holder_back_thickness."
    );
    assert(
        hammer_holder_height >= max(ff_min_height(), hammer_holder_bottom_height + hammer_holder_drop_protection_height),
        str("hammer_holder_height must be at least ",
            max(ff_min_height(), hammer_holder_bottom_height + hammer_holder_drop_protection_height), " mm.")
    );

    params = hammer_holder_params();

    ff_echo_file_name("hammer-holder", params);

    difference() {
        ff_holder(hammer_holder_width, hammer_holder_height)
            hammer_holder_body();

        hammer_holder_label(params);
    }
}
