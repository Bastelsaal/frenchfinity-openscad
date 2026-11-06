//
// Sandpaper holder
//
// A compartment that is open to the front for sheets of sandpaper (or paper, foils ...), with an
// inner size of sandpaper_holder_width x sandpaper_holder_depth x sandpaper_holder_height and
// walls of sandpaper_holder_wall_thickness. Holders stack into a tower: the slots on the top take
// the tongues below the next holder, which slides in from the back until it hits the closed front
// end of the slots. Only the lowest holder needs the tongue on its back to hang on the wall, the
// ones above can leave it out (sandpaper_holder_attached, "-attached" in Frenchfinity 1.0).
//

// One stacking slot (and tongue below) per this many mm of width (Frenchfinity 1.0).
sandpaper_holder_slot_spacing = 40;
// The stacking slots end this far behind the front, the tongues below one mm earlier.
sandpaper_holder_slot_front_wall = 4;
sandpaper_holder_tongue_front_gap = 5;
// Material between the reference top of the wall tongue and the bottom of the stacking slots.
sandpaper_holder_slot_floor = 1;
// Radius of the rounded edges around the front opening.
sandpaper_holder_rounding = 1;

function sandpaper_holder_params() = concat(
    [
        ["w", sandpaper_holder_width],
        ["d", sandpaper_holder_depth],
        ["h", sandpaper_holder_height],
        ["wt", sandpaper_holder_wall_thickness]
    ],
    sandpaper_holder_attached ? [["attached", ""]] : []
);

function sandpaper_holder_outer_width() = sandpaper_holder_width + 2 * sandpaper_holder_wall_thickness;
// The front is open, only the back has a wall.
function sandpaper_holder_outer_depth() = sandpaper_holder_depth + sandpaper_holder_wall_thickness;

// The tongues below the holder reach down to z = 0, the body starts above them.
function sandpaper_holder_bottom() = ff_tongue_depth();
function sandpaper_holder_cavity_bottom() = sandpaper_holder_bottom() + sandpaper_holder_wall_thickness;
function sandpaper_holder_cavity_top() = sandpaper_holder_cavity_bottom() + sandpaper_holder_height;

// Reference top edge of the tongue on the back (like a holder that ends above the compartment),
// the stacking slots sit above it.
function sandpaper_holder_tongue_top() = sandpaper_holder_cavity_top() + sandpaper_holder_wall_thickness;
function sandpaper_holder_top() = sandpaper_holder_tongue_top() + sandpaper_holder_slot_floor + ff_slot_depth();

function sandpaper_holder_slot_positions() =
    let(
        width = sandpaper_holder_outer_width(),
        count = max(1, floor(width / sandpaper_holder_slot_spacing))
    )
    [for (i = [0 : count - 1]) (i + 0.5) * width / count];

// Cut body of the compartment, its front edges are rounded and meet in mitered corners.
module sandpaper_holder_compartment(width, depth, r) {
    wall = sandpaper_holder_wall_thickness;
    z0   = sandpaper_holder_cavity_bottom();
    z1   = sandpaper_holder_cavity_top();

    intersection() {
        translate([0, 0, z0 - r - 1])
            linear_extrude(height = z1 - z0 + 2 * r + 2)
                ff_flared_profile_2d(wall, width - wall, wall, depth, r);

        translate([wall - r - 1, 0, 0])
            ff_extrude_along_x(sandpaper_holder_width + 2 * r + 2)
                mirror([1, -1])
                    ff_flared_profile_2d(z0, z1, wall, depth, r);
    }
}

module feature_sandpaper_holder() {
    width        = sandpaper_holder_outer_width();
    depth        = sandpaper_holder_outer_depth();
    bottom       = sandpaper_holder_bottom();
    top          = sandpaper_holder_top();
    positions    = sandpaper_holder_slot_positions();
    neck_width   = ff_neck_height();
    r            = min(sandpaper_holder_rounding, sandpaper_holder_wall_thickness / 2);
    params       = sandpaper_holder_params();

    assert(sandpaper_holder_depth >= 2 * sandpaper_holder_tongue_front_gap, "sandpaper_holder_depth is too small.");
    assert(sandpaper_holder_wall_thickness >= 1, "sandpaper_holder_wall_thickness must be at least 1 mm.");

    ff_echo_file_name("sandpaper-holder", params);

    // Text on the top face, in the gap between the first two slots (or left of a single slot).
    label_left  = len(positions) > 1 ? positions[0] + neck_width / 2 : 0;
    label_right = len(positions) > 1 ? positions[1] - neck_width / 2 : positions[0] - neck_width / 2;

    difference() {
        union() {
            translate([0, 0, bottom])
                cube([width, depth, top - bottom]);

            if (!sandpaper_holder_attached)
                ff_tongue(width, sandpaper_holder_tongue_top());

            // Stacking tongues below, they slide into the slots of the holder underneath.
            for (x = positions)
                translate([x, 0, bottom])
                    ff_extrude_along_y(0, depth - sandpaper_holder_tongue_front_gap)
                        rotate(90)
                            ff_tongue_2d();
        }

        sandpaper_holder_compartment(width, depth, r);

        // Stacking slots on the top, open at the back, closed at the front.
        for (x = positions)
            translate([x, 0, top])
                ff_extrude_along_y(-1, depth - sandpaper_holder_slot_front_wall)
                    rotate(90)
                        ff_slot_2d();

        ff_engrave_params(
            params,
            [(label_left + label_right) / 2, depth / 2, top],
            "top",
            max_width  = label_right - label_left - 4,
            max_height = depth - 10
        );
    }
}
