//
// Ring wrench holder
//
// A round stick that reaches forward from the wall and rises by `ring_wrench_holder_angle`: ring
// wrenches (box-end wrenches), tape measures, coils of cable or anything else with a ring are hung
// onto it. The rising stick keeps them from sliding off.
//
// The stick is `ring_wrench_holder_stick_diameter` thick and `ring_wrench_holder_stick_length` long.
// A bolt (M6 by default) runs through the whole stick and the base and reinforces the printed
// stick: its hexagonal head sinks into the front end of the stick, the nut sits in a round recess
// behind the base and is tightened before the holder slides into the slot. Without
// `ring_wrench_holder_stick` only the base is printed, the head recess then sits in its front face.
// The parameters are engraved into the back face below the nut.
//

// The base is the stick diameter plus this on the left and right wide (1.0).
ring_wrench_holder_side_padding = 5;
// The base is the stick diameter plus this above and below the stick high (1.0).
ring_wrench_holder_vertical_padding = 15;
// Thickness of the base along the stick (1.0).
ring_wrench_holder_base_depth = 10;
// The round recess for the nut and the wrench behind the base is this much larger than the bolt head (1.0: 16 mm for M6).
ring_wrench_holder_nut_recess_extra = 6;

function ring_wrench_holder_params() = concat(
    [
        ["sd", ring_wrench_holder_stick_diameter],
        ["sl", ring_wrench_holder_stick_length],
        ["a", ring_wrench_holder_angle]
    ],
    ring_wrench_holder_stick ? [] : [["", "no-stick"]]
);

function ring_wrench_holder_width() = ring_wrench_holder_stick_diameter + 2 * ring_wrench_holder_side_padding;

// Height of the base, measured along its tilted front face.
function ring_wrench_holder_base_height() =
    ring_wrench_holder_stick_diameter + 2 * ring_wrench_holder_vertical_padding;

// Height of the back face, the top edge of the part.
function ring_wrench_holder_top() = ring_wrench_holder_base_height() * cos(ring_wrench_holder_angle);

function ring_wrench_holder_nut_recess_diameter() =
    ring_wrench_holder_screw_head_size + ring_wrench_holder_nut_recess_extra;

// Height of the center of the nut recess on the back face.
function ring_wrench_holder_nut_recess_z() =
    ring_wrench_holder_top() - ring_wrench_holder_base_height() / 2 / cos(ring_wrench_holder_angle);

// Places children in the frame of the stick: origin at the top edge of the back face, local y
// along the stick (forward and up), local z at a right angle to it (up), local x along x.
module ring_wrench_holder_stick_frame(top) {
    translate([0, 0, top])
        rotate([ring_wrench_holder_angle, 0, 0])
            children();
}

// Children placed on the stick axis (local z along the stick) at distance `from` from the back of the base.
module ring_wrench_holder_on_axis(width, from) {
    translate([width / 2, from, -ring_wrench_holder_base_height() / 2])
        rotate([-90, 0, 0])
            children();
}

// Side view (y, z) of the tilted base together with the wedge that fills the gap between its back
// and the mounting plane.
module ring_wrench_holder_side_profile_2d(top) {
    angle     = ring_wrench_holder_angle;
    along     = [cos(angle), sin(angle)];
    down      = [sin(angle), -cos(angle)];
    height    = ring_wrench_holder_base_height();
    front_top = [0, top] + ring_wrench_holder_base_depth * along;

    polygon(concat(
        [[0, 0], [0, top], front_top, front_top + height * down],
        // Without a tilt the back of the base lies in the mounting plane.
        angle > 0 ? [[0, top] + height * down] : []
    ));
}

module ring_wrench_holder_body(width, top) {
    radius = ring_wrench_holder_stick_diameter / 2;

    ff_profile_extrude(width)
        ring_wrench_holder_side_profile_2d(top);

    // The stick starts 1 mm inside the base, so the two do not share a face.
    if (ring_wrench_holder_stick)
        ring_wrench_holder_stick_frame(top)
            ring_wrench_holder_on_axis(width, ring_wrench_holder_base_depth - 1)
                cylinder(r = radius, h = ring_wrench_holder_stick_length + 1, $fn = ff_fn(radius));
}

// Bolt hole along the stick, hexagonal recess for the bolt head at the front, round recess for the nut at the back.
module ring_wrench_holder_bolt(width) {
    tolerance = ring_wrench_holder_screw_tolerance;
    front     = ring_wrench_holder_base_depth + (ring_wrench_holder_stick ? ring_wrench_holder_stick_length : 0);
    hole      = (ring_wrench_holder_screw_hole_diameter + tolerance) / 2;
    head      = ring_wrench_holder_screw_head_size + tolerance;
    recess    = ring_wrench_holder_nut_recess_diameter() / 2;
    behind    = ring_wrench_holder_base_height() * sin(ring_wrench_holder_angle) + 1;

    ring_wrench_holder_on_axis(width, -behind) {
        cylinder(r = hole, h = behind + front + 1, $fn = ff_fn(hole));

        cylinder(r = recess, h = behind + ff_eps, $fn = ff_fn(recess));

        translate([0, 0, behind + front - ring_wrench_holder_screw_depth])
            cylinder(d = head / cos(30), h = ring_wrench_holder_screw_depth + 1, $fn = 6);
    }
}

module feature_ring_wrench_holder() {
    assert(ring_wrench_holder_stick_diameter > 0, "ring_wrench_holder_stick_diameter must be larger than 0.");
    assert(
        ring_wrench_holder_angle >= 0 && ring_wrench_holder_angle <= 30,
        "ring_wrench_holder_angle must be between 0 and 30 degrees."
    );
    assert(
        ring_wrench_holder_screw_head_size > ring_wrench_holder_screw_hole_diameter,
        "ring_wrench_holder_screw_head_size must be larger than ring_wrench_holder_screw_hole_diameter."
    );
    assert(
        ring_wrench_holder_stick_diameter > ring_wrench_holder_screw_hole_diameter + ring_wrench_holder_screw_tolerance + 2,
        "The stick is too thin for the bolt: increase ring_wrench_holder_stick_diameter or reduce ring_wrench_holder_screw_hole_diameter."
    );
    assert(
        ring_wrench_holder_screw_depth < (ring_wrench_holder_stick ? ring_wrench_holder_stick_length : ring_wrench_holder_base_depth),
        "ring_wrench_holder_screw_depth is deeper than the stick (or the base)."
    );

    params      = ring_wrench_holder_params();
    width       = ring_wrench_holder_width();
    top         = ring_wrench_holder_top();
    area_top    = min(
        ring_wrench_holder_nut_recess_z()
            - ring_wrench_holder_nut_recess_diameter() / 2 / cos(ring_wrench_holder_angle) - 2,
        top - ff_slot_bottom_offset() - 2
    );
    area_bottom = 2;

    ff_echo_file_name("ring-wrench-holder", params);

    ff_holder(width, top)
        difference() {
            ring_wrench_holder_body(width, top);

            ring_wrench_holder_stick_frame(top)
                ring_wrench_holder_bolt(width);

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
