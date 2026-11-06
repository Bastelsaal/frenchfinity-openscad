//
// Toilet paper holder
//
// A plate that carries a wooden dowel for toilet paper rolls (or tape, cable or any other roll):
// the end of the dowel sits in a shallow round recess on the front of the plate and is fixed with a
// screw from the back. The head of the screw sinks into a counterbore in the back face, so the
// plate still slides into the slot.
//
// `toilet_paper_holder_hole_diameter` is the diameter of the dowel, the recess is
// `toilet_paper_holder_hole_depth` deep and `toilet_paper_holder_hole_padding_top` below the top edge.
// The plate is the recess plus `toilet_paper_holder_hole_padding_side` on both sides wide,
// `toilet_paper_holder_height` high and `toilet_paper_holder_base_plate_width` thick. The parameters
// are engraved into the back face below the screw.
//

// Rounding of the plate corners and of the recess rim (1.0).
toilet_paper_holder_rounding = 1;

function toilet_paper_holder_params() = [
    ["h", toilet_paper_holder_height],
    ["hd", toilet_paper_holder_hole_diameter]
];

function toilet_paper_holder_width() =
    toilet_paper_holder_hole_diameter + 2 * toilet_paper_holder_hole_padding_side;

// Height of the center of the recess and the screw.
function toilet_paper_holder_hole_z() =
    toilet_paper_holder_height - toilet_paper_holder_hole_padding_top - toilet_paper_holder_hole_diameter / 2;

// Cut body of the recess along -y from y = 0 (the front face), its rim rounded. The rim ends
// 2 x ff_eps in front of the face, so the cut crosses the face instead of touching it.
module toilet_paper_holder_recess(diameter, depth) {
    radius   = diameter / 2;
    rounding = min(toilet_paper_holder_rounding, depth);
    steps    = 6;

    rotate([90, 0, 0])
        rotate_extrude($fn = ff_fn(radius + rounding))
            polygon(concat(
                [[0, -1], [radius + rounding, -1]],
                [
                    for (i = [0 : steps])
                        let(angle = 90 + 90 * i / steps)
                            [radius + rounding + rounding * cos(angle), rounding - rounding * sin(angle) - 2 * ff_eps]
                ],
                [[radius, depth], [0, depth]]
            ));
}

module feature_toilet_paper_holder() {
    width     = toilet_paper_holder_width();
    height    = toilet_paper_holder_height;
    thickness = toilet_paper_holder_base_plate_width;
    hole_z    = toilet_paper_holder_hole_z();
    head      = toilet_paper_holder_screw_head_hole_diameter;

    assert(
        toilet_paper_holder_hole_depth < thickness - 1,
        "toilet_paper_holder_hole_depth must be at least 1 mm smaller than toilet_paper_holder_base_plate_width."
    );
    assert(
        toilet_paper_holder_screw_head_hole_depth < thickness - toilet_paper_holder_hole_depth,
        "The counterbore of the screw head reaches into the recess, reduce toilet_paper_holder_screw_head_hole_depth."
    );
    assert(
        hole_z + head / 2 <= height - ff_slot_bottom_offset(),
        str(
            "The counterbore of the screw head cuts into the tongue. Increase toilet_paper_holder_hole_padding_top to at least ",
            toilet_paper_holder_hole_padding_top + hole_z + head / 2 - (height - ff_slot_bottom_offset()),
            " mm."
        )
    );
    assert(
        hole_z - max(toilet_paper_holder_hole_diameter, head) / 2 >= 1,
        "toilet_paper_holder_height is too small for the recess."
    );
    assert(head > toilet_paper_holder_screw_hole_diameter, "The screw head must be larger than the screw hole.");

    params      = toilet_paper_holder_params();
    area_top    = hole_z - head / 2 - 2;
    area_bottom = 2;

    ff_echo_file_name("toilet-paper-holder", params);

    ff_holder(width, height)
        difference() {
            // Plate with rounded corners (seen from the front).
            translate([0, thickness, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = thickness)
                        offset(r = toilet_paper_holder_rounding)
                            offset(delta = -toilet_paper_holder_rounding)
                                square([width, height]);

            translate([width / 2, thickness, hole_z])
                toilet_paper_holder_recess(toilet_paper_holder_hole_diameter, toilet_paper_holder_hole_depth);

            // Screw hole and the counterbore for its head in the back face.
            translate([width / 2, 0, hole_z])
                rotate([-90, 0, 0]) {
                    translate([0, 0, -1])
                        cylinder(
                            d = toilet_paper_holder_screw_hole_diameter,
                            h = thickness + 2,
                            $fn = ff_fn(toilet_paper_holder_screw_hole_diameter / 2)
                        );

                    translate([0, 0, -1])
                        cylinder(
                            d = head,
                            h = toilet_paper_holder_screw_head_hole_depth + 1,
                            $fn = ff_fn(head / 2)
                        );
                }

            if (area_top > area_bottom)
                ff_engrave_params(
                    params,
                    [width / 2, 0, (area_top + area_bottom) / 2],
                    "back",
                    max_width  = width - 4,
                    max_height = area_top - area_bottom
                );
        }
}
