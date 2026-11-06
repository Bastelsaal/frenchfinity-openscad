//
// Small hole holder
//
// Hangs a tool by a small hole in it (a hanging hole, the eye of a saw, the bore of a punch ...):
// a pin of small_hole_holder_hole_width (minus small_hole_holder_hole_tolerance) and
// small_hole_holder_hole_length sticks out of a plate that is small_hole_holder_tool_width + 5 mm
// wide. The pin points small_hole_holder_angle degrees upwards, so the tool does not slide off.
//

// Plate thickness, extra plate width (beyond the tool width) and minimum plate height (Frenchfinity 1.0).
small_hole_holder_plate_thickness = 5;
small_hole_holder_padding = 5;
small_hole_holder_min_height = 21;
// Radius of the rounded front edge of the pin.
small_hole_holder_pin_rounding = 1;

function small_hole_holder_params() = [
    ["hw", small_hole_holder_hole_width],
    ["tw", small_hole_holder_tool_width],
    ["hl", small_hole_holder_hole_length],
    ["ht", small_hole_holder_hole_tolerance],
    ["a", small_hole_holder_angle]
];

function small_hole_holder_pin_diameter() = small_hole_holder_hole_width - small_hole_holder_hole_tolerance;
function small_hole_holder_width() = small_hole_holder_tool_width + small_hole_holder_padding;
function small_hole_holder_height() =
    max(small_hole_holder_min_height, small_hole_holder_padding + small_hole_holder_pin_diameter());

// The pin, centered on the front face of the plate. Like in Frenchfinity 1.0 it is tilted around
// its lowest line on the front face, so its lower side starts exactly at the plate center minus
// half the pin diameter.
module small_hole_holder_pin(width, height) {
    d = small_hole_holder_pin_diameter();

    translate([width / 2, small_hole_holder_plate_thickness, height / 2 - d / 2])
        rotate([small_hole_holder_angle, 0, 0])
            translate([0, 0, d / 2])
                rotate([-90, 0, 0])
                    cyl(
                        d         = d,
                        l         = small_hole_holder_hole_length,
                        rounding2 = min(small_hole_holder_pin_rounding, d / 4, small_hole_holder_hole_length / 2),
                        anchor    = BOTTOM
                    );
}

// Parameters on the back face like Frenchfinity 1.0: the version and the first two parameters
// above the tongue, the others below it.
module small_hole_holder_label(params, width, height) {
    upper       = [str(ff_version_label(), " ", ff_param(params[0]), " ", ff_param(params[1]))];
    lower       = [ff_join([for (i = [2 : len(params) - 1]) ff_param(params[i])], " ")];
    upper_area  = [height - ff_tongue_top_offset() + 0.6, height - 0.6];
    lower_area  = [0.6, height - ff_slot_bottom_offset() - 0.6];

    for (block = [[upper, upper_area], [lower, lower_area]])
        ff_engrave(
            block[0],
            [width / 2, 0, (block[1][0] + block[1][1]) / 2],
            "back",
            ff_fit_text_size(block[0], width - 1, block[1][1] - block[1][0])
        );
}

module feature_small_hole_holder() {
    width  = small_hole_holder_width();
    height = small_hole_holder_height();
    params = small_hole_holder_params();

    assert(small_hole_holder_pin_diameter() > 0.5, "small_hole_holder_hole_tolerance is too large for small_hole_holder_hole_width.");

    ff_echo_file_name("small-hole-holder", params);

    difference() {
        union() {
            ff_holder(width, height)
                cube([width, small_hole_holder_plate_thickness, height]);

            small_hole_holder_pin(width, height);
        }

        small_hole_holder_label(params, width, height);
    }
}
