//
// Round hanging holder
//
// Hangs a tool with a round head and a shaft below it, like a ratchet, a torque wrench or a hand
// mixer: the head sits in a round cradle in front of a back plate, the shaft hangs down through a
// slot in the bottom of the cradle. A front lip with a smaller opening keeps the head from sliding
// forward, so the tool is lifted out upwards and pulled to the front.
//
// `round_hanging_holder_tool_diameter` is the diameter of the head, `round_hanging_holder_holder_depth`
// its thickness (the depth of the pocket). The opening of the front lip is
// `round_hanging_holder_inset_depth` smaller than the head, the slot is
// `round_hanging_holder_bottom_hole_width` wide. Back plate, cradle and lip are
// `round_hanging_holder_wall_thickness` thick. The parameters are engraved into the back face.
//

// The flat bottom of the cradle reaches this far beyond the slot on both sides (1.0).
round_hanging_holder_bottom_support = 14.5;
// Rounding where the slot meets the pocket and the lip opening.
round_hanging_holder_slot_rounding = 2;
// Rounding of the top inner edges of the cradle, of the slot edges and of the top front edge of the plate (1.0).
round_hanging_holder_edge_rounding = 1;

function round_hanging_holder_params() = [
    ["td", round_hanging_holder_tool_diameter],
    ["hd", round_hanging_holder_holder_depth],
    ["bhw", round_hanging_holder_bottom_hole_width],
    ["id", round_hanging_holder_inset_depth]
];

function round_hanging_holder_width() =
    round_hanging_holder_tool_diameter + 2 * round_hanging_holder_wall_thickness;

// The part is as high as it is wide, the cradle is its lower half.
function round_hanging_holder_height() = round_hanging_holder_width();

// Front view of the cradle: lower half of a ring around the head, with a flat bottom around the slot.
module round_hanging_holder_cradle_2d(width, center_z) {
    outer   = round_hanging_holder_tool_diameter / 2 + round_hanging_holder_wall_thickness;
    support = min(width / 2, round_hanging_holder_bottom_hole_width / 2 + round_hanging_holder_bottom_support);

    intersection() {
        union() {
            translate([width / 2, center_z])
                circle(r = outer);

            translate([width / 2 - support, 0])
                square([2 * support, center_z]);
        }

        square([width, center_z]);
    }
}

// Front view of an opening for the head (`radius`) with the slot below it. The edges where the
// slot meets the circle and the top inner edges of the cradle are rounded.
module round_hanging_holder_opening_2d(width, center_z, radius) {
    slot     = round_hanging_holder_bottom_hole_width;
    rounding = round_hanging_holder_edge_rounding;

    offset(r = -round_hanging_holder_slot_rounding)
        offset(delta = round_hanging_holder_slot_rounding)
            union() {
                translate([width / 2, center_z])
                    circle(r = radius);

                translate([(width - slot) / 2, -center_z])
                    square([slot, 2 * center_z]);
            }

    // Rounded top inner edges of the cradle. The pieces reach 0.5 mm into the opening: if they only
    // touched the circle, OpenSCAD 2021.01 would extrude the shape into a mesh that is not closed.
    overlap = 0.5;

    for (side = [-1, 1])
        translate([width / 2 + side * (radius + rounding), center_z - rounding])
            difference() {
                translate([side < 0 ? 0 : -rounding - overlap, 0])
                    square([rounding + overlap, rounding + ff_eps]);

                circle(r = rounding);
            }
}

// Top view of the slot through the front lip, its vertical edges on the front face rounded.
module round_hanging_holder_lip_slot_2d(width, from, to) {
    slot     = round_hanging_holder_bottom_hole_width;
    rounding = round_hanging_holder_edge_rounding;

    translate([(width - slot) / 2, from - ff_eps])
        square([slot, to - from + 1]);

    for (side = [-1, 1])
        translate([width / 2 + side * (slot / 2 + rounding), to - rounding])
            difference() {
                translate([side < 0 ? 0 : -rounding, 0])
                    square([rounding, rounding + 1]);

                circle(r = rounding);
            }
}

module round_hanging_holder_body(width, height) {
    wall     = round_hanging_holder_wall_thickness;
    center_z = height / 2;
    pocket   = [wall, wall + round_hanging_holder_holder_depth];
    lip      = [pocket[1], pocket[1] + wall];

    difference() {
        union() {
            // Back plate, top front edge rounded.
            ff_profile_extrude(width)
                polygon(round_corners(
                    [[0, 0], [0, height], [wall, height], [wall, 0]],
                    radius = [0, 0, round_hanging_holder_edge_rounding, 0],
                    $fn = 16
                ));

            ff_extrude_along_y(wall - ff_eps, lip[1])
                round_hanging_holder_cradle_2d(width, center_z);
        }

        ff_extrude_along_y(pocket[0], pocket[1] + ff_eps)
            round_hanging_holder_opening_2d(width, center_z, round_hanging_holder_tool_diameter / 2);

        ff_extrude_along_y(lip[0], lip[1] + 1)
            round_hanging_holder_opening_2d(
                width,
                center_z,
                (round_hanging_holder_tool_diameter - round_hanging_holder_inset_depth) / 2
            );

        translate([0, 0, -1])
            linear_extrude(height = center_z + 1)
                round_hanging_holder_lip_slot_2d(width, lip[0], lip[1]);
    }
}

module feature_round_hanging_holder() {
    assert(round_hanging_holder_tool_diameter > 0, "round_hanging_holder_tool_diameter must be larger than 0.");
    assert(
        round_hanging_holder_inset_depth >= 0 && round_hanging_holder_inset_depth < round_hanging_holder_tool_diameter,
        "round_hanging_holder_inset_depth must be smaller than round_hanging_holder_tool_diameter."
    );
    assert(
        round_hanging_holder_bottom_hole_width < round_hanging_holder_tool_diameter - round_hanging_holder_inset_depth,
        "round_hanging_holder_bottom_hole_width must be smaller than the opening of the lip (tool diameter - inset depth)."
    );
    assert(
        round_hanging_holder_height() >= ff_min_height(),
        str("The holder is too low for the tongue, it needs a tool diameter of at least ",
            ff_min_height() - 2 * round_hanging_holder_wall_thickness, " mm.")
    );

    params = round_hanging_holder_params();
    width  = round_hanging_holder_width();
    height = round_hanging_holder_height();

    area_top    = height - ff_slot_bottom_offset() - 2;
    area_bottom = 2;

    ff_echo_file_name("round-hanging-holder", params);

    ff_holder(width, height)
        difference() {
            round_hanging_holder_body(width, height);

            ff_engrave_params(
                params,
                [width / 2, 0, (area_top + area_bottom) / 2],
                "back",
                max_width  = width - 4,
                max_height = area_top - area_bottom
            );
        }
}
