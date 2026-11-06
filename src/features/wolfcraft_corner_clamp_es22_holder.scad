//
// Wolfcraft corner clamp ES 22 holder
//
// Holds a Wolfcraft ES 22 corner clamp tilted towards the front. A tray follows the outline of
// the clamp (`wolfcraft_corner_clamp_es22_holder_padding` mm clearance, walls of
// `wolfcraft_corner_clamp_es22_holder_wall_thickness` mm). A T-shaped cut-out in the floor and
// the body below it takes the parts of the clamp that stick out below its base, the front of
// the tray has no floor. Below the tray, the underside of the body rises from the bottom of the
// back face to the middle of the tray, which saves material.
//
// The tray is built in its own plane: x along the slot, u along the floor of the tray from the back
// (u = 0, the tray touches the top edge of the back face) to the front, v perpendicular to the floor.
//

wolfcraft_corner_clamp_es22_holder_angle = 30;
// Height of the back face, the top edge of the back face is the top edge of the tongue.
wolfcraft_corner_clamp_es22_holder_top = 50;
// The floor of the tray is this thick, the walls reach this high above the tilted plane through
// the top edge of the back face.
wolfcraft_corner_clamp_es22_holder_floor = 1;
wolfcraft_corner_clamp_es22_holder_wall_height = 11;
// Radius of the rounded top edges of the walls.
wolfcraft_corner_clamp_es22_holder_wall_rounding = 1;
wolfcraft_corner_clamp_es22_holder_tongue_width = 66.17;
// The floor ends this far from the back of the clamp outline (u), in front of it the tray is open.
wolfcraft_corner_clamp_es22_holder_floor_end = 66.72;
// The underside of the body rises from the bottom of the back face to the floor of the tray, which
// it meets this far from the back of the clamp outline (u).
wolfcraft_corner_clamp_es22_holder_body_end = 48.53;
// The body fills the gap between the back face and the clamp outline up to this distance (u).
wolfcraft_corner_clamp_es22_holder_back_fill = 10;

// Outline of the clamp and the T-shaped cut-out in the (x, u) plane without the padding, measured
// from the Frenchfinity 1.0 part (padding 2).
wolfcraft_corner_clamp_es22_holder_outline = [
    [0.10, 10.38], [0.22, 10.20], [0.33, 10.07], [10.09, 0.33], [10.22, 0.21], [10.42, 0.09],
    [10.65, 0.02], [10.88, 0.00], [11.23, 0.08], [11.48, 0.23], [17.48, 4.71], [17.92, 4.98],
    [18.45, 5.22], [19.01, 5.38], [19.52, 5.45], [22.98, 5.64], [23.77, 6.03], [24.15, 6.18],
    [24.60, 6.31], [25.06, 6.39], [25.47, 6.40], [41.80, 6.15], [58.38, 6.42], [58.77, 6.40],
    [59.22, 6.30], [59.59, 6.16], [60.61, 5.66], [64.07, 5.47], [64.58, 5.40], [65.14, 5.24],
    [65.68, 5.01], [66.11, 4.73], [72.12, 0.26], [72.27, 0.16], [72.48, 0.07], [72.72, 0.03],
    [72.95, 0.05], [73.28, 0.18], [73.51, 0.36], [83.37, 10.24], [83.53, 10.53], [83.59, 10.86],
    [83.53, 11.19], [83.37, 11.48], [78.87, 15.98], [78.57, 16.33], [78.28, 16.76], [78.05, 17.23],
    [77.88, 17.72], [77.78, 18.23], [77.75, 18.69], [77.71, 26.89], [77.61, 27.51], [77.52, 27.81],
    [77.42, 28.10], [77.13, 28.66], [76.76, 29.16], [76.52, 29.42], [60.61, 45.33], [60.31, 45.67],
    [60.02, 46.10], [59.79, 46.57], [59.62, 47.06], [59.52, 47.57], [59.49, 48.03], [59.39, 74.92],
    [59.28, 75.56], [59.07, 76.18], [58.93, 76.47], [58.57, 77.02], [58.13, 77.50], [57.62, 77.91],
    [57.05, 78.22], [56.44, 78.44], [55.80, 78.56], [41.76, 78.82], [27.72, 78.55], [27.08, 78.43],
    [26.47, 78.21], [26.18, 78.06], [25.63, 77.70], [25.16, 77.25], [24.76, 76.74], [24.45, 76.16],
    [24.24, 75.55], [24.14, 74.90], [24.06, 48.01], [24.03, 47.56], [23.93, 47.05], [23.76, 46.55],
    [23.53, 46.08], [23.24, 45.65], [22.94, 45.31], [7.04, 29.39], [6.81, 29.13], [6.44, 28.62],
    [6.15, 28.07], [6.05, 27.77], [5.96, 27.47], [5.86, 26.85], [5.83, 18.65], [5.80, 18.20],
    [5.70, 17.69], [5.53, 17.19], [5.30, 16.73], [5.01, 16.29], [4.71, 15.95], [0.22, 11.44],
    [0.10, 11.25], [0.02, 11.04], [0.01, 10.71]
];
wolfcraft_corner_clamp_es22_holder_cutout = [
    [41.80, 14.01], [53.43, 14.20], [53.42, 20.48], [46.92, 20.37], [46.90, 72.41], [36.63, 72.41],
    [36.65, 20.36], [30.16, 20.46], [30.16, 14.19]
];

function wolfcraft_corner_clamp_es22_holder_params() = [
    ["p", wolfcraft_corner_clamp_es22_holder_padding],
    ["wt", wolfcraft_corner_clamp_es22_holder_wall_thickness]
];

// Distance from the outline of the clamp to the outside of the walls.
function wolfcraft_corner_clamp_es22_holder_border() =
    wolfcraft_corner_clamp_es22_holder_padding + wolfcraft_corner_clamp_es22_holder_wall_thickness;

function wolfcraft_corner_clamp_es22_holder_size() =
    let(outline = wolfcraft_corner_clamp_es22_holder_outline, border = wolfcraft_corner_clamp_es22_holder_border())
    [max([for (p = outline) p[0]]) + 2 * border, max([for (p = outline) p[1]]) + 2 * border];

// Outline of the clamp grown by `distance` (a path), placed so the outside of the walls starts at
// x = 0 and u = 0.
function wolfcraft_corner_clamp_es22_holder_outline_path(distance) =
    let(border = wolfcraft_corner_clamp_es22_holder_border())
    [for (p = offset(wolfcraft_corner_clamp_es22_holder_outline, r = distance, closed = true)) p + [border, border]];

// Places the (x, u, v) plane of the tray.
module wolfcraft_corner_clamp_es22_holder_tilt() {
    a = wolfcraft_corner_clamp_es22_holder_angle;

    multmatrix([
        [1, 0, 0, 0],
        [0, cos(a), sin(a), 0],
        [0, -sin(a), cos(a), wolfcraft_corner_clamp_es22_holder_top],
        [0, 0, 0, 1]
    ])
        children();
}

// The T-shaped cut-out for the parts below the clamp.
module wolfcraft_corner_clamp_es22_holder_cutout_2d() {
    border = wolfcraft_corner_clamp_es22_holder_border();

    translate([border, border])
        offset(delta = wolfcraft_corner_clamp_es22_holder_padding)
            polygon(wolfcraft_corner_clamp_es22_holder_cutout);
}

// Region the body may fill: everything above the tilted plane of the tray, below it only what lies
// in front of the back face and above the underside, which rises from the bottom of the back face
// to the tray.
module wolfcraft_corner_clamp_es22_holder_keep() {
    a    = wolfcraft_corner_clamp_es22_holder_angle;
    top  = wolfcraft_corner_clamp_es22_holder_top;
    size = wolfcraft_corner_clamp_es22_holder_size();
    big  = 2 * (size[0] + size[1] + top);
    // where the underside meets the tray, in world coordinates
    end  = wolfcraft_corner_clamp_es22_holder_body_end + wolfcraft_corner_clamp_es22_holder_border();
    rise = atan2(top - end * sin(a), end * cos(a));

    wolfcraft_corner_clamp_es22_holder_tilt()
        translate([-1, -big / 2, 0])
            cube([size[0] + 2, big, big]);

    intersection() {
        rotate([rise, 0, 0])
            translate([-1, 0, 0])
                cube([size[0] + 2, big, big]);

        translate([-1, 0, 0])
            cube([size[0] + 2, big, big]);
    }
}

// Body and walls: the outside of the tray extruded down to the back face and the underside, the
// top edges of the walls are rounded. Below the tray, the gap between the back face and the clamp
// outline is filled.
module wolfcraft_corner_clamp_es22_holder_body() {
    top      = wolfcraft_corner_clamp_es22_holder_top;
    size     = wolfcraft_corner_clamp_es22_holder_size();
    height   = wolfcraft_corner_clamp_es22_holder_wall_height;
    below    = top * cos(wolfcraft_corner_clamp_es22_holder_angle) + 1;
    outer    = wolfcraft_corner_clamp_es22_holder_outline_path(wolfcraft_corner_clamp_es22_holder_border());
    rounding = min(wolfcraft_corner_clamp_es22_holder_wall_rounding, wolfcraft_corner_clamp_es22_holder_wall_thickness / 2 - 0.01);

    intersection() {
        wolfcraft_corner_clamp_es22_holder_tilt()
            translate([0, 0, -below])
                ff_offset_sweep(outer, height = below + height, top = os_circle(r = rounding), steps = 6);

        wolfcraft_corner_clamp_es22_holder_keep();
    }

    intersection() {
        wolfcraft_corner_clamp_es22_holder_tilt()
            translate([0, 0, -below])
                linear_extrude(height = below)
                    // overlaps the outline a little, so no faces coincide
                    offset(delta = 0.01)
                        difference() {
                            hull()
                                intersection() {
                                    polygon(outer);
                                    translate([-1, 0]) square([size[0] + 2, wolfcraft_corner_clamp_es22_holder_back_fill]);
                                }

                            polygon(outer);
                        }

        wolfcraft_corner_clamp_es22_holder_keep();
    }
}

// Inside of the tray down to the tilted plane, its top edge is rounded. The floor is added again
// afterwards, so the front of the tray stays open.
module wolfcraft_corner_clamp_es22_holder_pocket() {
    height   = wolfcraft_corner_clamp_es22_holder_wall_height;
    rounding = min(wolfcraft_corner_clamp_es22_holder_wall_rounding, wolfcraft_corner_clamp_es22_holder_wall_thickness / 2 - 0.01);

    // starts 0.01 mm below the tilted plane, so it does not share the bottom face of the walls
    wolfcraft_corner_clamp_es22_holder_tilt()
        translate([0, 0, -0.01])
            ff_offset_sweep(
                wolfcraft_corner_clamp_es22_holder_outline_path(wolfcraft_corner_clamp_es22_holder_padding),
                height = height + 0.01,
                top    = os_circle(r = -rounding, extra = 1),
                steps  = 6
            );
}

// Floor of the tray, it ends before the front of the tray. It reaches a little into the walls and
// the body below, so no faces coincide.
module wolfcraft_corner_clamp_es22_holder_floor() {
    size  = wolfcraft_corner_clamp_es22_holder_size();
    floor = wolfcraft_corner_clamp_es22_holder_floor;

    intersection() {
        wolfcraft_corner_clamp_es22_holder_tilt()
            translate([0, 0, -0.5])
                linear_extrude(height = floor + 0.5)
                    intersection() {
                        offset(delta = 0.01)
                            polygon(wolfcraft_corner_clamp_es22_holder_outline_path(wolfcraft_corner_clamp_es22_holder_padding));

                        translate([-1, -1])
                            square([size[0] + 2, wolfcraft_corner_clamp_es22_holder_border() + wolfcraft_corner_clamp_es22_holder_floor_end + 1]);
                    }

        // 0.01 mm higher than the body, so the underside of the floor lies inside the body
        translate([0, 0, 0.01])
            wolfcraft_corner_clamp_es22_holder_keep();
    }
}

// Parameters on the back face, between the cut-out and the tongue.
module wolfcraft_corner_clamp_es22_holder_label(params) {
    top         = wolfcraft_corner_clamp_es22_holder_top;
    a           = wolfcraft_corner_clamp_es22_holder_angle;
    // the cut-out reaches the back face up to this height
    cutout      = min([for (p = wolfcraft_corner_clamp_es22_holder_cutout) p[1]])
                      + wolfcraft_corner_clamp_es22_holder_border() - wolfcraft_corner_clamp_es22_holder_padding;
    area_top    = top - ff_slot_bottom_offset() - 2;
    area_bottom = top - cutout / sin(a) + 2;

    ff_engrave_params(
        params,
        [wolfcraft_corner_clamp_es22_holder_size()[0] / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = 56,
        max_height = area_top - area_bottom
    );
}

module feature_wolfcraft_corner_clamp_es22_holder() {
    assert(wolfcraft_corner_clamp_es22_holder_padding >= 0, "wolfcraft_corner_clamp_es22_holder_padding must not be negative.");
    assert(wolfcraft_corner_clamp_es22_holder_wall_thickness >= 1, "wolfcraft_corner_clamp_es22_holder_wall_thickness must be at least 1 mm.");

    params = wolfcraft_corner_clamp_es22_holder_params();
    size   = wolfcraft_corner_clamp_es22_holder_size();
    tongue = wolfcraft_corner_clamp_es22_holder_tongue_width;
    below  = wolfcraft_corner_clamp_es22_holder_top + 1;

    ff_echo_file_name("wolfcraft-corner-clamp-es22-holder", params);

    difference() {
        union() {
            difference() {
                wolfcraft_corner_clamp_es22_holder_body();
                wolfcraft_corner_clamp_es22_holder_pocket();
            }

            wolfcraft_corner_clamp_es22_holder_floor();

            translate([(size[0] - tongue) / 2, 0, 0])
                ff_tongue(tongue, wolfcraft_corner_clamp_es22_holder_top);
        }

        wolfcraft_corner_clamp_es22_holder_tilt()
            translate([0, 0, -below])
                linear_extrude(height = below + wolfcraft_corner_clamp_es22_holder_wall_height + 1)
                    wolfcraft_corner_clamp_es22_holder_cutout_2d();

        wolfcraft_corner_clamp_es22_holder_label(params);
    }
}
