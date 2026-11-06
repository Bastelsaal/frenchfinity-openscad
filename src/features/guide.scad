//
// Guide
//
// A woodworking jig that sets up the machines for wooden Frenchfinity parts in a reproducible way.
// Its side profile is a right triangle with 45 degree legs: lay the bevel against the blade to set
// the table saw to 45 degrees for the bevel of the wooden cleats. The back face carries a T-slot
// at the position the M5 T-slot router bit has to cut (as far below the top of the bevel as the
// slot of an anchor lies below its top edge), so the router bit height can be set by sliding the
// guide over the bit. `guide_width` is the length of the guide, `guide_extra_padding` adds a block
// on top of the bevel that makes the guide taller (the slot keeps its distance to the bevel).
//
// The slot has the nominal size of the slot profile (without the filament channel), so the router
// bit that mills the slots fits into it. Frenchfinity 1.0 used the smaller size of a tongue here.
//
// Orientation: the back face with the slot lies in the plane y = 0 and faces -y, the bevel faces
// the front and the bottom, the lowest point (the rounded lower edge of the bevel) is at z = 0.
//

// Leg length of the 45 degree triangle.
guide_bevel_size = 50;
// Radius of the rounded edges at the ends of the bevel.
guide_bevel_rounding = 1;

function guide_params() = [
    ["w", guide_width],
    ["ep", guide_extra_padding]
];

// Height of the rounded lower edge above the sharp corner of the triangle, it moves the part down
// so its lowest point lies at z = 0.
function guide_bottom_offset() = guide_bevel_rounding * sqrt(2);

// Top of the 45 degree triangle, the slot is placed relative to it.
function guide_bevel_top() = guide_bevel_size - guide_bottom_offset();

function guide_top() = guide_bevel_top() + guide_extra_padding;

// Side profile in the (y, z) plane.
module guide_profile_2d() {
    size = guide_bevel_size;
    path = guide_extra_padding > 0
        ? [[0, 0], [size, size], [size, size + guide_extra_padding], [0, size + guide_extra_padding]]
        : [[0, 0], [size, size], [0, size]];
    radius = guide_extra_padding > 0
        ? [guide_bevel_rounding, guide_bevel_rounding, 0, 0]
        : [guide_bevel_rounding, guide_bevel_rounding, 0];

    translate([0, -guide_bottom_offset()])
        polygon(round_corners(path, radius = radius, $fn = 32));
}

// Cross section of the slot: the slot profile without the filament channel, mirrored so it is cut
// into +y, its narrow neck opens to the back face at y = 0.
module guide_slot_2d() {
    mirror([1, 0])
        ff_slot_2d(filament = false);
}

// Parameters on the top face.
module guide_label(params) {
    ff_engrave_params(
        params,
        [guide_width / 2, guide_bevel_size / 2 - 2, guide_top()],
        "top",
        max_width  = guide_width - 10,
        max_height = guide_bevel_size - 16
    );
}

module feature_guide() {
    assert(guide_width > 0, "guide_width must be larger than 0.");
    assert(guide_extra_padding >= 0, "guide_extra_padding must not be negative.");
    assert(
        guide_bevel_top() - ff_slot_bottom_offset() > guide_bevel_rounding + 2,
        "The slot does not fit into the guide, the slot profile is too large."
    );

    params = guide_params();

    ff_echo_file_name("guide", params);

    difference() {
        ff_profile_extrude(guide_width)
            guide_profile_2d();

        translate([-ff_eps, 0, ff_slot_z(guide_bevel_top())])
            ff_extrude_along_x(guide_width + 2 * ff_eps)
                guide_slot_2d();

        guide_label(params);
    }
}
