//
// Screwdriver holder
//
// Holds one screwdriver upright. The handle rests in a round pocket (screwdriver_handle_width wide,
// screwdriver_inset_height deep) on top of a block, the shaft hangs down through a hole
// (screwdriver_stick_width wide) in the floor below the pocket. The hole opens to the front and widens
// by screwdriver_pull_out_tolerance per side, so the screwdriver can also be pulled out to the front.
// A back plate that gets thinner towards the top (screwdriver_back_width_max ->
// screwdriver_back_width_min) carries the tongue. The holder is screwdriver_padding_sides wider than the
// pocket on each side and screwdriver_handle_padding deeper in front of and behind the pocket.
//
// Parameters of this part are named screwdriver_..., its modules and functions screw_driver_...
//

// Radius of the rounded edges (Frenchfinity 1.0), smaller on thin walls.
screw_driver_max_rounding = 1;

// The body is built this much wider on both sides and then cut to its exact width, so its side faces
// lie exactly at x = 0 and x = width.
screw_driver_side_overlap = ff_eps;

function screw_driver_rounding() =
    min(
        screw_driver_max_rounding,
        screwdriver_padding_sides / 2.5,
        screwdriver_handle_padding / 2.5,
        screwdriver_back_width_min / 2.5,
        screwdriver_bottom_height / 3
    );

function screw_driver_width() = screwdriver_handle_width + 2 * screwdriver_padding_sides;

function screw_driver_depth() =
    screwdriver_back_width_max + 2 * screwdriver_handle_padding + screwdriver_handle_width;

// Top of the block that carries the pocket.
function screw_driver_block_height() = screwdriver_bottom_height + screwdriver_inset_height;

// Center of the pocket and the shaft hole in the (x, y) plane.
function screw_driver_hole_center() = [
    screw_driver_width() / 2,
    screwdriver_back_width_max + screwdriver_handle_padding + screwdriver_handle_width / 2
];

function screw_driver_params() = concat(
    [
        ["hw", screwdriver_handle_width],
        ["sw", screwdriver_stick_width],
        ["si", screwdriver_inset_height]
    ],
    // Not part of the Frenchfinity 1.0 file name: only listed when they differ from their default.
    ff_optional_params([["h", screwdriver_height, 50], ["bh", screwdriver_bottom_height, 10]])
);

// Footprint (x, y) of the block with a round hole of `hole_diameter` and the opening to the front, as a
// BOSL2 region. It reaches behind the mounting plane and beyond the sides, so the rounding only
// affects the front edges once the body is cut to its size.
function screw_driver_footprint(hole_diameter) =
    let(
        overlap = screw_driver_side_overlap,
        r       = screw_driver_rounding(),
        outline = move(
            [-overlap, -2 * r],
            square([screw_driver_width() + 2 * overlap, screw_driver_depth() + 2 * r])
        ),
        raw     = difference(outline, screw_driver_hole_path(hole_diameter / 2)),
        // Rounds the convex vertical edges.
        shrunk  = offset(screw_driver_clean_region(raw), delta = -r),
        rounded = offset(screw_driver_clean_region(shrunk), r = r)
    )
    screw_driver_clean_region(rounded);

// Outline of a round hole of `radius` together with the opening to the front. The opening widens
// from the shaft width at the hole center to shaft width + 2 x screwdriver_pull_out_tolerance at the
// front face (Frenchfinity 1.0) and continues beyond the front face to cut cleanly. The front half of
// the circle lies inside the opening, so the outline is the back part of the circle plus two lines.
function screw_driver_hole_path(radius) =
    let(
        depth  = screw_driver_depth(),
        center = screw_driver_hole_center(),
        stick  = screwdriver_stick_width / 2,
        // Widening of the opening per mm towards the front.
        slope  = screwdriver_pull_out_tolerance / (depth - center[1]),
        // Where the opening meets the circle, measured from the hole center to the front.
        meet_y = (-stick * slope + sqrt(pow(stick * slope, 2) - (1 + slope * slope) * (stick * stick - radius * radius)))
                 / (1 + slope * slope),
        angle  = atan2(meet_y, stick + slope * meet_y),
        front  = depth + 3 * screw_driver_rounding() - center[1]
    )
    concat(
        [center + [stick + slope * front, front]],
        arc(r = radius, cp = center, angle = [angle, -180 - angle]),
        [center + [-stick - slope * front, front]]
    );

// BOSL2 returns a single path instead of a region when there is only one outline. Very short
// segments make BOSL2's offset() fail, so they are removed.
function screw_driver_clean_region(region) =
    [for (path = is_path(region) ? [region] : region) deduplicate(path, closed = true, eps = 0.01)];

// Block with the pocket and the shaft hole, all top edges rounded.
module screw_driver_block() {
    r = screw_driver_rounding();

    // Floor below the pocket with the shaft hole.
    ff_offset_sweep(
        screw_driver_footprint(screwdriver_stick_width),
        height = screwdriver_bottom_height,
        top    = os_circle(r = r),
        steps  = 6
    );

    // Walls around the pocket. They start inside the floor, coincident bottom faces would leave
    // non-manifold edges.
    up(screwdriver_bottom_height / 2)
        ff_offset_sweep(
            screw_driver_footprint(screwdriver_handle_width),
            height = screw_driver_block_height() - screwdriver_bottom_height / 2,
            top    = os_circle(r = r),
            steps  = 6
        );
}

// Side profile (y, z) of the back plate, thinner towards the top, with a rounded top front edge.
// It includes a strip of the block below it, so the corner between back plate and block top gets a
// concave fillet. The strip ends just below the block top: coincident faces would leave non-manifold
// edges.
module screw_driver_back_profile_2d() {
    r      = screw_driver_rounding();
    strip  = screw_driver_block_height() - 0.01;

    // Fillet of the concave corner.
    offset(r = -r)
        offset(delta = r)
            // Rounded top front corner.
            offset(r = r)
                offset(delta = -r)
                    polygon([
                        [-2 * r, 0],
                        [screwdriver_back_width_max + 2 * r, 0],
                        [screwdriver_back_width_max + 2 * r, strip],
                        [screwdriver_back_width_max, strip],
                        [screwdriver_back_width_min, screwdriver_height],
                        [-2 * r, screwdriver_height]
                    ]);
}

module screw_driver_back_plate() {
    overlap = screw_driver_side_overlap;

    translate([-overlap, 0, 0])
        ff_profile_extrude(screw_driver_width() + 2 * overlap)
            screw_driver_back_profile_2d();
}

module screw_driver_body() {
    intersection() {
        union() {
            screw_driver_block();
            screw_driver_back_plate();
        }

        translate([0, 0, -1])
            cube([screw_driver_width(), screw_driver_depth() + 1, screwdriver_height + 2]);
    }
}

// Parameters on the back face below the tongue.
module screw_driver_label(params) {
    width       = screw_driver_width();
    area_top    = ff_slot_z(screwdriver_height) - ff_head_height() / 2 - 2;
    area_bottom = 2;

    ff_engrave_params(
        params,
        [width / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = width - 4,
        max_height = area_top - area_bottom
    );
}

module feature_screw_driver() {
    assert(
        screwdriver_stick_width <= screwdriver_handle_width,
        "screwdriver_stick_width must not be larger than screwdriver_handle_width."
    );
    assert(
        min(screwdriver_bottom_height, screwdriver_padding_sides, screwdriver_handle_padding,
            screwdriver_back_width_min, screwdriver_back_width_max) > 0,
        "The bottom height, the paddings and the back widths of the screwdriver holder must be larger than 0."
    );
    assert(
        screwdriver_back_width_min <= screwdriver_back_width_max,
        "screwdriver_back_width_min must not be larger than screwdriver_back_width_max."
    );
    assert(
        screwdriver_stick_width / 2 + screwdriver_pull_out_tolerance
            <= screwdriver_handle_width / 2 + screwdriver_padding_sides - 2 * screw_driver_rounding(),
        "The opening to the front (screwdriver_stick_width + 2 x screwdriver_pull_out_tolerance) is too wide for the holder, increase screwdriver_padding_sides."
    );
    assert(
        screwdriver_height >= max(ff_min_height(), screw_driver_block_height()),
        str(
            "screwdriver_height must be at least ",
            max(ff_min_height(), screw_driver_block_height()),
            " mm (screwdriver_bottom_height + screwdriver_inset_height)."
        )
    );

    params = screw_driver_params();

    ff_echo_file_name("screwdriver-holder", params);

    difference() {
        ff_holder(screw_driver_width(), screwdriver_height)
            screw_driver_body();

        screw_driver_label(params);
    }
}
