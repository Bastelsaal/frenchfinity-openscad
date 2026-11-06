//
// File holder
//
// Holds one file upright: its handle rests in a round pocket (file_holder_handle_width plus 2 mm wide,
// file_holder_handle_inset deep), the blade hangs down through a slot in the floor below the pocket.
// The slot is 2 x file_holder_file_width wide (Frenchfinity 1.0 measures file_width from the center
// line) and opens to the front, so the file can also be taken out to the front. The holder is
// file_holder_handle_width + 2 x file_holder_padding wide and deep, the floor is file_holder_height
// thick. The parameters are engraved into the bottom face.
//

// Radius of the rounded top and front edges (Frenchfinity 1.0).
file_holder_rounding = 2;

// The pocket is this much wider than the handle (Frenchfinity 1.0: handle_width + 2 mm).
file_holder_handle_clearance = 2;

// The body is built this much wider on both sides and then cut to its exact width, so its side faces
// lie exactly at x = 0 and x = width.
file_holder_side_overlap = ff_eps;

// Small offset that keeps faces of the cut bodies from coinciding with faces of the holder (coincident
// faces would leave non-manifold edges).
file_holder_step = 0.01;

// Width and depth of the holder.
function file_holder_size() = file_holder_handle_width + 2 * file_holder_padding;

function file_holder_total_height() = file_holder_height + file_holder_handle_inset;

function file_holder_pocket_radius() = (file_holder_handle_width + file_holder_handle_clearance) / 2;

function file_holder_center() = [file_holder_size() / 2, file_holder_size() / 2];

function file_holder_params() = concat(
    [
        ["hw", file_holder_handle_width],
        ["fw", file_holder_file_width],
        ["hi", file_holder_handle_inset]
    ],
    // Not part of the Frenchfinity 1.0 file name: only listed when they differ from their default.
    ff_optional_params([["h", file_holder_height, 10], ["p", file_holder_padding, 10]])
);

// Footprint (x, y) of the holder with the slot that runs from the back of the pocket circle to the front,
// front corners rounded, as a BOSL2 path. The back end of the slot follows the pocket circle (a hair
// smaller, so it never coincides with the wall of the pocket).
function file_holder_footprint() =
    let(
        overlap = file_holder_side_overlap,
        r       = file_holder_rounding,
        size    = file_holder_size(),
        center  = file_holder_center(),
        radius  = file_holder_pocket_radius() - file_holder_step,
        slot    = file_holder_file_width,
        angle   = acos(min(1, slot / radius)),
        back    = arc(r = radius, cp = center, angle = [-angle, -180 + angle]),
        path    = concat(
            [[-overlap, -2 * r], [size + overlap, -2 * r], [size + overlap, size], [center[0] + slot, size]],
            back,
            [[center[0] - slot, size], [-overlap, size]]
        )
    )
    round_corners(path, radius = concat([0, 0, r, r], repeat(0, len(back)), [r, r]), method = "circle");

// Pocket for the handle with a rounded top edge. The rounding ends just below the top face and a
// slightly wider cylinder cuts the rest, so no face of the cut touches the top face tangentially.
module file_holder_pocket_cut() {
    step   = file_holder_step;
    top    = file_holder_total_height();
    radius = file_holder_pocket_radius();
    r      = min(file_holder_rounding, (file_holder_handle_inset - step) / 2);

    translate([file_holder_center()[0], file_holder_center()[1], 0]) {
        up(file_holder_height)
            ff_offset_sweep(circle(r = radius), height = top - step - file_holder_height, top = os_circle(r = -r), steps = 8);

        up(top - step)
            cylinder(r = radius + r + step, h = 1 + step);
    }
}

module file_holder_body() {
    size = file_holder_size();
    top  = file_holder_total_height();

    intersection() {
        difference() {
            ff_offset_sweep(file_holder_footprint(), height = top, top = os_circle(r = file_holder_rounding), steps = 8);
            file_holder_pocket_cut();
        }

        translate([0, 0, -1])
            cube([size, size + 1, top + 2]);
    }
}

// Parameters on the bottom face, left of the slot, reading along the depth of the holder.
module file_holder_label(params) {
    size       = file_holder_size();
    area_width = size / 2 - file_holder_file_width;

    ff_engrave_params(
        params,
        [area_width / 2, size / 2, 0],
        "bottom",
        max_width  = area_width - 3,
        max_height = size - 2 * file_holder_rounding - 2,
        rotation   = 90
    );
}

module feature_file_holder() {
    assert(
        2 * file_holder_file_width <= file_holder_handle_width + file_holder_handle_clearance,
        str("The slot (2 x file_holder_file_width) must not be wider than the pocket (",
            file_holder_handle_width + file_holder_handle_clearance, " mm).")
    );
    assert(
        file_holder_size() / 2 - file_holder_file_width >= 2 * file_holder_rounding + 1,
        "The slot leaves no material at the front, decrease file_holder_file_width or increase file_holder_padding."
    );
    assert(
        file_holder_padding >= file_holder_handle_clearance / 2 + file_holder_rounding,
        str("file_holder_padding must be at least ", file_holder_handle_clearance / 2 + file_holder_rounding, " mm.")
    );
    assert(
        file_holder_total_height() >= ff_min_height(),
        str("file_holder_height + file_holder_handle_inset must be at least ", ff_min_height(), " mm.")
    );

    params = file_holder_params();

    ff_echo_file_name("file-holder", params);

    difference() {
        ff_holder(file_holder_size(), file_holder_total_height())
            file_holder_body();

        file_holder_label(params);
    }
}
