//
// Bin
//
// An open bin for small parts (contributed by JGoodwillieV): a full height back wall with the
// tongue, a low front wall (bin_lip_height) and side walls that run flat from the back wall to the
// middle of the bin and then slope down to the front wall, so the parts are easy to reach. All
// sizes are outer sizes, the walls and the floor are bin_wall_thickness thick.
//

// Share of the depth (from the back wall) over which the side walls stay at full height.
bin_flat_top_share = 0.6;

function bin_params() = [
    ["w", bin_width],
    ["d", bin_depth],
    ["h", bin_height],
    ["lh", bin_lip_height],
    ["wt", bin_wall_thickness]
];

// Side profile in the (y, z) plane: full height at the back wall (y = 0), sloping down to the front wall.
module bin_side_profile_2d() {
    polygon([
        [0, 0],
        [bin_depth, 0],
        [bin_depth, bin_lip_height],
        [bin_depth * bin_flat_top_share, bin_height],
        [0, bin_height]
    ]);
}

module bin_body() {
    t = bin_wall_thickness;

    union() {
        // Floor, back wall and front wall.
        cube([bin_width, bin_depth, t]);
        cube([bin_width, t, bin_height]);

        translate([0, bin_depth - t, 0])
            cube([bin_width, t, bin_lip_height]);

        // Side walls.
        for (x = [0, bin_width - t])
            translate([x, 0, 0])
                ff_extrude_along_x(t)
                    bin_side_profile_2d();
    }
}

// Parameters on the bottom face, along the longer side of it.
module bin_label(params) {
    ff_engrave_params(
        params,
        [bin_width / 2, bin_depth / 2, 0],
        "bottom",
        max_width  = bin_width - 4,
        max_height = bin_depth - 4,
        rotation   = bin_depth > bin_width ? 90 : 0
    );
}

module feature_bin() {
    assert(bin_wall_thickness >= 1, "bin_wall_thickness must be at least 1 mm.");
    assert(
        bin_width >= 2 * bin_wall_thickness + 1 && bin_depth >= 2 * bin_wall_thickness + 1,
        "bin_width and bin_depth must be larger than two walls."
    );
    assert(bin_height >= ff_min_height(), str("bin_height must be at least ", ff_min_height(), " mm to carry the tongue."));
    assert(
        bin_lip_height >= bin_wall_thickness && bin_lip_height <= bin_height,
        "bin_lip_height must be between bin_wall_thickness and bin_height."
    );

    params = bin_params();

    ff_echo_file_name("bin", params);

    difference() {
        ff_holder(bin_width, bin_height)
            bin_body();

        // Skip the text if the floor is too thin for it.
        if (bin_wall_thickness > 2 * text_depth)
            bin_label(params);
    }
}
