//
// Crowbar holder
//
// Holds a crowbar (nail bar with a curved neck) upright: the shaft hangs down inside the open box,
// lying in a groove on the back of the curved front wall, and the curved neck rests on the lip at
// the top of the front wall, so the claw points out to the front. The box is open at the top and
// at the bottom, the crowbar is lifted out upwards.
//
// The shapes follow the crowbar of Frenchfinity 1.0: side walls, back block and front wall are
// extrusions of profiles measured from the 1.0 part. The groove for the shaft is swept along the
// curved back face of the front wall; `crowbar_holder_shaft_width` and `crowbar_holder_shaft_depth`
// adapt it to a slightly thicker or thinner shaft (the front wall grows with the groove). The
// parameters are engraved into the back face below the tongue.
//

crowbar_holder_width = 60;
crowbar_holder_height = 109.96;
crowbar_holder_side_wall = 5;
// Width of the front wall beside the groove (1.0).
crowbar_holder_groove_margin = 1.73;
// The groove flanks move this far inwards per mm of groove depth (1.0: 3.96 mm on 6.73 mm).
crowbar_holder_groove_flank = 3.96 / 6.73;
// Rounding of the free side of the front wall and of the inner edges of the side walls (1.0).
crowbar_holder_front_rounding = 2;

// Side profile in the (y, z) plane: back face at y = 0, curved front face with the lip (1.0).
crowbar_holder_side_profile = [
    [0, 0], [59.05, 0], [59.05, 30], [59.17, 34.8], [59.17, 39.38], [59.11, 42.34], [59, 45.24],
    [58.82, 48.11], [58.58, 50.94], [58.27, 53.75], [57.88, 56.54], [57.41, 59.33], [56.78, 62.46],
    [56.05, 65.57], [55.26, 68.64], [52.89, 77.07], [52.09, 80.16], [51.68, 81.93], [51.21, 84.32],
    [50.97, 85.96], [50.88, 87.08], [51.76, 87.91], [52.81, 88.8], [54.03, 89.75], [54.77, 90.29],
    [55.5, 90.78], [56.91, 91.65], [58.46, 92.46], [60.05, 93.12], [62.07, 93.77], [63.94, 94.29],
    [68.28, 95.36], [68.56, 95.47], [68.83, 95.62], [69.07, 95.82], [69.28, 96.06], [69.44, 96.3],
    [69.6, 96.69], [69.66, 96.98], [69.68, 97.35], [69.13, 109.96], [0, 109.96]
];

// Profile of the back block between the side walls (1.0).
crowbar_holder_back_profile = [
    [0, 0], [25.08, 0], [25.08, 30], [25.22, 45.45], [25.2, 46.11], [25.14, 46.59], [24.67, 48.23],
    [24.37, 49.4], [22.85, 55.89], [20.94, 63.56], [19.98, 67.56], [19.26, 70.8], [18.72, 73.38],
    [18.36, 75.21], [17.84, 78.24], [17.57, 80.05], [17.29, 82.32], [17.14, 83.96], [17.05, 85.56],
    [17, 87.09], [17.01, 88.57], [17.08, 90.06], [17.2, 91.47], [7.94, 96.77], [7.94, 109.96],
    [0, 109.96]
];
// The top front corner of the back block is rounded (1.0: 2 mm, a bit more here, so the rounding
// does not start exactly where the rounding of the side walls ends).
crowbar_holder_back_rounding = 2.2;

// Back face of the front wall and top face of its lip, from the bottom to the end of the lip. The
// groove is swept along it. Extended beyond the part at both ends (1.0).
crowbar_holder_groove_path = [
    [45.04, -10], [45.04, 0], [45.04, 30], [45.17, 34.57], [45.18, 38.95], [45.05, 43.65],
    [44.84, 47.33], [44.69, 49.12], [44.29, 52.63], [44.05, 54.35], [43.77, 56.07], [43.22, 58.93],
    [42.9, 60.36], [42.2, 63.26], [41.4, 66.23], [39.63, 72.5], [38.97, 74.95], [38.01, 78.87],
    [37.45, 81.73], [37.23, 83.11], [36.99, 85.1], [36.88, 86.97], [36.89, 88.13], [36.93, 88.82],
    [37.08, 90.11], [37.36, 91.31], [37.54, 91.88], [37.99, 92.97], [38.57, 94.02], [38.92, 94.55],
    [39.73, 95.61], [40.7, 96.69], [41.24, 97.24], [42.47, 98.39], [43.84, 99.55], [45.31, 100.71],
    [46.86, 101.84], [49.02, 103.25], [50.47, 104.09], [51.94, 104.85], [53.53, 105.58],
    [55.27, 106.27], [57.04, 106.88], [59.84, 107.68], [62.58, 108.38], [66.97, 109.42],
    [78.65, 112.19]
];

// Profile of the front wall: the side profile in front of the groove path, reaching 3 mm below the
// part so its rounded side ends cleanly at the bottom face.
crowbar_holder_front_profile = [
    [45.04, -3], [59.05, -3], [59.05, 30], [59.17, 34.8], [59.17, 39.38], [59.11, 42.34], [59, 45.24],
    [58.82, 48.11], [58.58, 50.94], [58.27, 53.75], [57.88, 56.54], [57.41, 59.33], [56.78, 62.46],
    [56.05, 65.57], [55.26, 68.64], [52.89, 77.07], [52.09, 80.16], [51.68, 81.93], [51.21, 84.32],
    [50.97, 85.96], [50.88, 87.08], [51.76, 87.91], [52.81, 88.8], [54.03, 89.75], [54.77, 90.29],
    [55.5, 90.78], [56.91, 91.65], [58.46, 92.46], [60.05, 93.12], [62.07, 93.77], [63.94, 94.29],
    [68.28, 95.36], [68.56, 95.47], [68.83, 95.62], [69.07, 95.82], [69.28, 96.06], [69.44, 96.3],
    [69.6, 96.69], [69.66, 96.98], [69.68, 97.35], [69.13, 109.96], [66.97, 109.42], [62.58, 108.38],
    [59.84, 107.68], [57.04, 106.88], [55.27, 106.27], [53.53, 105.58], [51.94, 104.85],
    [50.47, 104.09], [49.02, 103.25], [46.86, 101.84], [45.31, 100.71], [43.84, 99.55], [42.47, 98.39],
    [41.24, 97.24], [40.7, 96.69], [39.73, 95.61], [38.92, 94.55], [38.57, 94.02], [37.99, 92.97],
    [37.54, 91.88], [37.36, 91.31], [37.08, 90.11], [36.93, 88.82], [36.89, 88.13], [36.88, 86.97],
    [36.99, 85.1], [37.23, 83.11], [37.45, 81.73], [38.01, 78.87], [38.97, 74.95], [39.63, 72.5],
    [41.4, 66.23], [42.2, 63.26], [42.9, 60.36], [43.22, 58.93], [43.77, 56.07], [44.05, 54.35],
    [44.29, 52.63], [44.69, 49.12], [44.84, 47.33], [45.05, 43.65], [45.18, 38.95], [45.17, 34.57],
    [45.04, 30]
];

function crowbar_holder_params() = [
    ["sw", crowbar_holder_shaft_width],
    ["sd", crowbar_holder_shaft_depth]
];

// x range of the front wall and center of its groove.
function crowbar_holder_front_right() = crowbar_holder_width - crowbar_holder_side_wall;
function crowbar_holder_front_left() =
    crowbar_holder_front_right() - crowbar_holder_shaft_width - 2 * crowbar_holder_groove_margin;
function crowbar_holder_groove_center() =
    crowbar_holder_front_right() - crowbar_holder_groove_margin - crowbar_holder_shaft_width / 2;

function crowbar_holder_unit(v) = v / norm(v);

// Tangent and normal (pointing into the front wall) of the groove path at point i.
function crowbar_holder_tangent(path, i) =
    let(
        a = i > 0 ? crowbar_holder_unit(path[i] - path[i - 1]) : [0, 0],
        b = i < len(path) - 1 ? crowbar_holder_unit(path[i + 1] - path[i]) : [0, 0]
    )
    crowbar_holder_unit(a + b);

function crowbar_holder_normal(path, i) =
    let(t = crowbar_holder_tangent(path, i)) [t[1], -t[0]];

// Placement of the groove cross section at point i of the groove path: local x stays x, local y
// runs along the normal into the front wall, local z along the path.
function crowbar_holder_groove_transform(i) =
    let(
        p = crowbar_holder_groove_path[i],
        n = crowbar_holder_normal(crowbar_holder_groove_path, i)
    )
    [
        [1, 0, 0, 0],
        [0, n[0], -n[1], p[0]],
        [0, n[1], n[0], p[1]],
        [0, 0, 0, 1]
    ];

// Groove for the shaft, swept along the back face of the front wall. It reaches 3 mm behind the
// back face so it cuts cleanly.
module crowbar_holder_groove() {
    center = crowbar_holder_groove_center();
    top    = crowbar_holder_shaft_width / 2;
    bottom = top - crowbar_holder_shaft_depth * crowbar_holder_groove_flank;
    depth  = crowbar_holder_shaft_depth;
    // The flanks continue 0.5 mm behind the back face, so no groove edge lies on it.
    behind = top + 0.5 * crowbar_holder_groove_flank;

    // Clockwise, so the swept polyhedron is not inside out with this frame.
    sweep(
        [
            [center - behind, -0.5],
            [center - bottom, depth],
            [center + bottom, depth],
            [center + behind, -0.5],
            [center + behind, -3],
            [center - behind, -3]
        ],
        [for (i = [0 : len(crowbar_holder_groove_path) - 1]) crowbar_holder_groove_transform(i)]
    );
}

// Front wall with the lip, from its rounded free side through the right side wall.
module crowbar_holder_front() {
    left = crowbar_holder_front_left();

    intersection() {
        translate([left, 0, 0])
            rotate([90, 0, 90])
                ff_offset_sweep(
                    crowbar_holder_front_profile,
                    height = crowbar_holder_width - left,
                    bottom = os_circle(r = crowbar_holder_front_rounding),
                    steps  = 4
                );

        translate([left - 1, -1, 0])
            cube([crowbar_holder_width - left + 2, 100, crowbar_holder_height + 1]);
    }
}

// Right side wall without the front wall (which runs through it). It overlaps the front wall by
// 0.1 mm, so both merge without touching faces, and stays away from the corner at the end of the
// lip, where it would only leave a sliver.
module crowbar_holder_right_wall_2d() {
    intersection() {
        polygon(crowbar_holder_side_profile);

        offset(delta = 0.1)
            difference() {
                polygon(crowbar_holder_side_profile);
                polygon(crowbar_holder_front_profile);
            }

        square([68, crowbar_holder_height + 1]);
    }
}

// Left side wall, the edges of its inner face are rounded. The profile is extended behind the
// mounting plane and below the bottom, so only the front and the top edges end up rounded.
module crowbar_holder_left_wall() {
    path = [
        for (p = crowbar_holder_side_profile)
            [p[0] == 0 ? -3 : p[0], p[1] == 0 ? -3 : p[1]]
    ];

    intersection() {
        rotate([90, 0, 90])
            ff_offset_sweep(
                path,
                height = crowbar_holder_side_wall,
                top    = os_circle(r = crowbar_holder_front_rounding),
                steps  = 4
            );

        translate([-1, 0, 0])
            cube([crowbar_holder_side_wall + 2, 100, crowbar_holder_height]);
    }
}

// Right side wall, the top edge of its inner face is rounded.
module crowbar_holder_right_wall() {
    r = crowbar_holder_front_rounding;
    x = crowbar_holder_width - crowbar_holder_side_wall;
    h = crowbar_holder_height;

    difference() {
        translate([x, 0, 0])
            ff_profile_extrude(crowbar_holder_side_wall)
                crowbar_holder_right_wall_2d();

        translate([0, -1, 0])
            rotate([-90, 0, 0])
                linear_extrude(height = 100)
                    difference() {
                        translate([x - 1, -h - 1]) square([r + 1, r + 1]);
                        translate([x + r, -(h - r)]) circle(r = r, $fn = 32);
                    }
    }
}

module feature_crowbar_holder() {
    w    = crowbar_holder_width;
    h    = crowbar_holder_height;
    wall = crowbar_holder_side_wall;

    assert(
        crowbar_holder_shaft_depth < 12,
        "crowbar_holder_shaft_depth must be smaller than 12 mm, the front wall is 14 mm thick."
    );
    assert(
        crowbar_holder_shaft_depth * crowbar_holder_groove_flank < crowbar_holder_shaft_width / 2 - 1,
        "The groove is too deep for its width: increase crowbar_holder_shaft_width or decrease crowbar_holder_shaft_depth."
    );
    assert(
        crowbar_holder_front_left() >= wall + 5,
        "crowbar_holder_shaft_width is too large for the box."
    );

    params       = crowbar_holder_params();
    label_top    = h - ff_slot_bottom_offset() - 2;
    label_bottom = 3;

    ff_echo_file_name("crowbar-holder", params);

    difference() {
        union() {
            crowbar_holder_left_wall();
            crowbar_holder_right_wall();

            // The back block reaches 1 mm into both side walls, where their inner top edges are
            // rounded, so it overlaps them without sharing their top faces.
            translate([wall - 1, 0, 0])
                ff_profile_extrude(w - 2 * wall + 2)
                    polygon(round_corners(
                        crowbar_holder_back_profile,
                        radius = [
                            for (i = [0 : len(crowbar_holder_back_profile) - 1])
                                i == len(crowbar_holder_back_profile) - 2 ? crowbar_holder_back_rounding : 0
                        ],
                        $fn = 32
                    ));

            difference() {
                crowbar_holder_front();
                crowbar_holder_groove();
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
