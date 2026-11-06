//
// Caliper holder
//
// Holds a vernier or digital caliper by its jaws: the caliper hangs with its beam pointing down in
// front of a thin back plate, the short inside jaws rest in the left pocket and the long outside
// jaws in the right pocket. Both pockets are open towards the middle and at the top, so the caliper
// is lifted out towards the front and up.
//
// `caliper_holder_thickness` is the inner depth of the pockets (thickness of the jaws),
// `caliper_holder_head_width` the free space between the pockets (slider and head of the caliper).
// The pocket floors follow the edges of the jaws: `*_jaw_length` is the width of a pocket and
// `*_jaw_angle` the slope of its floor. The parameters are engraved into the back face of the
// middle part of the back plate, below the tongue. The defaults are the Frenchfinity 1.0 part.
//

// Total height of the holder (1.0).
caliper_holder_height = 72;
// Thickness of the back plate.
caliper_holder_plate_thickness = 2;
// Thickness of the front wall and of the outer side walls of the pockets.
caliper_holder_front_wall = 1.5;
caliper_holder_side_wall = 1.25;
// Thickness of the pocket floors, measured vertically (1.0).
caliper_holder_floor = 1.25;
// Distance from the top edge to the bottom of the pocket floors at the outer ends (1.0).
caliper_holder_inner_jaw_drop = 3;
caliper_holder_outer_jaw_drop = 13;
// The middle part of the back plate ends this far before the right pocket (1.0).
caliper_holder_plate_gap = 5;
// V shaped bottom of the middle part: chamfer width and height (1.0).
caliper_holder_bottom_chamfer = [11, 20];
// Chamfer between pocket floor and front wall: length on the floor, height on the wall (1.0).
caliper_holder_floor_chamfer = [6, 1];
// Roundings (1.0).
caliper_holder_bottom_rounding = 1.5;
caliper_holder_fillet = 1;
caliper_holder_corner_rounding = 1;
caliper_holder_top_rounding = 0.5;
caliper_holder_plate_rounding = 1;
// Rounding of the outer bottom corners of the left and the right pocket (1.0).
caliper_holder_outer_corner_rounding = [0.5, 1.2];
// The pocket bodies reach this much below the floor lines of the back plate (avoids coincident faces).
caliper_holder_overlap = 0.05;

function caliper_holder_params() = [
    ["t", caliper_holder_thickness],
    ["hw", caliper_holder_head_width],
    ["il", caliper_holder_inner_jaw_length],
    ["ia", caliper_holder_inner_jaw_angle],
    ["ol", caliper_holder_outer_jaw_length],
    ["oa", caliper_holder_outer_jaw_angle]
];

function caliper_holder_width() =
    caliper_holder_inner_jaw_length + caliper_holder_head_width + caliper_holder_outer_jaw_length;

// Right edge of the middle part of the back plate.
function caliper_holder_plate_right() =
    caliper_holder_inner_jaw_length + caliper_holder_head_width - caliper_holder_plate_gap;

// Bottom of the left pocket floor (and of the left wing of the back plate) at x.
function caliper_holder_inner_floor_z(x) =
    caliper_holder_height - caliper_holder_inner_jaw_drop - x * tan(caliper_holder_inner_jaw_angle);

// Bottom of the right pocket floor (and of the right wing of the back plate) at x.
function caliper_holder_outer_floor_z(x) =
    caliper_holder_height - caliper_holder_outer_jaw_drop
        - (caliper_holder_width() - x) * tan(caliper_holder_outer_jaw_angle);

// Outline of the back plate in the (x, z) plane. Its wings end inside the pockets, which reach
// `caliper_holder_overlap` lower, so plate and pockets merge without coincident faces.
function caliper_holder_plate_path() =
    let(
        h       = caliper_holder_height,
        w       = caliper_holder_width(),
        inset   = 1.5,
        left    = caliper_holder_inner_jaw_length,
        right   = caliper_holder_plate_right(),
        chamfer = min(caliper_holder_bottom_chamfer[0], (right - left - 4) / 2),
        rise    = caliper_holder_bottom_chamfer[1]
    )
    [
        [inset, h],
        [inset, caliper_holder_inner_floor_z(inset)],
        [left, caliper_holder_inner_floor_z(left)],
        [left, rise],
        [left + chamfer, 0],
        [right - chamfer, 0],
        [right, rise],
        [right, caliper_holder_outer_floor_z(right)],
        [w - inset, caliper_holder_outer_floor_z(w - inset)],
        [w - inset, h]
    ];

// Back plate, its front edges are rounded.
module caliper_holder_plate() {
    // ff_offset_sweep extrudes along z, swap y and z so it runs from the mounting plane to the front.
    multmatrix([[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        ff_offset_sweep(
            caliper_holder_plate_path(),
            height = caliper_holder_plate_thickness,
            top    = os_circle(r = caliper_holder_plate_rounding),
            steps  = 4
        );
}

// Cross section of the pocket body in the plane perpendicular to the floor: u is the world y
// axis, v is measured perpendicular to the floor, v = 0 is the bottom of the floor.
module caliper_holder_pocket_outer_2d(height) {
    depth = caliper_holder_plate_thickness + caliper_holder_thickness + caliper_holder_front_wall;

    polygon(round_corners(
        [[0, 0], [depth, 0], [depth, height], [0, height]],
        radius = [0, caliper_holder_bottom_rounding, 0, 0],
        // Not 24 or 20 like the other roundings at this corner, see caliper_holder_pocket().
        $fn = 22
    ));
}

// Cross section of the pocket cavity in the same plane. `floor_top` is the floor thickness
// perpendicular to the floor.
module caliper_holder_pocket_inner_2d(floor_top, height) {
    back    = caliper_holder_plate_thickness;
    front   = back + caliper_holder_thickness;
    length  = min(caliper_holder_floor_chamfer[0], caliper_holder_thickness * 0.7);
    rise    = caliper_holder_floor_chamfer[1];
    r       = caliper_holder_fillet;
    slope   = atan2(rise, length);
    // Fillet between chamfer and front wall: its center is r away from the wall and from the chamfer.
    cx      = front - r;
    cy      = floor_top + (length - r) * tan(slope) + r / cos(slope);
    // Tangent point on the chamfer.
    tx      = cx + r * sin(slope);
    ty      = cy - r * cos(slope);

    union() {
        polygon([
            [back, height],
            [back, floor_top],
            [front - length, floor_top],
            [tx, ty],
            [cx, ty],
            [cx, height]
        ]);
        translate([cx, cy]) circle(r = r, $fn = 24);
        translate([cx, cy]) square([r + ff_eps, height - cy]);
    }
}

// Rounds the top edges of the back plate and of the front wall inside the pockets.
module caliper_holder_top_rounding_2d() {
    r     = caliper_holder_top_rounding;
    back  = caliper_holder_plate_thickness;
    front = back + caliper_holder_thickness;
    h     = caliper_holder_height;

    for (corner = [[back, -1], [front, 1]])
        translate([corner[0], h])
            difference() {
                translate([corner[1] < 0 ? -r : 0, -r]) square([r + ff_eps, r + ff_eps]);
                translate([corner[1] < 0 ? -r : r, -r]) circle(r = r, $fn = 16);
            }
}

// One pocket with its outer side wall at x = 0, open towards +x. The floor descends towards +x by
// `angle`, its bottom is at z = `wall_z` at the outer wall. `corner` rounds the outer bottom corner.
module caliper_holder_pocket(length, angle, wall_z, corner) {
    h      = caliper_holder_height;
    depth  = caliper_holder_plate_thickness + caliper_holder_thickness + caliper_holder_front_wall;
    floor_top = caliper_holder_floor * cos(angle);
    reach  = length / cos(angle) + depth + 10;
    tall   = h + 20;
    side   = caliper_holder_side_wall;
    back   = caliper_holder_plate_thickness;
    front  = back + caliper_holder_thickness;
    rc     = caliper_holder_corner_rounding;

    // Front view of the pocket: everything between the floor line and the top edge.
    module caliper_holder_pocket_front_view() {
        translate([0, depth + 1, 0])
            rotate([90, 0, 0])
                linear_extrude(height = depth + 2)
                    polygon(round_corners(
                        [
                            [0, wall_z - caliper_holder_overlap],
                            [length, wall_z - caliper_holder_overlap - length * tan(angle)],
                            [length, h],
                            [0, h]
                        ],
                        radius = [corner, 0, 0, 0],
                        $fn = 24
                    ));
    }

    // Top view: the outer front corner at the side wall is rounded.
    module caliper_holder_pocket_top_view() {
        translate([0, 0, -1])
            linear_extrude(height = h + 2)
                polygon(round_corners(
                    [[0, 0], [length, 0], [length, depth], [0, depth]],
                    radius = [0, 0, 0, caliper_holder_bottom_rounding],
                    // Not 24: arcs with the same vertices as the front view leave non-manifold edges.
                    $fn = 20
                ));
    }

    // Top view of the cavity, its corners at the side wall are rounded.
    module caliper_holder_pocket_cavity_top_view() {
        translate([0, 0, -1])
            linear_extrude(height = h + 2)
                polygon(round_corners(
                    [[side, back], [length + 1, back], [length + 1, front], [side, front]],
                    radius = [rc, 0, 0, rc],
                    $fn = 16
                ));
    }

    module caliper_holder_pocket_floor_frame() {
        translate([0, 0, wall_z])
            rotate([0, angle, 0])
                translate([-depth - 5, 0, 0])
                    ff_extrude_along_x(reach + depth + 5)
                        children();
    }

    difference() {
        intersection() {
            translate([0, 0, -caliper_holder_overlap])
                caliper_holder_pocket_floor_frame()
                    caliper_holder_pocket_outer_2d(tall);
            caliper_holder_pocket_front_view();
            caliper_holder_pocket_top_view();
        }

        intersection() {
            caliper_holder_pocket_floor_frame()
                caliper_holder_pocket_inner_2d(floor_top, tall);
            caliper_holder_pocket_cavity_top_view();
        }

        translate([-1, 0, 0])
            ff_extrude_along_x(length + 2)
                caliper_holder_top_rounding_2d();
    }
}

// Parameters on the back face of the middle part, between its V shaped bottom and the tongue.
module caliper_holder_label(params) {
    left   = caliper_holder_inner_jaw_length + 2;
    right  = caliper_holder_plate_right() - 2;
    top    = caliper_holder_height - ff_slot_bottom_offset() - 2;
    bottom = caliper_holder_bottom_chamfer[1] + 2;

    ff_engrave_params(
        params,
        [(left + right) / 2, 0, (top + bottom) / 2],
        "back",
        max_width  = right - left,
        max_height = top - bottom
    );
}

module feature_caliper_holder() {
    w     = caliper_holder_width();
    h     = caliper_holder_height;
    left  = caliper_holder_inner_jaw_length;
    right = caliper_holder_plate_right();

    assert(
        caliper_holder_inner_floor_z(left) >= caliper_holder_bottom_chamfer[1] + 1,
        "The inner jaw pocket reaches too low: decrease caliper_holder_inner_jaw_length or caliper_holder_inner_jaw_angle."
    );
    assert(
        caliper_holder_outer_floor_z(right) >= caliper_holder_bottom_chamfer[1] + 1,
        "The outer jaw pocket reaches too low: decrease caliper_holder_outer_jaw_length or caliper_holder_outer_jaw_angle."
    );
    assert(
        right - left >= 10,
        "caliper_holder_head_width is too small for the middle part of the back plate."
    );
    assert(
        caliper_holder_inner_jaw_length > caliper_holder_side_wall + 2
            && caliper_holder_outer_jaw_length > caliper_holder_side_wall + 2,
        "The jaw pockets are too short."
    );

    params = caliper_holder_params();

    ff_echo_file_name("caliper-holder", params);

    difference() {
        union() {
            caliper_holder_plate();

            caliper_holder_pocket(
                caliper_holder_inner_jaw_length,
                caliper_holder_inner_jaw_angle,
                caliper_holder_inner_floor_z(0),
                caliper_holder_outer_corner_rounding[0]
            );

            translate([w, 0, 0])
                mirror([1, 0, 0])
                    caliper_holder_pocket(
                        caliper_holder_outer_jaw_length,
                        caliper_holder_outer_jaw_angle,
                        caliper_holder_outer_floor_z(w),
                        caliper_holder_outer_corner_rounding[1]
                    );

            translate([left, 0, 0])
                ff_tongue(w - left, h);
        }

        caliper_holder_label(params);
    }
}
