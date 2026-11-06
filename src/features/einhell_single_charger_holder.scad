//
// Einhell single charger holder
//
// A plate with three pins for an Einhell Power X-Change single charger (Power X-Charger), which
// has three keyholes in its bottom: two at the top, one in the middle below them. The charger is
// pushed onto the pins and slides down, so the pin heads hold it; lift it and pull it towards the
// front to remove it.
//
// Every pin has a neck (`*_mount_screw_stick_width` x `*_margin_to_chassis_outside`, the wall of the
// charger housing) and a head (`*_mount_screw_width` x `*_screw_thicker_width`) with rounded edges.
// The plate reaches `*_screw_padding_vertical` beyond the pins to the left and the right and
// `*_screw_padding_horizontal` above the upper and below the lower pin. The tongue sits just above
// the upper pins. The parameters are engraved into the back face below the tongue.
//
// The pin positions were traced from a photo of the charger in Frenchfinity 1.0, which left the
// pins and the plate of the 1.0 part rotated by 0.6 degrees. This version keeps the pin positions
// relative to each other but levels them.
//

// Horizontal distance between the upper pins (1.0).
einhell_single_charger_holder_pin_distance = 49.99;
// Position of the lower pin, measured from the upper left pin to the right and down (1.0).
einhell_single_charger_holder_lower_pin = [25.25, 93.71];
// Distance from the upper pins to the top edge of the tongue (1.0).
einhell_single_charger_holder_tongue_offset = 1.06;
einhell_single_charger_holder_plate_thickness = 10;
einhell_single_charger_holder_corner_radius = 10;
// Rounding of the edges of the pin heads.
einhell_single_charger_holder_pin_rounding = 1;

function einhell_single_charger_holder_params() = [
    ["sw", einhell_single_charger_holder_mount_screw_width],
    ["ssw", einhell_single_charger_holder_mount_screw_stick_width],
    ["mc", einhell_single_charger_holder_margin_to_chassis_outside],
    ["stw", einhell_single_charger_holder_screw_thicker_width],
    ["ph", einhell_single_charger_holder_screw_padding_horizontal],
    ["pv", einhell_single_charger_holder_screw_padding_vertical]
];

function einhell_single_charger_holder_width() =
    einhell_single_charger_holder_pin_distance + 2 * einhell_single_charger_holder_screw_padding_vertical;

function einhell_single_charger_holder_height() =
    einhell_single_charger_holder_lower_pin[1] + 2 * einhell_single_charger_holder_screw_padding_horizontal;

// Pin positions in the (x, z) plane.
function einhell_single_charger_holder_pins() =
    let(
        left  = einhell_single_charger_holder_screw_padding_vertical,
        upper = einhell_single_charger_holder_height() - einhell_single_charger_holder_screw_padding_horizontal
    )
    [
        [left, upper],
        [left + einhell_single_charger_holder_pin_distance, upper],
        [
            left + einhell_single_charger_holder_lower_pin[0],
            upper - einhell_single_charger_holder_lower_pin[1]
        ]
    ];

function einhell_single_charger_holder_top() =
    einhell_single_charger_holder_pins()[0][1] + einhell_single_charger_holder_tongue_offset;

// Pin along +y, starting at the front face of the plate (y = 0 here).
module einhell_single_charger_holder_pin() {
    neck   = einhell_single_charger_holder_margin_to_chassis_outside;
    head   = einhell_single_charger_holder_screw_thicker_width;
    radius = einhell_single_charger_holder_mount_screw_width / 2;
    r      = min(einhell_single_charger_holder_pin_rounding, head / 2 - 0.01, radius - 0.01);

    rotate([-90, 0, 0]) {
        translate([0, 0, -ff_eps])
            cylinder(d = einhell_single_charger_holder_mount_screw_stick_width, h = neck + 2 * ff_eps);

        // Head with rounded edges.
        translate([0, 0, neck])
            rotate_extrude($fn = 48)
                polygon(round_corners(
                    [[0, 0], [radius, 0], [radius, head], [0, head]],
                    radius = [0, r, r, 0],
                    $fn = 24
                ));
    }
}

module feature_einhell_single_charger_holder() {
    w      = einhell_single_charger_holder_width();
    h      = einhell_single_charger_holder_height();
    top    = einhell_single_charger_holder_top();
    plate  = einhell_single_charger_holder_plate_thickness;

    assert(
        einhell_single_charger_holder_mount_screw_width > einhell_single_charger_holder_mount_screw_stick_width,
        "einhell_single_charger_holder_mount_screw_width must be larger than the stick width, or the pins cannot hold the charger."
    );
    assert(
        top <= h,
        "einhell_single_charger_holder_screw_padding_horizontal is too small for the tongue above the upper pins."
    );

    params       = einhell_single_charger_holder_params();
    label_top    = top - ff_slot_bottom_offset() - 3;
    label_bottom = 5;

    ff_echo_file_name("einhell-single-charger-holder", params);

    difference() {
        union() {
            ff_profile_extrude(w)
                square([plate, h]);

            for (pin = einhell_single_charger_holder_pins())
                translate([pin[0], plate, pin[1]])
                    einhell_single_charger_holder_pin();

            ff_tongue(w, top);
        }

        // Rounded corners of the plate.
        translate([0, -ff_tongue_depth() - 1, 0])
            rotate([-90, 0, 0])
                linear_extrude(height = plate + ff_tongue_depth() + 2)
                    difference() {
                        translate([-1, -h - 1]) square([w + 2, h + 2]);
                        translate([0, -h])
                            offset(r = einhell_single_charger_holder_corner_radius, $fn = 48)
                                offset(delta = -einhell_single_charger_holder_corner_radius)
                                    square([w, h]);
                    }

        ff_engrave_params(
            params,
            [w / 2, 0, (label_top + label_bottom) / 2],
            "back",
            max_width  = w - 20,
            max_height = label_top - label_bottom
        );
    }
}
