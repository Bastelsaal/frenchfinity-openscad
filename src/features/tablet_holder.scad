//
// Tablet holder
//
// Holds a tablet (or a phone, a book ...) leaning back at tablet_holder_angle degrees. Seen from
// the side the holder is a triangle: the back plate with the tongue, a bottom bar and a slanted
// back rest that starts at the top edge of the back plate. Like in Frenchfinity 1.0 the back rest
// is tablet_holder_tablet_height long and as thick as the tablet. At its lower end a lip forms a
// channel for the bottom edge of the tablet, tablet_holder_tablet_thickness +
// 2 x tablet_holder_tablet_tolerance wide. Back plate, bottom bar and lip are
// tablet_holder_wall_thickness thick.
//

// Roundings of the side view (Frenchfinity 1.0).
tablet_holder_top_rounding    = 6;
tablet_holder_bottom_rounding = 20;
tablet_holder_small_rounding  = 3;
// The lip rises this much above the floor of the channel.
tablet_holder_lip_height      = 10;

function tablet_holder_params() = [
    ["w", tablet_holder_width],
    ["th", tablet_holder_tablet_height],
    ["a", tablet_holder_angle],
    ["wt", tablet_holder_wall_thickness],
    ["tt", tablet_holder_tablet_thickness],
    ["tol", tablet_holder_tablet_tolerance]
];

// Height of the back plate: the back rest starts at its top edge on the mounting plane.
function tablet_holder_height() = tablet_holder_tablet_height * cos(tablet_holder_angle);

// Points in the frame of the back rest: s runs down along its back face from the top edge,
// q runs from its back face to the front.
function tablet_holder_point(s, q) =
    let(a = tablet_holder_angle)
    [s * sin(a) + q * cos(a), tablet_holder_height() - s * cos(a) + q * sin(a)];

// Side view (y, z) of the outline: back plate, bottom bar, back rest and the lip with the channel.
function tablet_holder_outline() =
    let(
        th      = tablet_holder_tablet_height,
        tt      = tablet_holder_tablet_thickness,
        wt      = tablet_holder_wall_thickness,
        channel = tt + 2 * tablet_holder_tablet_tolerance,
        lip     = wt + tablet_holder_lip_height
    )
    [
        [0, 0],                                          // back, bottom
        tablet_holder_point(th, 0),                      // bottom end of the back rest
        tablet_holder_point(th, tt + channel + wt),      // lip, outside bottom
        tablet_holder_point(th - lip, tt + channel + wt),// lip, outside top
        tablet_holder_point(th - lip, tt + channel),     // lip, inside top
        tablet_holder_point(th - wt, tt + channel),      // channel floor at the lip
        tablet_holder_point(th - wt, tt),                // channel floor at the back rest
        tablet_holder_point(0, tt),                      // back rest, front top
        [0, tablet_holder_height()]                      // back, top
    ];

function tablet_holder_lip_rounding() = min(tablet_holder_small_rounding, tablet_holder_wall_thickness / 2 - 0.01);

// Radius of the rounded edges on the left and right side, limited so the thinnest bars keep some
// material at the side faces.
function tablet_holder_edge_rounding() =
    min(tablet_holder_small_rounding, tablet_holder_wall_thickness / 2 - 0.1, tablet_holder_tablet_thickness / 2 - 0.1);

// Rounded outline. The back face is moved `back` behind the mounting plane (above the rounded
// bottom corner), so the side edges of the back face can be cut off sharp later.
function tablet_holder_rounded_outline(back = 0) =
    let(
        wt       = tablet_holder_wall_thickness,
        bottom_r = min(tablet_holder_top_rounding, wt),
        small    = tablet_holder_lip_rounding(),
        rounded  = round_corners(
            tablet_holder_outline(),
            method = "circle",
            radius = [
                bottom_r,
                tablet_holder_bottom_rounding,
                small,
                small,
                small,
                0,
                small,
                min(tablet_holder_top_rounding, tablet_holder_tablet_thickness - 0.01),
                0
            ],
            $fn = 64
        )
    )
    back > 0
        // round_corners starts with the arc of the first corner (back, bottom), the top back
        // corner is the last point.
        ? concat([[-back, bottom_r]], rounded, [[-back, tablet_holder_height()]])
        : rounded;

// Opening between back plate, bottom bar and back rest.
function tablet_holder_opening() =
    let(
        wt = tablet_holder_wall_thickness,
        a  = tablet_holder_angle,
        h  = tablet_holder_height()
    )
    [[wt, wt], [(h - wt) * tan(a), wt], [wt, h - wt / tan(a)]];

// The side view extruded along x, all edges on the left and right side rounded except those of
// the back face, which lies on the anchor.
module tablet_holder_body() {
    r    = tablet_holder_edge_rounding();
    back = r + 1;

    // Same orientation as ff_extrude_along_x: the path's x is y, its y is z, the sweep runs along x.
    rotate([90, 0, 90])
        intersection() {
            difference() {
                ff_offset_sweep(
                    tablet_holder_rounded_outline(back),
                    height = tablet_holder_width,
                    bottom = os_circle(r = r),
                    top    = os_circle(r = r),
                    steps  = 6
                );

                ff_offset_sweep(
                    tablet_holder_opening(),
                    height = tablet_holder_width,
                    bottom = os_circle(r = -r),
                    top    = os_circle(r = -r),
                    steps  = 6,
                    extra  = 1
                );
            }

            translate([0, -1, -1])
                cube([tablet_holder_tablet_height + 100, tablet_holder_height() + 100, tablet_holder_width + 2]);
        }
}

// Parameters on the back face, below the tongue.
module tablet_holder_label(params) {
    area_top    = tablet_holder_height() - ff_slot_bottom_offset() - 2;
    area_bottom = min(tablet_holder_top_rounding, tablet_holder_wall_thickness) + 2;

    ff_engrave_params(
        params,
        [tablet_holder_width / 2, 0, (area_top + area_bottom) / 2],
        "back",
        max_width  = tablet_holder_width - 4,
        max_height = area_top - area_bottom
    );
}

module feature_tablet_holder() {
    wt = tablet_holder_wall_thickness;
    a  = tablet_holder_angle;
    h  = tablet_holder_height();

    assert(a >= 5 && a <= 60, "tablet_holder_angle must be between 5 and 60 degrees.");
    assert(wt >= 2, "tablet_holder_wall_thickness must be at least 2 mm.");
    assert(tablet_holder_tablet_thickness >= 2, "tablet_holder_tablet_thickness must be at least 2 mm.");
    assert(
        h >= ff_min_height() + 2 * wt && h - wt / tan(a) > wt + 1 && (h - wt) * tan(a) > wt + 1,
        "tablet_holder_tablet_height is too small for this angle and wall thickness."
    );

    params = tablet_holder_params();

    ff_echo_file_name("tablet-holder", params);

    difference() {
        ff_holder(tablet_holder_width, h)
            tablet_holder_body();

        tablet_holder_label(params);
    }
}
