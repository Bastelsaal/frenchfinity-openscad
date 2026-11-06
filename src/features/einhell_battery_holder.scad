//
// Einhell battery holder
//
// Holds an Einhell Power X-Change battery like a tool does: a plate with the two rails of the
// Power X-Change battery mount on its underside. The battery is slid onto the rails from the front
// end of the plate up to the stop at the back, and hangs below the plate. The plate rises towards
// the front by `einhell_battery_holder_angle` + 2 degrees (the rail model of Frenchfinity 1.0 was
// already tilted by 2 degrees), so the battery slides against the stop by its own weight and cannot
// fall out. A triangular strut below the plate carries it and forms the stop.
//
// The parameters are engraved into the back face below the tongue.
//

einhell_battery_holder_width = 55;
// Height of the back face, the plate starts at its top edge (1.0).
einhell_battery_holder_height = 51.352;
// The rail model of 1.0 was tilted by this much on its own (plate angle = angle + this).
einhell_battery_holder_tilt_offset = 2;
// Length of the plate, measured along the plate (1.0).
einhell_battery_holder_length = 101.77;
// Thickness of the plate between the rails.
einhell_battery_holder_thickness = 9;
// Thickness of the plate at the rails.
einhell_battery_holder_rail_depth = 16.5;
// Width of the outer rail walls.
einhell_battery_holder_rail_wall = 3;
// Depth and height of the grooves the battery rails slide in.
einhell_battery_holder_groove = [3, 3.5];
// Distance from the back edge of the plate to the stop, measured along the plate (1.0).
einhell_battery_holder_stop = 23.77;
// Rounding of the front end of the plate and of the rail hooks (1.0).
einhell_battery_holder_rounding = 1;

function einhell_battery_holder_params() = [
    ["a", einhell_battery_holder_angle]
];

function einhell_battery_holder_tilt() = einhell_battery_holder_angle + einhell_battery_holder_tilt_offset;

// Point given in plate coordinates (u along the plate from its back top edge, v towards the
// underside) in the (y, z) plane.
function einhell_battery_holder_point(u, v) =
    let(t = einhell_battery_holder_tilt())
    [u * cos(t) + v * sin(t), einhell_battery_holder_height + u * sin(t) - v * cos(t)];

// Cross section of the plate with its rails: x across the plate, the second coordinate measured
// from the top face of the plate towards the underside.
function einhell_battery_holder_section() =
    let(
        w      = einhell_battery_holder_width,
        plate  = einhell_battery_holder_thickness,
        depth  = einhell_battery_holder_rail_depth,
        wall   = einhell_battery_holder_rail_wall,
        groove = einhell_battery_holder_groove,
        r      = einhell_battery_holder_rounding,
        path   = [
            [0, 0],
            [w, 0],
            [w, depth],
            [w - wall - groove[0], depth],
            [w - wall - groove[0], plate + groove[1]],
            [w - wall, plate + groove[1]],
            [w - wall, plate],
            [wall, plate],
            [wall, plate + groove[1]],
            [wall + groove[0], plate + groove[1]],
            [wall + groove[0], depth],
            [0, depth]
        ]
    )
    round_corners(path, radius = [0, 0, 0, 0, r, 0, 0, 0, 0, r, 0, 0], $fn = 16);

// Plate with the rails, its front end has rounded edges. It starts behind the mounting plane and
// is cut there by feature_einhell_battery_holder().
module einhell_battery_holder_plate() {
    t    = einhell_battery_holder_tilt();
    back = einhell_battery_holder_rail_depth * tan(t) + 1;

    // Local x stays x, local y points to the underside of the plate, local z along the plate.
    multmatrix([
        [1, 0, 0, 0],
        [0, sin(t), cos(t), 0],
        [0, -cos(t), sin(t), einhell_battery_holder_height],
        [0, 0, 0, 1]
    ])
        translate([0, 0, -back])
            ff_offset_sweep(
                einhell_battery_holder_section(),
                height = einhell_battery_holder_length + back,
                top    = os_circle(r = einhell_battery_holder_rounding),
                steps  = 4
            );
}

// Strut between the back face and the underside of the plate, its front face is the stop. Its top
// edge runs 1 mm inside the plate and its stop reaches a bit below the rails, so strut and plate
// share no faces.
module einhell_battery_holder_strut() {
    stop = einhell_battery_holder_stop;
    t    = einhell_battery_holder_tilt();

    ff_profile_extrude(einhell_battery_holder_width)
        polygon([
            [0, einhell_battery_holder_height - 1 / cos(t)],
            [0, 0],
            einhell_battery_holder_point(stop, einhell_battery_holder_rail_depth + 0.05),
            einhell_battery_holder_point(stop, 1)
        ]);
}

module feature_einhell_battery_holder() {
    w = einhell_battery_holder_width;
    h = einhell_battery_holder_height;

    assert(
        einhell_battery_holder_angle >= 0 && einhell_battery_holder_angle <= 60,
        "einhell_battery_holder_angle must be between 0 and 60 degrees: below 0 the battery slides off the front, above 60 the plate gets too steep."
    );

    params       = einhell_battery_holder_params();
    label_top    = h - ff_slot_bottom_offset() - 2;
    label_bottom = 3;

    ff_echo_file_name("einhell-battery-holder", params);

    difference() {
        union() {
            intersection() {
                union() {
                    einhell_battery_holder_plate();
                    einhell_battery_holder_strut();
                }

                translate([-1, 0, -1])
                    cube([w + 2, 2 * einhell_battery_holder_length, 2 * einhell_battery_holder_length + h]);
            }

            ff_tongue(w, h);
        }

        ff_engrave_params(
            params,
            [w / 2, 0, (label_top + label_bottom) / 2],
            "back",
            max_width  = w - 6,
            max_height = label_top - label_bottom
        );
    }
}
