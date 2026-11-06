//
// Angle adapter
//
// Mounts holders at an angle to the wall. A back plate with the tongue carries an extension wall
// that stands out from the wall. The slot runs along the top edge of the left face of the
// extension wall, so holders slide in from its front end and hang turned by angle_adapter_angle
// degrees compared to a holder on the wall: 90 (Frenchfinity 1.0) turns them sideways, so they
// face to the left, parallel to the wall. The extension wall is ff_slot_depth() +
// angle_adapter_wall_thickness thick and angle_adapter_extension_width long (measured from the
// front face of the back plate), its outer face is flush with the right edge of the back plate.
//

function angle_adapter_params() = [
    ["a", angle_adapter_angle],
    ["w", angle_adapter_width],
    ["ew", angle_adapter_extension_width],
    ["h", angle_adapter_height],
    ["wt", angle_adapter_wall_thickness]
];

// Thickness of the extension wall: the slot plus a wall behind it.
function angle_adapter_extension_thickness() = ff_slot_depth() + angle_adapter_wall_thickness;

// The extension wall starts where its slot face meets the front face of the back plate.
function angle_adapter_root() =
    [angle_adapter_width - angle_adapter_extension_thickness(), angle_adapter_wall_thickness];

// Maps the frame of the extension wall to the part: x runs along the wall from the back plate to
// its front end, y = 0 is the slot face (the mounting plane of the holders, they extend to +y),
// the extension wall itself lies at -y like an anchor.
module angle_adapter_extension_frame() {
    translate(angle_adapter_root())
        rotate([0, 0, angle_adapter_angle])
            children();
}

function angle_adapter_rotate_2d(point, angle) =
    [point[0] * cos(angle) - point[1] * sin(angle), point[0] * sin(angle) + point[1] * cos(angle)];

// Top view of the part: back plate, extension wall and a gusset that connects the root of the
// extension wall to the back plate when the wall leans over the plate (angle > 90). Nothing may
// reach behind the mounting plane.
module angle_adapter_footprint_2d() {
    thickness = angle_adapter_extension_thickness();
    root      = angle_adapter_root();
    corner    = root + angle_adapter_rotate_2d([0, -thickness], angle_adapter_angle);
    size      = angle_adapter_width + angle_adapter_extension_width + thickness;

    intersection() {
        union() {
            square([angle_adapter_width, angle_adapter_wall_thickness]);

            angle_adapter_extension_frame()
                translate([0, -thickness])
                    square([angle_adapter_extension_width, thickness]);

            // A wall that leans outwards (angle <= 90) overlaps the back plate with its whole root.
            if (angle_adapter_angle > 90)
                polygon([root, corner, [corner[0], 0], [root[0], 0]]);
        }

        translate([-size, 0])
            square([3 * size, 2 * size]);
    }
}

// Distance along the extension wall at which the slot starts: at the back plate, or for a wall
// that leans outwards (angle < 90) where the whole slot lies in front of the back plate, so it
// does not cut into the back plate or its tongue.
function angle_adapter_slot_start() =
    angle_adapter_angle < 90 ? (ff_slot_depth() + 1) / tan(angle_adapter_angle) : 0;

// Slot along the extension wall, open at its front end.
module angle_adapter_slot() {
    start = angle_adapter_slot_start();

    angle_adapter_extension_frame()
        translate([start, 0, 0])
            ff_slot(angle_adapter_extension_width - start, angle_adapter_height);
}

// Parameters on the back face, below the tongue.
module angle_adapter_label(params) {
    area_top    = angle_adapter_height - ff_slot_bottom_offset() - 2;
    area_bottom = 2;

    ff_engrave_params(
        params,
        [angle_adapter_width / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = angle_adapter_width - 6,
        max_height = area_top - area_bottom
    );
}

module feature_angle_adapter() {
    assert(
        angle_adapter_angle > 0 && angle_adapter_angle < 180,
        "angle_adapter_angle must be between 0 and 180 degrees."
    );
    assert(
        angle_adapter_height >= ff_min_height(),
        str("angle_adapter_height must be at least ", ff_min_height(), " mm to carry the tongue and the slot.")
    );
    assert(angle_adapter_wall_thickness >= 1, "angle_adapter_wall_thickness must be at least 1 mm.");
    assert(
        angle_adapter_width >= angle_adapter_extension_thickness(),
        str(
            "angle_adapter_width must be at least ",
            angle_adapter_extension_thickness(),
            " mm (the thickness of the extension wall)."
        )
    );
    assert(
        angle_adapter_extension_width >= angle_adapter_slot_start() + 10,
        str("angle_adapter_extension_width must be at least ", angle_adapter_slot_start() + 10, " mm for this angle.")
    );

    params = angle_adapter_params();

    ff_echo_file_name("angle-adapter", params);

    difference() {
        ff_holder(angle_adapter_width, angle_adapter_height)
            linear_extrude(height = angle_adapter_height)
                angle_adapter_footprint_2d();

        angle_adapter_slot();

        angle_adapter_label(params);
    }
}
