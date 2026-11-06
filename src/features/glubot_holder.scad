//
// Glubot holder
//
// Holder for a Glubot glue bottle: the pear shaped foot of the bottle stands in a pocket of the
// same shape, `glubot_holder_height` deep, that leans forward by 15 degrees, so the bottle leans
// towards the room and is easy to grab. Below the pocket the holder is a solid block down to its
// flat bottom, with a compartment that is open to the front (it saves material and stores nozzles
// and caps). The back wall carries the tongue and is flat on top.
//
// `glubot_holder_padding` is the clearance between the foot of the bottle and the pocket walls,
// `glubot_holder_wall_thickness` the thickness of the pocket walls and of the pocket floor. The
// pocket outline was measured from Frenchfinity 1.0 (padding 5 mm); a larger pocket moves forward,
// so the back wall keeps its thickness. The parameters are engraved into the back face below the
// tongue.
//

// Tilt of the pocket (1.0).
glubot_holder_angle = 15;
// The pocket floor passes through this point of the (y, z) plane (1.0).
glubot_holder_floor_origin = [44.388, 82.8];
// The back wall is flat on top for this depth, then follows the rim (1.0).
glubot_holder_back_wall = 5.4;
// x range of the straight sides of the pocket's neck (1.0). The back block is this plus the wall
// thickness wide and reaches from the back face to where the neck widens.
glubot_holder_neck_range = [19.6, 66.05];
glubot_holder_neck_end = 32.3;
// Rounding of the inner edge of the rim (1.0).
glubot_holder_rim_rounding = 1;
// Top edge of the tongue (1.0).
glubot_holder_top = 91.32;
// Compartment: x range, height, its back end in its own frame, which is tilted by 3 degrees and
// starts at `glubot_holder_compartment_origin` in the (y, z) plane, and the rounding (1.0).
glubot_holder_compartment_range = [12.66, 72.16];
glubot_holder_compartment_height = 36.69;
glubot_holder_compartment_back = -25.48;
glubot_holder_compartment_origin = [84.388, 9.872];
glubot_holder_compartment_angle = 3;
glubot_holder_compartment_rounding = 9;
glubot_holder_compartment_end_rounding = 2;

// The pocket outline below includes this padding around the foot of the bottle (1.0).
glubot_holder_outline_padding = 5;

// Outline of the pocket in the plane of the pocket floor: x as in the part, y measured along the
// tilted floor from glubot_holder_floor_origin (1.0, padding 5 mm).
glubot_holder_pocket_outline = [
    [37.49, 73.56], [35.39, 73.23], [33.33, 72.8], [31.31, 72.25], [29.38, 71.61], [27.51, 70.88],
    [25.7, 70.05], [23.95, 69.14], [22.27, 68.14], [20.34, 66.85], [18.34, 65.33], [16.82, 64.03],
    [15.31, 62.6], [13.88, 61.12], [12.55, 59.59], [11.31, 58.01], [10.15, 56.4], [9.08, 54.75],
    [8.1, 53.08], [6.92, 50.79], [6.15, 49.07], [5.4, 47.16], [4.82, 45.42], [4.28, 43.52],
    [3.8, 41.34], [3.54, 39.8], [3.33, 38.25], [3.13, 35.89], [3, 31.26], [3.13, 25.9], [3.38, 22.19],
    [3.67, 20.31], [5.19, 15.24], [5.88, 13.32], [6.57, 11.67], [7.25, 10.24], [8.2, 8.46],
    [12.27, 1.55], [16.38, -5.62], [19.12, -10.08], [19.46, -10.85], [19.6, -11.57], [19.6, -12.25],
    [19.6, -20.19], [19.65, -22.6], [19.86, -24.24], [20.2, -25.9], [20.79, -27.84], [21.58, -29.74],
    [22.56, -31.56], [23.41, -32.85], [24.44, -34.16], [25.36, -35.16], [26.44, -36.19],
    [27.49, -37.04], [28.68, -37.88], [30.11, -38.72], [31.16, -39.22], [32.3, -39.68],
    [33.75, -40.14], [35.13, -40.46], [36.6, -40.71], [38.63, -40.93], [41.28, -41.09],
    [44.59, -41.08], [48.38, -40.78], [51.2, -40.3], [52.61, -39.92], [53.74, -39.52], [55.19, -38.89],
    [56.16, -38.38], [57.39, -37.61], [58.47, -36.82], [59.59, -35.85], [60.57, -34.9], [61.33, -34.05],
    [62.35, -32.74], [63.19, -31.44], [63.94, -30.08], [64.65, -28.49], [65.26, -26.74],
    [65.7, -24.93], [65.96, -23.28], [66.1, -21.64], [66.05, -19.27], [66.05, -12.34], [65.98, -11.45],
    [66.21, -10.6], [66.55, -9.84], [69.21, -5.46], [73.28, 1.73], [77.31, 8.67], [78.26, 10.45],
    [79.05, 12.18], [79.9, 14.36], [80.59, 16.47], [81.66, 20.12], [81.91, 21.28], [82.04, 22.25],
    [82.26, 25.88], [82.37, 30.85], [82.29, 34.96], [82.12, 37.3], [81.84, 39.66], [81.2, 43.02],
    [80.61, 45.2], [79.98, 47.11], [79.31, 48.84], [78.34, 51], [77.14, 53.28], [76.15, 54.95],
    [75.07, 56.59], [73.91, 58.2], [72.65, 59.76], [71.31, 61.29], [69.88, 62.77], [68.36, 64.18],
    [66.83, 65.48], [65.3, 66.64], [63.71, 67.74], [62.05, 68.77], [60.33, 69.71], [58.54, 70.57],
    [56.7, 71.34], [54.79, 72.02], [53.15, 72.51], [51.12, 73], [49.04, 73.39], [47.2, 73.64],
    [45.5, 73.8], [43.33, 73.9], [41.52, 73.88], [39.35, 73.76]
];

function glubot_holder_params() = [
    ["h", glubot_holder_height],
    ["p", glubot_holder_padding],
    ["wt", glubot_holder_wall_thickness]
];

// How much the pocket grows compared to the stored 1.0 outline.
function glubot_holder_growth() = glubot_holder_padding - glubot_holder_outline_padding;

// Pocket outline for the current padding. A grown pocket is moved forward by the growth, so its back
// end stays where it was.
function glubot_holder_pocket_path() =
    let(d = glubot_holder_growth())
    d == 0
        ? glubot_holder_pocket_outline
        : [for (p = offset(glubot_holder_pocket_outline, r = d, closed = true)) p + [0, max(0, d)]];

// Height of the rim plane at y.
function glubot_holder_rim_z(y) =
    glubot_holder_floor_origin[1]
        + (glubot_holder_floor_origin[0] - y) * tan(glubot_holder_angle)
        + glubot_holder_height / cos(glubot_holder_angle);

function glubot_holder_flat_top() = glubot_holder_rim_z(glubot_holder_back_wall);

// x range of the back block and of the tongue. 0.05 mm inside the neck walls, so the block does not
// share their side faces.
function glubot_holder_back_range() = [
    glubot_holder_neck_range[0] - glubot_holder_growth() - glubot_holder_wall_thickness + 0.05,
    glubot_holder_neck_range[1] + glubot_holder_growth() + glubot_holder_wall_thickness - 0.05
];

// Frame of the pocket: x stays x, y along the tilted floor, z perpendicular to the floor, the
// floor is z = 0.
module glubot_holder_pocket_frame() {
    translate([0, glubot_holder_floor_origin[0], glubot_holder_floor_origin[1]])
        rotate([-glubot_holder_angle, 0, 0])
            children();
}

module glubot_holder_outer_2d() {
    offset(r = glubot_holder_wall_thickness, $fn = 32)
        polygon(glubot_holder_pocket_path());
}

// Cup around the pocket: walls and floor.
module glubot_holder_cup() {
    wall = glubot_holder_wall_thickness;

    glubot_holder_pocket_frame()
        translate([0, 0, -wall])
            linear_extrude(height = wall + glubot_holder_height + 5)
                glubot_holder_outer_2d();
}

// Solid block below the cup: the outline of the cup bottom, extruded down to the bottom of the part.
// It reaches 0.5 mm into the cup, so both merge without touching faces.
module glubot_holder_base() {
    wall = glubot_holder_wall_thickness;
    a    = glubot_holder_angle;

    intersection() {
        translate([0, glubot_holder_floor_origin[0] - wall * sin(a), 0])
            linear_extrude(height = glubot_holder_floor_origin[1] + 50)
                scale([1, cos(a)])
                    glubot_holder_outer_2d();

        glubot_holder_pocket_frame()
            translate([-500, -500, 0.5 - wall - 1000])
                cube([1000, 1000, 1000]);
    }
}

// Compartment open to the front, its back end has rounded edges.
module glubot_holder_compartment() {
    left   = glubot_holder_compartment_range[0];
    right  = glubot_holder_compartment_range[1];
    height = glubot_holder_compartment_height;

    translate([0, glubot_holder_compartment_origin[0], glubot_holder_compartment_origin[1]])
        rotate([glubot_holder_compartment_angle, 0, 0])
            translate([0, glubot_holder_compartment_back, 0])
                // ff_offset_sweep extrudes along z, this maps it to +y (and the 2D y axis to -z).
                rotate([-90, 0, 0])
                    ff_offset_sweep(
                        round_corners(
                            [[left, -height], [right, -height], [right, 0], [left, 0]],
                            radius = glubot_holder_compartment_rounding,
                            $fn = 48
                        ),
                        height = 100,
                        bottom = os_circle(r = glubot_holder_compartment_end_rounding),
                        steps  = 4
                    );
}

module feature_glubot_holder() {
    h      = glubot_holder_height;
    top    = glubot_holder_top;
    flat   = glubot_holder_flat_top();
    back   = glubot_holder_back_range();

    assert(
        flat >= top + 2,
        "glubot_holder_height is too small: the back wall must reach above the tongue."
    );
    assert(
        glubot_holder_wall_thickness >= 1,
        "glubot_holder_wall_thickness must be at least 1 mm."
    );
    assert(
        glubot_holder_padding >= 0,
        "glubot_holder_padding must not be negative."
    );

    params       = glubot_holder_params();
    label_top    = top - ff_slot_bottom_offset() - 2;
    label_bottom = 3;

    ff_echo_file_name("glubot-holder", params);

    difference() {
        union() {
            intersection() {
                union() {
                    glubot_holder_base();
                    glubot_holder_cup();

                    translate([back[0], 0, 0])
                        cube([back[1] - back[0], glubot_holder_neck_end, flat + 5]);
                }

                // Below the rim plane and the flat top of the back wall, in front of the mounting plane.
                glubot_holder_pocket_frame()
                    translate([-500, -500, h - 1000])
                        cube([1000, 1000, 1000]);

                translate([-100, 0, 0])
                    cube([300, 300, flat]);
            }

            translate([back[0], 0, 0])
                ff_tongue(back[1] - back[0], top);
        }

        // Pocket, its rim is rounded. The rounding ends 0.05 mm above the rim, so the cut does not
        // share the top face of the rim.
        glubot_holder_pocket_frame()
            ff_offset_sweep(
                glubot_holder_pocket_path(),
                height = h + 0.05,
                top    = os_circle(r = -min(glubot_holder_rim_rounding, glubot_holder_wall_thickness / 2)),
                steps  = 6
            );

        glubot_holder_compartment();

        ff_engrave_params(
            params,
            [(back[0] + back[1]) / 2, 0, (label_top + label_bottom) / 2],
            "back",
            max_width  = back[1] - back[0] - 6,
            max_height = label_top - label_bottom
        );
    }
}
