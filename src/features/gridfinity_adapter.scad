//
// Gridfinity adapter
//
// A Gridfinity baseplate for the wall: gridfinity_adapter_grid_rows x gridfinity_adapter_grid_columns
// pockets on the 42 mm grid, tilted forward by gridfinity_adapter_angle degrees so the bins lean
// back against the wall and their contents can be seen from the front. The plate is 9.4 mm thick,
// its back edge starts at the top edge of the tongue, the space below it is filled down to a flat
// bottom (which carries the parameters). The pockets have the Frenchfinity 1.0 profile (42 mm
// opening with 4 mm corners, 45 degree chamfer down to 38.2 mm, 4.4 mm deep), standard Gridfinity
// bins fit into them. The two front corners of the plate are rounded.
//
// Frenchfinity 1.0 named its parts after half the actual tilt ("a10" parts are tilted by 20
// degrees), gridfinity_adapter_angle is the actual tilt.
//

gridfinity_adapter_grid             = 42;
gridfinity_adapter_floor_thickness  = 5;
gridfinity_adapter_pocket_depth     = 4.4;
gridfinity_adapter_chamfer          = 1.9;
gridfinity_adapter_pocket_rounding  = 4;
gridfinity_adapter_corner_rounding  = 4;
// Pockets are cut this much larger, so neighbours overlap instead of touching at the knife edges.
gridfinity_adapter_overlap          = 0.01;

function gridfinity_adapter_params() = [
    ["gr", gridfinity_adapter_grid_rows],
    ["gc", gridfinity_adapter_grid_columns],
    ["a", gridfinity_adapter_angle]
];

function gridfinity_adapter_width() = gridfinity_adapter_grid_columns * gridfinity_adapter_grid;
function gridfinity_adapter_length() = gridfinity_adapter_grid_rows * gridfinity_adapter_grid;
function gridfinity_adapter_thickness() = gridfinity_adapter_floor_thickness + gridfinity_adapter_pocket_depth;

// Height of the back face: the plate drops by length x sin(angle) towards the front, the back face
// also has to carry the tongue.
function gridfinity_adapter_top() =
    max(gridfinity_adapter_length() * sin(gridfinity_adapter_angle), ff_min_height());

// Maps the frame of the plate to the part: x stays, y runs along the plate from its back edge to
// the front, z is at right angles to the plate (z = 0 is its underside).
module gridfinity_adapter_plate_frame() {
    translate([0, 0, gridfinity_adapter_top()])
        rotate([-gridfinity_adapter_angle, 0, 0])
            children();
}

function gridfinity_adapter_plate_point(u, w) =
    let(a = gridfinity_adapter_angle)
    [u * cos(a) + w * sin(a), gridfinity_adapter_top() - u * sin(a) + w * cos(a)];

// Side view (y, z): the tilted plate and the filling below it down to z = 0. It reaches a bit
// beyond the front of the plate, the footprint cuts the front face.
module gridfinity_adapter_profile_2d() {
    a      = gridfinity_adapter_angle;
    t      = gridfinity_adapter_thickness();
    back   = gridfinity_adapter_plate_point(0, t);
    front  = gridfinity_adapter_plate_point(gridfinity_adapter_length(), t)[0] + 1;

    polygon([
        [0, 0],
        [front, 0],
        [front, back[1] - (front - back[0]) * tan(a)],
        back,
        [0, gridfinity_adapter_top()]
    ]);
}

module gridfinity_adapter_rounded_square(size, r) {
    offset(r = r)
        square(size - 2 * r, center = true);
}

// Cut body of one pocket, centered on the origin, its opening at z = 0.
module gridfinity_adapter_pocket() {
    o       = gridfinity_adapter_overlap;
    size    = gridfinity_adapter_grid + 2 * o;
    r       = gridfinity_adapter_pocket_rounding + o;
    chamfer = gridfinity_adapter_chamfer;
    depth   = gridfinity_adapter_pocket_depth;

    // The chamfer continues 1 mm above the opening, so the cut crosses the top face instead of
    // having an edge in it.
    hull() {
        translate([0, 0, 1])
            linear_extrude(height = ff_eps)
                gridfinity_adapter_rounded_square(size + 2, r + 1);

        translate([0, 0, -chamfer])
            linear_extrude(height = ff_eps)
                gridfinity_adapter_rounded_square(size - 2 * chamfer, r - chamfer);
    }

    translate([0, 0, -depth])
        linear_extrude(height = depth - chamfer + ff_eps)
            gridfinity_adapter_rounded_square(size - 2 * chamfer, r - chamfer);
}

// Cut body between the rounded corners of the pockets around a grid point: like Frenchfinity 1.0,
// the corner posts are cut down to the floor of the pockets.
module gridfinity_adapter_post_gap() {
    r = gridfinity_adapter_pocket_rounding;

    translate([0, 0, -gridfinity_adapter_pocket_depth])
        linear_extrude(height = gridfinity_adapter_pocket_depth + 1)
            difference() {
                square(2 * r, center = true);

                for (x = [-r, r], y = [-r, r])
                    translate([x, y])
                        circle(r = r);
            }
}

// Top view of the plate in its own frame: it cuts the front face and rounds the front corners.
// It reaches far behind the plate and beyond its sides, so its other faces never lie in a face of
// the part (the rotation leaves tiny errors, faces that nearly coincide leave non manifold edges).
// For the same reason the roundings cross the side faces instead of touching them.
module gridfinity_adapter_footprint_2d() {
    width  = gridfinity_adapter_width();
    length = gridfinity_adapter_length();
    r      = gridfinity_adapter_corner_rounding;
    behind = gridfinity_adapter_top() + length + 10;
    shift  = 0.01;

    difference() {
        translate([-1, -behind])
            square([width + 2, behind + length]);

        for (side = [[0, 1], [width, -1]])
            difference() {
                translate([side[1] > 0 ? -1 : width - r + shift, length - r])
                    square([r + 1 - shift, r + 1]);

                translate([side[0] + side[1] * (r - shift), length - r])
                    circle(r = r);
            }
    }
}

// Parameters on the bottom face.
module gridfinity_adapter_label(params) {
    width = gridfinity_adapter_width();
    depth = gridfinity_adapter_plate_point(gridfinity_adapter_length(), 0)[0];

    ff_engrave_params(
        params,
        [width / 2, depth / 2, 0],
        "bottom",
        max_width  = width - 10,
        max_height = depth - 10,
        per_line   = 3
    );
}

module feature_gridfinity_adapter() {
    assert(gridfinity_adapter_grid_rows >= 1 && gridfinity_adapter_grid_columns >= 1, "At least one row and one column are needed.");
    assert(gridfinity_adapter_angle >= 0 && gridfinity_adapter_angle <= 60, "gridfinity_adapter_angle must be between 0 and 60 degrees.");

    params = gridfinity_adapter_params();
    width  = gridfinity_adapter_width();
    grid   = gridfinity_adapter_grid;
    t      = gridfinity_adapter_thickness();

    ff_echo_file_name("gridfinity-adapter", params);

    difference() {
        ff_holder(width, gridfinity_adapter_top())
            intersection() {
                ff_profile_extrude(width)
                    gridfinity_adapter_profile_2d();

                gridfinity_adapter_plate_frame()
                    translate([0, 0, -500])
                        linear_extrude(height = 1000)
                            gridfinity_adapter_footprint_2d();
            }

        gridfinity_adapter_plate_frame() {
            for (i = [0 : gridfinity_adapter_grid_columns - 1], j = [0 : gridfinity_adapter_grid_rows - 1])
                translate([(i + 0.5) * grid, (j + 0.5) * grid, t])
                    gridfinity_adapter_pocket();

            // Not at the two front corners, the plate itself is rounded there.
            for (i = [0 : gridfinity_adapter_grid_columns], j = [0 : gridfinity_adapter_grid_rows])
                if (j < gridfinity_adapter_grid_rows || (i > 0 && i < gridfinity_adapter_grid_columns))
                    translate([i * grid, j * grid, t])
                        gridfinity_adapter_post_gap();
        }

        gridfinity_adapter_label(params);
    }
}
