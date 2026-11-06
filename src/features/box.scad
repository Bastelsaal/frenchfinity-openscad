//
// Box (Frenchfinity 1.0 "rectangular box holder")
//
// An open box for one tool or a bundle of things (pens, files, a pipe cutter ...). The pocket is
// box_width x box_depth (the size of the tool plus some clearance) and box_height deep, the walls
// and the floor are box_wall_thickness thick. The top edges of the pocket and the front edge are
// rounded so the tool slides in easily. A box lower than the tongue gets a thicker floor, so it
// still stands flat on the print bed.
//

// Radius of the rounded top edges (Frenchfinity 1.0).
box_rounding = 2;

function box_params() = [
    ["w", box_width],
    ["d", box_depth],
    ["hh", box_height],
    ["wt", box_wall_thickness]
];

function box_outer_width() = box_width + 2 * box_wall_thickness;
function box_outer_depth() = box_depth + 2 * box_wall_thickness;

// Top edge of the box, the bottom is at z = 0.
function box_top() = max(box_height + box_wall_thickness, ff_tongue_bottom_offset());

// The front wall is rounded on both sides, so the radius is limited by the wall thickness (the two
// roundings must not touch).
function box_rounding_radius() = min(box_rounding, box_wall_thickness / 2.5, box_height);

// Cut body that rounds the top front edge of the box.
module box_front_edge_rounding(width, depth, top, r) {
    translate([-1, 0, 0])
        ff_extrude_along_x(width + 2)
            difference() {
                translate([depth - r, top - r])
                    square([r + 1, r + 1]);

                translate([depth - r, top - r])
                    circle(r = r, $fs = min($fs, r / 4));
            }
}

// Parameters on the bottom face, along the longer side of it.
module box_label(params, width, depth) {
    along_depth = depth > width;

    ff_engrave_params(
        params,
        [width / 2, depth / 2, 0],
        "bottom",
        max_width  = width - 4,
        max_height = depth - 4,
        rotation   = along_depth ? 90 : 0
    );
}

module feature_box() {
    assert(box_width > 0 && box_depth > 0 && box_height > 0, "box_width, box_depth and box_height must be greater than 0.");
    assert(box_wall_thickness >= 1, "box_wall_thickness must be at least 1 mm.");

    params = box_params();
    width  = box_outer_width();
    depth  = box_outer_depth();
    top    = box_top();
    r      = box_rounding_radius();

    ff_echo_file_name("rectangular-box-holder", params);

    difference() {
        ff_holder(width, top)
            cube([width, depth, top]);

        ff_rounded_pocket(
            box_wall_thickness,
            box_wall_thickness,
            box_width,
            box_depth,
            top - box_height,
            top,
            r
        );

        box_front_edge_rounding(width, depth, top, r);

        // The floor is at least box_wall_thickness thick, skip the text if that is too thin for it.
        if (top - box_height > 2 * text_depth)
            box_label(params, width, depth);
    }
}
