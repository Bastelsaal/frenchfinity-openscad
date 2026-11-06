//
// Bit holder
//
// A block with a grid of holes for screwdriver bits, drill bits or other round shanks. The top of
// the block slopes down towards the front by `bit_holder_angle` and the holes are drilled at a
// right angle into that slope, so the bits lean forward and are easy to read and to grab.
//
// `bit_holder_rows` holes from back to front, `bit_holder_columns` from left to right. Every hole is
// `bit_holder_hole_diameter` + `bit_holder_hole_tolerance` wide and `bit_holder_hole_padding` away
// from its neighbours and the edges, so the hole grid defines the width and depth of the block.
// `bit_holder_height` sets the size of the block: the holes are height - 5 mm deep, the back and
// front faces are height + 5 mm tall. Like Frenchfinity 1.0, blocks higher than 20 mm get
// height - 20 mm of extra padding behind the first row, so the tilted holes stay clear of the back.
// The parameters are engraved into the sloped bottom face.
//

// Rounding of the hole rims (Frenchfinity 1.0).
bit_holder_hole_rounding = 1;
// Rounding of the front and top edges of the block (Frenchfinity 1.0).
bit_holder_edge_rounding = 2;
// The holes are height - 5 mm deep, the back and front faces height + 5 mm tall (Frenchfinity 1.0).
bit_holder_height_offset = 5;
// Blocks higher than this get the difference as extra padding behind the first row (Frenchfinity 1.0).
bit_holder_padding_height = 20;
// Minimum wall between the deepest point of a hole and the back face. 1.0 had no such limit, so
// shallow blocks with a small padding drilled the first row through the back face.
bit_holder_min_back_wall = 0.4;
// Minimum material below the holes.
bit_holder_min_bottom_wall = 1;

function bit_holder_params() = [
    ["r", bit_holder_rows],
    ["c", bit_holder_columns],
    ["hd", bit_holder_hole_diameter],
    ["hp", bit_holder_hole_padding],
    ["a", bit_holder_angle],
    ["h", bit_holder_height]
];

function bit_holder_hole_size() = bit_holder_hole_diameter + bit_holder_hole_tolerance;

function bit_holder_hole_depth() = bit_holder_height - bit_holder_height_offset;

// Height of the back and front faces (the block is a parallelogram seen from the side).
function bit_holder_thickness() = bit_holder_height + bit_holder_height_offset;

function bit_holder_width() =
    bit_holder_columns * bit_holder_hole_size() + (bit_holder_columns + 1) * bit_holder_hole_padding;

// Padding behind the first row on top of bit_holder_hole_padding: the 1.0 rule, raised where the
// first row would otherwise break through the back face.
function bit_holder_back_padding() =
    max(
        max(0, bit_holder_height - bit_holder_padding_height),
        (bit_holder_min_back_wall + bit_holder_hole_depth() * sin(bit_holder_angle)) / cos(bit_holder_angle)
            - bit_holder_hole_padding
    );

// Length of the sloped top face from the back edge to the front edge.
function bit_holder_slope_length() =
    bit_holder_back_padding()
        + bit_holder_hole_padding
        + bit_holder_rows * (bit_holder_hole_size() + bit_holder_hole_padding);

function bit_holder_depth() = bit_holder_slope_length() * cos(bit_holder_angle);

function bit_holder_top() = bit_holder_slope_length() * sin(bit_holder_angle) + bit_holder_thickness();

function bit_holder_bottom_wall() =
    bit_holder_thickness() * cos(bit_holder_angle) - bit_holder_hole_depth();

// Places children in the plane of the sloped top face: origin at the back edge of the top face,
// local x along the slot, local y down the slope (to the front), local z out of the top face.
module bit_holder_top_frame(top) {
    translate([0, 0, top])
        rotate([-bit_holder_angle, 0, 0])
            children();
}

// Side view: a parallelogram with vertical back and front faces and a rounded top front edge.
module bit_holder_side_profile_2d(depth, top) {
    drop = depth * tan(bit_holder_angle);
    path = [
        [0, top - bit_holder_thickness()],
        [0, top],
        [depth, top - drop],
        [depth, top - drop - bit_holder_thickness()]
    ];

    polygon(round_corners(path, radius = [0, 0, bit_holder_edge_rounding, 0], $fn = 24));
}

// The block is the intersection of three extrusions. Every face comes from exactly one of them,
// the others reach ff_eps beyond it, so no faces coincide.
module bit_holder_body(width, depth, top) {
    rounding = bit_holder_edge_rounding;
    length   = bit_holder_slope_length() + bit_holder_thickness();

    intersection() {
        // Side view: back, top, front and bottom faces, rounded top front edge.
        translate([-ff_eps, 0, 0])
            ff_profile_extrude(width + 2 * ff_eps)
                bit_holder_side_profile_2d(depth, top);

        // Top view: left and right faces, rounded vertical front edges.
        translate([0, 0, -1])
            linear_extrude(height = top + 2)
                polygon(round_corners(
                    [[0, -1], [0, depth + ff_eps], [width, depth + ff_eps], [width, -1]],
                    radius = [0, rounding, rounding, 0],
                    $fn = 24
                ));

        // Cross section of the sloped block: rounded edges between the top face and the sides.
        bit_holder_top_frame(top)
            rotate([90, 0, 0])
                linear_extrude(height = 2 * length, center = true)
                    polygon(round_corners(
                        [
                            [-ff_eps, -2 * length],
                            [-ff_eps, ff_eps],
                            [width + ff_eps, ff_eps],
                            [width + ff_eps, -2 * length]
                        ],
                        radius = [0, rounding, rounding, 0],
                        $fn = 24
                    ));
    }
}

// Cut body of one hole along -z from z = 0, with a rounded rim. The rim ends 2 x ff_eps above the
// surface, so the cut crosses the surface instead of touching it.
module bit_holder_hole(diameter, depth) {
    radius   = diameter / 2;
    rounding = min(bit_holder_hole_rounding, bit_holder_hole_padding / 3);
    steps    = 6;

    rotate_extrude($fn = ff_fn(radius + rounding))
        polygon(concat(
            [[0, -depth], [radius, -depth]],
            [
                for (i = [0 : steps])
                    let(angle = 180 - 90 * i / steps)
                        [radius + rounding + rounding * cos(angle), -rounding + rounding * sin(angle) + 2 * ff_eps]
            ],
            [[radius + rounding, 1], [0, 1]]
        ));
}

module bit_holder_holes(top) {
    size  = bit_holder_hole_size();
    pitch = size + bit_holder_hole_padding;
    first = bit_holder_hole_padding + size / 2;

    bit_holder_top_frame(top)
        for (row = [0 : bit_holder_rows - 1])
            for (column = [0 : bit_holder_columns - 1])
                translate([first + column * pitch, bit_holder_back_padding() + first + row * pitch, 0])
                    bit_holder_hole(size, bit_holder_hole_depth());
}

// Parameters on the sloped bottom face.
module bit_holder_label(params, width, top) {
    // The bottom face is the top face moved down by the thickness of the block.
    translate([0, 0, -bit_holder_thickness()])
        bit_holder_top_frame(top)
            ff_engrave_params(
                params,
                [width / 2, bit_holder_slope_length() / 2, 0],
                "bottom",
                max_width  = width - 4,
                max_height = bit_holder_slope_length() - 2 * bit_holder_edge_rounding - 2,
                rotations  = [0, 90]
            );
}

module feature_bit_holder() {
    assert(bit_holder_rows >= 1 && bit_holder_columns >= 1, "bit_holder_rows and bit_holder_columns must be at least 1.");
    assert(bit_holder_hole_size() > 0, "bit_holder_hole_diameter + bit_holder_hole_tolerance must be larger than 0.");
    assert(bit_holder_angle >= 0 && bit_holder_angle <= 60, "bit_holder_angle must be between 0 and 60 degrees.");
    assert(
        bit_holder_thickness() >= ff_slot_bottom_offset() + 0.5,
        str(
            "The back face is too low for the tongue. Increase bit_holder_height to at least ",
            ff_slot_bottom_offset() + 0.5 - bit_holder_height_offset,
            " mm."
        )
    );
    assert(
        bit_holder_bottom_wall() >= bit_holder_min_bottom_wall,
        str(
            "The holes reach through the bottom of the block (only ",
            bit_holder_bottom_wall(),
            " mm left). Reduce bit_holder_height or bit_holder_angle."
        )
    );

    params = bit_holder_params();
    width  = bit_holder_width();
    depth  = bit_holder_depth();
    top    = bit_holder_top();

    ff_echo_file_name("bit-holder", params);

    ff_holder(width, top)
        difference() {
            bit_holder_body(width, depth, top);
            bit_holder_holes(top);
            bit_holder_label(params, width, top);
        }
}
