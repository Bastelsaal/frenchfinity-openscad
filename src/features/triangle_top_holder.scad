//
// Triangle top holder
//
// A pocket for flat tools with a pointed (triangular) end, e.g. a set square, a scraper or a
// trowel, that stand in it point down. The pocket is triangle_top_holder_tool_width +
// 2 x tolerance wide and triangle_top_holder_tool_depth deep (from the wall to the front),
// triangle_top_holder_holder_height high above the inner floor. Its bottom is a V: the tip sits on
// the floor, the upper corners of the V and the top of the low front wall are
// triangle_top_holder_triangle_height + tolerance above the bottom of the part. Above the front
// wall the pocket is open to the front, the side walls curve back to the depth of the pocket, so
// the tool can be gripped and pulled out to the front.
//

// Radius of the roundings in the V of the pocket and of the top front corners (Frenchfinity 1.0).
triangle_top_holder_rounding = 5;
// Radius of the rounded inner top edge of the front wall (Frenchfinity 1.0).
triangle_top_holder_front_rounding = 2;

function triangle_top_holder_params() = [
    ["tw", triangle_top_holder_tool_width],
    ["hh", triangle_top_holder_holder_height],
    ["th", triangle_top_holder_triangle_height],
    ["td", triangle_top_holder_tool_depth],
    ["tol", triangle_top_holder_tolerance],
    ["wt", triangle_top_holder_wall_thickness]
];

function triangle_top_holder_pocket_width() = triangle_top_holder_tool_width + 2 * triangle_top_holder_tolerance;
function triangle_top_holder_width() = triangle_top_holder_pocket_width() + 2 * triangle_top_holder_wall_thickness;
function triangle_top_holder_depth() = triangle_top_holder_tool_depth + 2 * triangle_top_holder_wall_thickness;
function triangle_top_holder_height() = triangle_top_holder_holder_height + triangle_top_holder_wall_thickness;

// Height of the upper corners of the V and of the front wall.
function triangle_top_holder_front_height() = triangle_top_holder_triangle_height + triangle_top_holder_tolerance;

// Front view (x, z) of the pocket: straight sides, a V shaped bottom with rounded corners.
module triangle_top_holder_pocket_2d() {
    wt     = triangle_top_holder_wall_thickness;
    width  = triangle_top_holder_width();
    height = triangle_top_holder_height();
    front  = triangle_top_holder_front_height();
    r      = min(triangle_top_holder_rounding, triangle_top_holder_pocket_width() / 2 - 0.1);

    offset(r = r)
        offset(delta = -r)
            polygon([
                [wt, height + r + 1],
                [wt, front],
                [width / 2, wt],
                [width - wt, front],
                [width - wt, height + r + 1]
            ]);
}

// Side view (y, z) of the cut that shapes the front edge of the side walls: above the front wall
// they curve back to the depth of the pocket (radius 2 x holder height, like Frenchfinity 1.0),
// the top front corner is rounded.
module triangle_top_holder_side_cut_2d() {
    wt     = triangle_top_holder_wall_thickness;
    depth  = triangle_top_holder_depth();
    height = triangle_top_holder_height();
    front  = triangle_top_holder_front_height();
    radius = 2 * triangle_top_holder_holder_height;
    r      = min(triangle_top_holder_rounding, depth - wt);
    // The curve is tangent to the front face of the pocket at z = tangent_z.
    tangent_z = front + sqrt(2 * radius * wt - wt * wt);
    arc_end   = min(tangent_z, height);
    steps     = 24;

    function curve_y(z) = depth - wt + radius - sqrt(radius * radius - pow(z - tangent_z, 2));

    curve = [for (i = [0 : steps]) let(z = front + (arc_end - front) * i / steps) [curve_y(z), z]];
    // The top front corner is only rounded when the curve ends below it. The rounding is moved up
    // by 0.01 mm, so it crosses the top face instead of touching it.
    corner = tangent_z <= height - r
        ? concat(
            [[depth - wt, height - r + 0.01]],
            [for (a = [0 : 15 : 90]) [depth - wt - r + r * cos(a), height - r + 0.01 + r * sin(a)]]
        )
        : [[curve_y(arc_end), height]];

    // Moved 0.01 mm to the front: the cut then starts in front of the front face instead of on its
    // top edge, which leaves non manifold edges.
    translate([0.01, 0])
        polygon(concat([[depth + 1, front]], curve, corner, [[corner[len(corner) - 1][0], height + 1], [depth + 1, height + 1]]));
}

// Cut body of the pocket: the front view of the pocket, cut from the back wall through the front,
// without the low front wall (whose inner top edge is rounded).
module triangle_top_holder_pocket_cut() {
    wt    = triangle_top_holder_wall_thickness;
    width = triangle_top_holder_width();
    depth = triangle_top_holder_depth();
    inner = wt + triangle_top_holder_tool_depth;
    front = triangle_top_holder_front_height();
    r     = min(triangle_top_holder_front_rounding, wt / 2);

    difference() {
        translate([0, depth + 1, 0])
            rotate([90, 0, 0])
                linear_extrude(height = depth + 1 - wt)
                    triangle_top_holder_pocket_2d();

        translate([-1, 0, 0])
            ff_extrude_along_x(width + 2)
                hull() {
                    translate([inner + r, front - r])
                        circle(r = r);

                    translate([inner, -1])
                        square([depth + 2 - inner, front - r + 1]);

                    translate([inner + r, -1])
                        square([depth + 2 - inner - r, front + 1]);
                }
    }
}

// Parameters on the back face, below the tongue.
module triangle_top_holder_label(params) {
    width    = triangle_top_holder_width();
    area_top = triangle_top_holder_height() - ff_slot_bottom_offset() - 2;

    ff_engrave_params(
        params,
        [width / 2, 0, (area_top + 2) / 2],
        "back",
        max_width  = width - 6,
        max_height = area_top - 2
    );
}

module feature_triangle_top_holder() {
    wt     = triangle_top_holder_wall_thickness;
    width  = triangle_top_holder_width();
    depth  = triangle_top_holder_depth();
    height = triangle_top_holder_height();
    front  = triangle_top_holder_front_height();

    assert(wt >= 1, "triangle_top_holder_wall_thickness must be at least 1 mm.");
    assert(height >= ff_min_height(), str("The holder must be at least ", ff_min_height(), " mm high."));
    assert(
        front > wt + 1,
        "triangle_top_holder_triangle_height is too small: the V would not rise above the floor."
    );
    assert(
        front < height,
        "triangle_top_holder_triangle_height must be smaller than the holder height (triangle_top_holder_holder_height + wall thickness - tolerance)."
    );

    params = triangle_top_holder_params();

    ff_echo_file_name("triangle-top-holder", params);

    difference() {
        ff_holder(width, height)
            cube([width, depth, height]);

        triangle_top_holder_pocket_cut();

        // Front edge of the side walls
        translate([-1, 0, 0])
            ff_extrude_along_x(width + 2)
                triangle_top_holder_side_cut_2d();

        triangle_top_holder_label(params);
    }
}
