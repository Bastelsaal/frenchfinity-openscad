//
// T-handle holder
//
// Holds one T-handle tool (e.g. a T-handle Torx or hex key) lying in a trough on top of a block: the
// handle rests in the trough (t_handle_holder_end_back_diameter at its back end,
// t_handle_holder_handle_width around the stick, t_handle_holder_end_front_diameter at its front end),
// the stick hangs down through a hole and a slot (t_handle_holder_stick_diameter wide) that opens to the
// front. The stick sits t_handle_holder_stick_center_to_back_end_distance in front of the back end of
// the handle and t_handle_holder_stick_center_to_front_end_distance behind its front end. Like in
// Frenchfinity 1.0 the whole holder except the tongue is designed for one size of tool and scaled by
// t_handle_holder_scale; the parameters describe the tool at scale 1. The parameters are engraved into
// the right side face.
//
// Only the 1.0 parameter values (at three scales) could be compared with Frenchfinity 1.0, the roles of
// the parameters in the trough and the hole follow the 1.0 design as far as it could be measured.
//

// Values of the 1.0 design at scale 1.
t_handle_holder_back_wall      = 10;    // material behind the trough
t_handle_holder_side_padding   = 5.5;   // material beside the widest part of the trough
t_handle_holder_floor_height   = 18;    // material below the trough
t_handle_holder_hole_clearance = 1.65;  // the hole is this much wider than the bottom of the handle (per side)
t_handle_holder_hole_length    = 1.6;   // added to bottom_hole_to_front_bottom_distance for the hole length (per side)
t_handle_holder_funnel_height  = 8;     // the hole widens into the trough over this height
t_handle_holder_funnel_widen   = [2, 7];     // ... by this much in x and y (per side)
t_handle_holder_entry_radius   = 3;     // rounded entry of the stick slot at the front

// Where the trough changes its shape, as fractions of the distances from the stick to the ends of the
// handle (measured on the 1.0 design).
t_handle_holder_back_round_end   = 0.54;
t_handle_holder_back_wide_start  = 0.05;
t_handle_holder_front_wide_end   = 0.05;
t_handle_holder_front_round_start = 0.70;

function t_handle_holder_params() = [
    ["s", t_handle_holder_scale],
    ["hw", t_handle_holder_handle_width],
    ["sd", t_handle_holder_stick_diameter],
    ["hbd", t_handle_holder_hole_bottom_diameter],
    ["efd", t_handle_holder_end_front_diameter],
    ["ebd", t_handle_holder_end_back_diameter],
    ["sctbed", t_handle_holder_stick_center_to_back_end_distance],
    ["sctfed", t_handle_holder_stick_center_to_front_end_distance],
    ["bhtfbd", t_handle_holder_bottom_hole_to_front_bottom_distance]
];

// Size of the block at scale 1.
function t_handle_holder_width() = t_handle_holder_handle_width + 2 * t_handle_holder_side_padding;

function t_handle_holder_depth() =
    t_handle_holder_back_wall
    + t_handle_holder_stick_center_to_back_end_distance
    + t_handle_holder_stick_center_to_front_end_distance;

function t_handle_holder_height() = t_handle_holder_floor_height + t_handle_holder_end_back_diameter / 2;

function t_handle_holder_stick_y() = t_handle_holder_back_wall + t_handle_holder_stick_center_to_back_end_distance;

// Thin slice of a (x, z) cross section at depth y, used to hull the trough together.
module t_handle_holder_slice(y) {
    translate([0, y, 0])
        rotate([90, 0, 0])
            linear_extrude(height = 0.01, center = true)
                children();
}

// Cross sections of the trough: round at the ends of the handle, a channel as wide as the handle
// around the stick. All sections share the bottom line of the handle.
module t_handle_holder_round_2d(diameter) {
    floor = t_handle_holder_height() - t_handle_holder_end_back_diameter / 2;

    translate([t_handle_holder_width() / 2, floor + diameter / 2])
        circle(d = diameter);
}

module t_handle_holder_channel_2d() {
    floor = t_handle_holder_height() - t_handle_holder_end_back_diameter / 2;

    translate([(t_handle_holder_width() - t_handle_holder_handle_width) / 2, floor])
        square([t_handle_holder_handle_width, t_handle_holder_end_back_diameter]);
}

module t_handle_holder_trough_cut() {
    stick = t_handle_holder_stick_y();
    back  = t_handle_holder_stick_center_to_back_end_distance;
    front = t_handle_holder_stick_center_to_front_end_distance;
    ys    = [
        t_handle_holder_back_wall,
        stick - t_handle_holder_back_round_end * back,
        stick - t_handle_holder_back_wide_start * back,
        stick + t_handle_holder_front_wide_end * front,
        stick + t_handle_holder_front_round_start * front,
        t_handle_holder_depth() + 1
    ];

    for (i = [0 : len(ys) - 2])
        hull() {
            for (j = [i, i + 1])
                t_handle_holder_slice(ys[j]) {
                    if (j < 2)
                        t_handle_holder_round_2d(t_handle_holder_end_back_diameter);
                    else if (j < 4)
                        t_handle_holder_channel_2d();
                    else
                        t_handle_holder_round_2d(t_handle_holder_end_front_diameter);
                }
        }
}

// Oval hole for the bottom of the handle through the floor, widening into the trough.
module t_handle_holder_hole_cut() {
    radii  = [
        t_handle_holder_hole_bottom_diameter / 2 + t_handle_holder_hole_clearance,
        t_handle_holder_bottom_hole_to_front_bottom_distance + t_handle_holder_hole_length
    ];
    floor  = t_handle_holder_height() - t_handle_holder_end_back_diameter / 2;
    start  = floor - t_handle_holder_funnel_height;
    widen  = t_handle_holder_funnel_widen;

    translate([t_handle_holder_width() / 2, t_handle_holder_stick_y(), 0])
        hull() {
            translate([0, 0, -1])
                scale([radii[0], radii[1], 1])
                    cylinder(r = 1, h = start + 1, $fn = 72);

            translate([0, 0, floor])
                scale([radii[0] + widen[0], radii[1] + widen[1], 1])
                    cylinder(r = 1, h = 0.01, $fn = 72);
        }
}

// Slot for the stick from the hole to the front, with a rounded entry.
module t_handle_holder_slot_cut() {
    x     = t_handle_holder_width() / 2;
    half  = t_handle_holder_stick_diameter / 2;
    depth = t_handle_holder_depth();
    r     = t_handle_holder_entry_radius;

    translate([0, 0, -1])
        linear_extrude(height = t_handle_holder_height() + 2)
            union() {
                translate([x - half, t_handle_holder_stick_y()])
                    square([2 * half, depth - t_handle_holder_stick_y() + 1]);

                difference() {
                    translate([x - half - r, depth - r])
                        square([2 * (half + r), r + 1]);

                    for (side = [-1, 1])
                        translate([x + side * (half + r), depth - r])
                            circle(r = r);
                }
            }
}

module t_handle_holder_body() {
    difference() {
        cube([t_handle_holder_width(), t_handle_holder_depth(), t_handle_holder_height()]);

        t_handle_holder_trough_cut();
        t_handle_holder_hole_cut();
        t_handle_holder_slot_cut();
    }
}

// Parameters on the right side face.
module t_handle_holder_label(params) {
    s = t_handle_holder_scale;

    ff_engrave_params(
        params,
        [t_handle_holder_width() * s, t_handle_holder_depth() * s / 2, t_handle_holder_height() * s / 2],
        "right",
        max_width  = (t_handle_holder_depth() - 8) * s,
        max_height = (t_handle_holder_height() - 4) * s
    );
}

module feature_t_handle_holder() {
    s = t_handle_holder_scale;

    assert(
        t_handle_holder_height() * s >= ff_slot_bottom_offset() + 1,
        str("The holder is too low for the tongue, increase t_handle_holder_scale to at least ",
            (ff_slot_bottom_offset() + 1) / t_handle_holder_height(), ".")
    );
    assert(
        t_handle_holder_stick_diameter < t_handle_holder_hole_bottom_diameter + 2 * t_handle_holder_hole_clearance,
        "t_handle_holder_stick_diameter must be smaller than the hole for the bottom of the handle."
    );
    assert(
        max(t_handle_holder_end_back_diameter, t_handle_holder_end_front_diameter) <= t_handle_holder_width() - 2,
        "The ends of the handle are wider than the holder, increase t_handle_holder_handle_width."
    );
    assert(
        t_handle_holder_bottom_hole_to_front_bottom_distance + t_handle_holder_hole_length
            < min(t_handle_holder_stick_center_to_back_end_distance, t_handle_holder_stick_center_to_front_end_distance),
        "The hole is longer than the handle, decrease t_handle_holder_bottom_hole_to_front_bottom_distance."
    );

    params = t_handle_holder_params();

    ff_echo_file_name("t-handle-holder", params);

    difference() {
        ff_holder(t_handle_holder_width() * s, t_handle_holder_height() * s)
            scale(s)
                t_handle_holder_body();

        t_handle_holder_label(params);
    }
}
