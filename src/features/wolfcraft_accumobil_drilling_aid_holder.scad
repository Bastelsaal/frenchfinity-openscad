//
// Wolfcraft Accumobil drilling aid holder
//
// Holds the Wolfcraft Accumobil drilling aid tilted towards the front, so its drill guides can be
// seen and the drilling aid can be lifted out. A tray follows the outline of the drilling aid
// (`wolfcraft_accumobil_drilling_aid_holder_padding` mm clearance, walls of
// `wolfcraft_accumobil_drilling_aid_holder_wall_thickness` mm) and lies on a solid wedge, tilted
// by `wolfcraft_accumobil_drilling_aid_holder_angle` degrees. `..._height` is the height of the
// drilling aid: the walls of the tray are 5 mm lower so it can be grabbed (as in 1.0).
//
// The tray is built in its own plane: x along the slot, u along the floor of the tray from the back
// (u = 0, the tray touches the top edge of the back face) to the front, v perpendicular to the floor.
//

wolfcraft_accumobil_drilling_aid_holder_angle = 30;
// The floor of the tray lies this far above the tilted plane through the top edge of the back face.
wolfcraft_accumobil_drilling_aid_holder_floor = 3;
// The walls are lower than the drilling aid by this amount.
wolfcraft_accumobil_drilling_aid_holder_grip = 5;
wolfcraft_accumobil_drilling_aid_holder_tongue_width = 30.38;
// Radius of the rounded outer top edge of the walls.
wolfcraft_accumobil_drilling_aid_holder_wall_rounding = 1;

// Outline of the drilling aid in the (x, u) plane, measured from the Frenchfinity 1.0 part.
wolfcraft_accumobil_drilling_aid_holder_outline = [
    [5.34, 54.52], [5.52, 52.64], [5.72, 50.80], [6.06, 48.19], [6.43, 45.80], [6.79, 43.81],
    [7.23, 41.69], [7.74, 39.44], [7.79, 39.00], [7.76, 38.62], [7.65, 38.26], [7.47, 37.93],
    [7.24, 37.63], [7.07, 37.47], [6.92, 37.35], [6.59, 37.17], [5.93, 36.93], [5.41, 36.71],
    [4.86, 36.44], [4.30, 36.12], [3.44, 35.56], [3.03, 35.25], [2.27, 34.59], [1.93, 34.24],
    [1.49, 33.70], [1.18, 33.24], [1.02, 32.95], [0.79, 32.35], [0.64, 31.73], [0.61, 31.41],
    [0.60, 30.87], [0.64, 30.42], [0.76, 29.70], [1.02, 28.70], [2.12, 25.35], [2.74, 23.54],
    [3.21, 22.27], [3.68, 21.12], [4.23, 19.93], [4.87, 18.70], [5.35, 17.87], [5.89, 17.03],
    [6.49, 16.18], [7.33, 15.10], [7.89, 14.44], [9.10, 13.13], [10.44, 11.83], [11.15, 11.19],
    [12.77, 9.85], [13.67, 9.16], [15.02, 8.19], [16.77, 7.05], [18.00, 6.32], [19.16, 5.70],
    [20.24, 5.19], [21.62, 4.66], [21.84, 4.54], [22.19, 4.24], [22.44, 3.93], [22.55, 3.73],
    [22.80, 3.08], [23.08, 2.58], [23.30, 2.33], [23.63, 2.09], [24.12, 1.91], [29.19, 0.69],
    [30.74, 0.36], [31.88, 0.17], [32.50, 0.10], [33.12, 0.05], [34.36, 0.00], [35.63, 0.02],
    [36.92, 0.10], [38.88, 0.31], [40.17, 0.50], [41.41, 0.74], [42.77, 1.07], [43.65, 1.36],
    [44.41, 1.68], [45.01, 2.02], [45.33, 2.26], [45.58, 2.52], [45.88, 2.95], [46.25, 3.75],
    [46.42, 4.03], [46.67, 4.30], [46.92, 4.50], [47.23, 4.71], [47.82, 5.03], [50.81, 6.54],
    [52.13, 7.28], [52.82, 7.69], [53.93, 8.41], [54.76, 8.98], [55.99, 9.91], [56.80, 10.57],
    [57.60, 11.26], [58.74, 12.35], [59.82, 13.48], [60.57, 14.35], [61.28, 15.24], [62.27, 16.62],
    [62.88, 17.55], [63.73, 18.97], [64.75, 20.89], [65.47, 22.41], [66.13, 23.91], [66.70, 25.40],
    [67.18, 26.85], [67.45, 27.86], [67.63, 28.83], [67.72, 29.75], [67.69, 30.58], [67.64, 30.97],
    [67.47, 31.66], [67.24, 32.27], [67.09, 32.53], [66.78, 33.00], [66.36, 33.46], [66.12, 33.66],
    [65.55, 34.07], [63.89, 35.08], [62.20, 36.04], [61.85, 36.29], [61.63, 36.52], [61.42, 36.84],
    [61.30, 37.12], [61.21, 37.49], [61.19, 37.72], [61.20, 38.03], [61.24, 38.23], [61.59, 39.40],
    [61.86, 40.39], [62.15, 41.57], [62.36, 42.61], [62.66, 44.32], [62.92, 46.19], [63.20, 48.86],
    [63.33, 50.94], [63.39, 52.34], [63.41, 54.68], [63.35, 57.03], [63.23, 59.37], [62.95, 63.04],
    [62.70, 65.67], [62.33, 68.84], [61.95, 71.76], [61.62, 73.90], [60.97, 77.84], [60.88, 78.55],
    [60.89, 78.76], [60.93, 79.05], [61.02, 79.34], [61.15, 79.62], [61.32, 79.86], [61.47, 80.03],
    [61.69, 80.22], [61.92, 80.36], [63.99, 81.42], [64.66, 81.80], [65.44, 82.27], [66.15, 82.77],
    [66.47, 83.03], [67.04, 83.54], [67.27, 83.80], [67.44, 84.01], [67.72, 84.45], [67.83, 84.67],
    [67.98, 85.11], [68.06, 85.54], [68.08, 85.79], [68.05, 86.58], [67.90, 87.46], [67.64, 88.66],
    [67.39, 89.63], [66.99, 91.02], [66.57, 92.31], [66.14, 93.47], [65.63, 94.73], [65.23, 95.61],
    [64.55, 96.98], [64.03, 97.94], [63.45, 98.92], [62.94, 99.73], [61.79, 101.39], [61.16, 102.22],
    [59.81, 103.87], [59.09, 104.67], [58.34, 105.46], [57.01, 106.76], [56.10, 107.58], [55.18, 108.35],
    [54.27, 109.09], [53.36, 109.77], [52.48, 110.39], [51.62, 110.96], [50.30, 111.76], [48.95, 112.47],
    [48.03, 112.89], [47.24, 113.22], [46.99, 113.34], [46.78, 113.48], [46.59, 113.64], [46.29, 114.02],
    [46.11, 114.40], [45.97, 114.86], [45.81, 115.13], [45.59, 115.37], [45.21, 115.66], [44.69, 115.93],
    [44.04, 116.18], [43.50, 116.35], [42.59, 116.57], [41.91, 116.70], [40.81, 116.87], [40.02, 116.96],
    [38.32, 117.11], [35.76, 117.24], [34.44, 117.27], [32.48, 117.26], [30.57, 117.19], [28.79, 117.05],
    [27.34, 116.85], [26.14, 116.62], [25.10, 116.32], [24.51, 116.08], [24.00, 115.82], [23.57, 115.54],
    [23.22, 115.24], [23.02, 115.01], [22.85, 114.75], [22.71, 114.49], [22.47, 113.92], [22.33, 113.70],
    [22.16, 113.50], [21.97, 113.32], [21.77, 113.18], [21.37, 112.99], [20.21, 112.68], [19.14, 112.28],
    [18.06, 111.78], [16.86, 111.13], [15.92, 110.55], [14.41, 109.52], [13.11, 108.53], [11.82, 107.45],
    [10.98, 106.70], [9.76, 105.51], [8.98, 104.70], [7.94, 103.51], [7.29, 102.72], [6.12, 101.14],
    [5.58, 100.36], [4.62, 98.81], [3.93, 97.60], [3.24, 96.27], [2.64, 95.01], [1.94, 93.43],
    [1.02, 91.14], [0.52, 89.82], [0.27, 89.01], [0.17, 88.63], [0.04, 87.97], [0.00, 87.43],
    [0.01, 87.16], [0.08, 86.65], [0.15, 86.41], [0.30, 86.03], [0.46, 85.76], [0.75, 85.36],
    [0.99, 85.09], [1.25, 84.83], [1.87, 84.33], [2.67, 83.81], [3.15, 83.54], [4.14, 83.04],
    [5.10, 82.61], [6.00, 82.24], [6.39, 82.03], [6.68, 81.77], [6.92, 81.47], [7.09, 81.13],
    [7.19, 80.75], [7.22, 80.32], [7.17, 79.95], [6.80, 78.76], [6.44, 77.45], [6.11, 76.03],
    [5.88, 74.82], [5.52, 72.52], [5.26, 70.08], [5.11, 68.00], [5.04, 66.54], [4.97, 63.50],
    [5.00, 60.34], [5.08, 58.39], [5.19, 56.45]
];

function wolfcraft_accumobil_drilling_aid_holder_params() = [
    ["p", wolfcraft_accumobil_drilling_aid_holder_padding],
    ["h", wolfcraft_accumobil_drilling_aid_holder_height],
    ["wt", wolfcraft_accumobil_drilling_aid_holder_wall_thickness]
];

// Distance from the outline of the drilling aid to the outside of the walls.
function wolfcraft_accumobil_drilling_aid_holder_border() =
    wolfcraft_accumobil_drilling_aid_holder_padding + wolfcraft_accumobil_drilling_aid_holder_wall_thickness;

function wolfcraft_accumobil_drilling_aid_holder_size() =
    let(outline = wolfcraft_accumobil_drilling_aid_holder_outline, border = wolfcraft_accumobil_drilling_aid_holder_border())
    [max([for (p = outline) p[0]]) + 2 * border, max([for (p = outline) p[1]]) + 2 * border];

// The front end of the tray rests on the ground (z = 0), so the top edge of the back face lies
// this high.
function wolfcraft_accumobil_drilling_aid_holder_top() =
    wolfcraft_accumobil_drilling_aid_holder_size()[1] * sin(wolfcraft_accumobil_drilling_aid_holder_angle);

function wolfcraft_accumobil_drilling_aid_holder_wall_top() =
    wolfcraft_accumobil_drilling_aid_holder_floor
        + wolfcraft_accumobil_drilling_aid_holder_height - wolfcraft_accumobil_drilling_aid_holder_grip;

// Places the (x, u, v) plane of the tray.
module wolfcraft_accumobil_drilling_aid_holder_tilt() {
    a = wolfcraft_accumobil_drilling_aid_holder_angle;

    multmatrix([
        [1, 0, 0, 0],
        [0, cos(a), sin(a), 0],
        [0, -sin(a), cos(a), wolfcraft_accumobil_drilling_aid_holder_top()],
        [0, 0, 0, 1]
    ])
        children();
}

// Outline of the drilling aid grown by `distance` (a path), placed so the outside of the walls
// starts at x = 0 and u = 0.
function wolfcraft_accumobil_drilling_aid_holder_outline_path(distance) =
    let(border = wolfcraft_accumobil_drilling_aid_holder_border())
    [for (p = offset(wolfcraft_accumobil_drilling_aid_holder_outline, r = distance, closed = true)) p + [border, border]];

// Wedge and tray walls: the outside of the tray extruded down to the back face and the ground,
// the outer top edge of the walls is rounded.
module wolfcraft_accumobil_drilling_aid_holder_body() {
    size     = wolfcraft_accumobil_drilling_aid_holder_size();
    top      = wolfcraft_accumobil_drilling_aid_holder_top();
    below    = top * cos(wolfcraft_accumobil_drilling_aid_holder_angle) + 1;
    rounding = min(wolfcraft_accumobil_drilling_aid_holder_wall_rounding, wolfcraft_accumobil_drilling_aid_holder_wall_thickness / 2);

    intersection() {
        wolfcraft_accumobil_drilling_aid_holder_tilt()
            translate([0, 0, -below])
                ff_offset_sweep(
                    wolfcraft_accumobil_drilling_aid_holder_outline_path(wolfcraft_accumobil_drilling_aid_holder_border()),
                    height = below + wolfcraft_accumobil_drilling_aid_holder_wall_top(),
                    top    = os_circle(r = rounding),
                    steps  = 6
                );

        translate([-1, 0, 0])
            cube([size[0] + 2, size[1] + top, 2 * top + size[1]]);
    }
}

module wolfcraft_accumobil_drilling_aid_holder_pocket() {
    floor = wolfcraft_accumobil_drilling_aid_holder_floor;

    wolfcraft_accumobil_drilling_aid_holder_tilt()
        translate([0, 0, floor])
            linear_extrude(height = wolfcraft_accumobil_drilling_aid_holder_wall_top() - floor + 1)
                polygon(wolfcraft_accumobil_drilling_aid_holder_outline_path(wolfcraft_accumobil_drilling_aid_holder_padding));
}

// Parameters on the back face, below the tongue.
module wolfcraft_accumobil_drilling_aid_holder_label(params) {
    area_top    = wolfcraft_accumobil_drilling_aid_holder_top() - ff_slot_bottom_offset() - 2;
    area_bottom = 3;

    ff_engrave_params(
        params,
        [wolfcraft_accumobil_drilling_aid_holder_size()[0] / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = 36,
        max_height = area_top - area_bottom
    );
}

module feature_wolfcraft_accumobil_drilling_aid_holder() {
    assert(wolfcraft_accumobil_drilling_aid_holder_padding >= 0, "wolfcraft_accumobil_drilling_aid_holder_padding must not be negative.");
    assert(wolfcraft_accumobil_drilling_aid_holder_wall_thickness >= 1, "wolfcraft_accumobil_drilling_aid_holder_wall_thickness must be at least 1 mm.");
    assert(
        wolfcraft_accumobil_drilling_aid_holder_height >= wolfcraft_accumobil_drilling_aid_holder_grip + 3,
        str("wolfcraft_accumobil_drilling_aid_holder_height must be at least ", wolfcraft_accumobil_drilling_aid_holder_grip + 3, " mm.")
    );

    params = wolfcraft_accumobil_drilling_aid_holder_params();
    size   = wolfcraft_accumobil_drilling_aid_holder_size();
    top    = wolfcraft_accumobil_drilling_aid_holder_top();
    tongue = wolfcraft_accumobil_drilling_aid_holder_tongue_width;

    ff_echo_file_name("wolfcraft-accumobil-drilling-aid-holder", params);

    difference() {
        union() {
            wolfcraft_accumobil_drilling_aid_holder_body();

            translate([(size[0] - tongue) / 2, 0, 0])
                ff_tongue(tongue, top);
        }

        wolfcraft_accumobil_drilling_aid_holder_pocket();
        wolfcraft_accumobil_drilling_aid_holder_label(params);
    }
}
