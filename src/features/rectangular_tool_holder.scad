//
// Rectangular tool holder
//
// For tools with a flat, rectangular part and a handle or shaft below it, e.g. one handed bar
// clamps: the rectangular part rests in a pocket of tool_width x tool_length, tool_slot_height
// deep, the shaft hangs through a hole of holder_hole_width that is open to the front, so the tool
// is put in and taken out towards the front. The hole sits in the center or,
// like the "-hole-left" / "-hole-right" variants of Frenchfinity 1.0, at the left or right wall.
// The walls around the pocket are wall_thickness thick, the plate below the pocket is 15 mm thick.
//

// Thickness of the plate below the pocket (Frenchfinity 1.0).
rectangular_tool_holder_base_height = 15;
// Radius of the rounded top edges and of the edges at the mouth of the hole.
rectangular_tool_holder_rounding = 2;
// Radius of the edges where the pocket floor meets the hole.
rectangular_tool_holder_ledge_rounding = 1;
// Frenchfinity 1.0 moved the hole of the left and right variants this far towards that side and
// widened it up to the side wall.
rectangular_tool_holder_side_hole_shift = 5.5;

function rectangular_tool_holder_params() = [
    ["tw", rectangular_tool_holder_tool_width],
    ["tl", rectangular_tool_holder_tool_length],
    ["tsh", rectangular_tool_holder_tool_slot_height],
    ["hhw", rectangular_tool_holder_holder_hole_width],
    ["wt", rectangular_tool_holder_wall_thickness],
    ["hole-", rectangular_tool_holder_hole_position]
];

function rectangular_tool_holder_width() = rectangular_tool_holder_tool_width + 2 * rectangular_tool_holder_wall_thickness;
function rectangular_tool_holder_depth() = rectangular_tool_holder_tool_length + 2 * rectangular_tool_holder_wall_thickness;

// Top edge of the holder, the bottom is at z = 0. The holder is at least as high as the tongue.
function rectangular_tool_holder_top() =
    max(
        rectangular_tool_holder_tool_slot_height + rectangular_tool_holder_base_height,
        ff_tongue_bottom_offset()
    );

// [left, right] x position of the hole.
function rectangular_tool_holder_hole_range() =
    let(
        width    = rectangular_tool_holder_width(),
        wall     = rectangular_tool_holder_wall_thickness,
        shift    = rectangular_tool_holder_side_hole_shift,
        centered = [
            (width - rectangular_tool_holder_holder_hole_width) / 2,
            (width + rectangular_tool_holder_holder_hole_width) / 2
        ]
    )
    rectangular_tool_holder_hole_position == "left"  ? [wall, centered[1] - shift] :
    rectangular_tool_holder_hole_position == "right" ? [centered[0] + shift, width - wall] :
    centered;

// Cut body of the hole: open to the front, rounded at its mouth, at its top edges and where the
// pocket floor (the ledge the tool rests on) meets it.
module rectangular_tool_holder_hole(width, depth, top, r, r_ledge) {
    wall     = rectangular_tool_holder_wall_thickness;
    range    = rectangular_tool_holder_hole_range();
    floor_z  = top - rectangular_tool_holder_tool_slot_height;
    lip_y    = wall + rectangular_tool_holder_tool_length;
    pocket_x = [wall, wall + rectangular_tool_holder_tool_width];

    // The hole with rounded top edges, from the back wall to the front.
    ff_extrude_along_y(wall, depth + 1)
        ff_flared_profile_2d(range[0], range[1], -1, top, r);

    // Rounded edges of the ledges, only where there is a ledge between hole and pocket wall.
    ff_extrude_along_y(wall, lip_y)
        for (side = [[range[0], -1, range[0] - pocket_x[0]], [range[1], 1, pocket_x[1] - range[1]]])
            if (side[2] > 0.1)
                ff_fillet_2d([side[0], floor_z], [side[1], -1], min(r_ledge, side[2]));

    // Rounded vertical edges at the mouth of the hole (full height) and at the back of the lips
    // that close the pocket towards the front (pocket height only).
    for (side = [[range[0], -1, range[0] - pocket_x[0]], [range[1], 1, pocket_x[1] - range[1]]]) {
        translate([0, 0, -1])
            linear_extrude(height = top + 2)
                ff_fillet_2d([side[0], depth], [side[1], -1], r);

        if (side[2] > 0.1)
            translate([0, 0, floor_z])
                linear_extrude(height = top - floor_z + 1)
                    ff_fillet_2d([side[0], lip_y], [side[1], 1], r);
    }
}

// Cut body that rounds the top front edge.
module rectangular_tool_holder_front_edge(width, depth, top, r) {
    translate([-1, 0, 0])
        ff_extrude_along_x(width + 2)
            ff_fillet_2d([depth, top], [-1, -1], r);
}

module feature_rectangular_tool_holder() {
    wall   = rectangular_tool_holder_wall_thickness;
    width  = rectangular_tool_holder_width();
    depth  = rectangular_tool_holder_depth();
    top    = rectangular_tool_holder_top();
    range  = rectangular_tool_holder_hole_range();
    r      = min(rectangular_tool_holder_rounding, wall / 2.5, rectangular_tool_holder_tool_slot_height);
    params = rectangular_tool_holder_params();

    assert(
        range[1] - range[0] > 0.5,
        "The hole has no width left: increase rectangular_tool_holder_holder_hole_width (the left and right holes are narrower than a centered one, like in Frenchfinity 1.0)."
    );
    assert(
        range[0] >= wall - ff_eps && range[1] <= width - wall + ff_eps,
        "The hole is wider than the pocket: decrease rectangular_tool_holder_holder_hole_width or increase rectangular_tool_holder_tool_width."
    );

    ff_echo_file_name("rectangular-tool-holder", params);

    difference() {
        ff_holder(width, top)
            cube([width, depth, top]);

        ff_rounded_pocket(
            wall,
            wall,
            rectangular_tool_holder_tool_width,
            rectangular_tool_holder_tool_length,
            top - rectangular_tool_holder_tool_slot_height,
            top,
            r
        );

        rectangular_tool_holder_hole(width, depth, top, r, rectangular_tool_holder_ledge_rounding);

        rectangular_tool_holder_front_edge(width, depth, top, r);

        // Parameters on the outer right face, like Frenchfinity 1.0.
        ff_engrave_params(
            params,
            [width, depth / 2, top / 2],
            "right",
            max_width  = depth - 2 * r - 4,
            max_height = top - 2 * r - 2,
            per_line   = 3
        );
    }
}
