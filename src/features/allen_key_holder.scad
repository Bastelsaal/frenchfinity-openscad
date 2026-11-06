//
// Allen key holder
//
// Holds one L-shaped allen key (hex key): a square beam reaches forward from the wall and rises by
// `allen_key_holder_angle`. The short leg of the key goes into the hexagonal hole in the front of
// the beam, the long leg hangs down in front of it. The rising beam keeps the key from sliding out.
//
// `allen_key_holder_key_size` is the size of the key across flats, the hole gets
// `allen_key_holder_key_tolerance` added. The hole is `allen_key_holder_head_length` deep (length of
// the short leg). The beam is 2 x `allen_key_holder_padding` + key size wide and high, but at least
// 14 mm. The parameters are engraved into the bottom of the beam.
//

// Minimum width and height of the beam (1.0).
allen_key_holder_min_size = 14;
// Material behind the hole on top of allen_key_holder_padding (1.0 parameter "length_tolerance").
allen_key_holder_length_tolerance = 5;
// Rounding of the hole rim and of the top front edge (1.0).
allen_key_holder_rounding = 2;

function allen_key_holder_params() = [
    ["ks", allen_key_holder_key_size],
    ["a", allen_key_holder_angle],
    ["hl", allen_key_holder_head_length]
];

function allen_key_holder_hole_size() = allen_key_holder_key_size + allen_key_holder_key_tolerance;

// Width and height of the beam (1.0: calculated_width_height).
function allen_key_holder_size() =
    max(allen_key_holder_min_size, 2 * allen_key_holder_padding + allen_key_holder_key_size);

function allen_key_holder_length() =
    allen_key_holder_padding + allen_key_holder_length_tolerance + allen_key_holder_head_length;

// Height of the back face. It reaches at least down to the bottom of the tongue.
function allen_key_holder_back_height() =
    max(allen_key_holder_size() * cos(allen_key_holder_angle), ff_slot_bottom_offset());

// Places children in the frame of the beam: origin at the top edge of the back face, local y along
// the beam (forward and up), local z at a right angle to it (up), local x along x.
module allen_key_holder_beam_frame(top) {
    translate([0, 0, top])
        rotate([allen_key_holder_angle, 0, 0])
            children();
}

// Side view (y, z) of the tilted beam together with the wedge that fills the gap between its back
// and the mounting plane. The top front edge of the beam is rounded.
module allen_key_holder_side_profile_2d(size, length, top) {
    angle       = allen_key_holder_angle;
    along       = [cos(angle), sin(angle)];
    down        = [sin(angle), -cos(angle)];
    front_top   = [0, top] + length * along;
    beam_bottom = [0, top] + size * down;
    corners     = concat(
        [[0, top - allen_key_holder_back_height()], [0, top], front_top, front_top + size * down],
        // Without a tilt the back of the beam lies in the mounting plane.
        angle > 0 ? [beam_bottom] : []
    );

    polygon(round_corners(
        corners,
        radius = [for (i = [0 : len(corners) - 1]) i == 2 ? allen_key_holder_rounding : 0],
        $fn = 24
    ));
}

// Hexagon with `flats` across flats (flats at the top and bottom), extruded along +y from y = 0.
module allen_key_holder_hexagon(flats, height) {
    rotate([-90, 0, 0])
        linear_extrude(height = height)
            circle(d = flats / cos(30), $fn = 6);
}

// Hexagonal hole along +y in the frame of the beam, from `depth` behind the front face (y = length)
// through it. The rim on the front face is rounded.
module allen_key_holder_hole(size, length, depth) {
    hole     = allen_key_holder_hole_size();
    rounding = allen_key_holder_rounding;
    steps    = 6;

    translate([size / 2, 0, -size / 2]) {
        translate([0, length - depth, 0])
            allen_key_holder_hexagon(hole, depth + 1);

        // Rounded rim: hexagons growing towards the front face, hulled in pairs. The stack ends
        // 2 x ff_eps in front of the face, so the cut crosses the face instead of touching it.
        for (i = [0 : steps - 1])
            hull()
                for (step = [i, i + 1])
                    let(
                        inset = rounding * (1 - step / steps),
                        grow  = rounding - sqrt(rounding * rounding - (rounding - inset) * (rounding - inset))
                    )
                        translate([0, length - inset + 2 * ff_eps, 0])
                            allen_key_holder_hexagon(hole + 2 * grow, ff_eps + (step == steps ? 1 : 0));
    }
}

module feature_allen_key_holder() {
    assert(allen_key_holder_key_size > 0, "allen_key_holder_key_size must be larger than 0.");
    assert(
        allen_key_holder_angle >= 0 && allen_key_holder_angle <= 45,
        "allen_key_holder_angle must be between 0 and 45 degrees."
    );
    assert(
        (allen_key_holder_size() - allen_key_holder_hole_size() / cos(30)) / 2 >= 1,
        "allen_key_holder_padding is too small for the key: increase it."
    );

    params = allen_key_holder_params();
    size   = allen_key_holder_size();
    length = allen_key_holder_length();
    top    = allen_key_holder_back_height();

    ff_echo_file_name("allen-key-holder", params);

    ff_holder(size, top)
        difference() {
            ff_profile_extrude(size)
                allen_key_holder_side_profile_2d(size, length, top);

            allen_key_holder_beam_frame(top) {
                allen_key_holder_hole(size, length, allen_key_holder_head_length);

                // Parameters on the bottom of the beam.
                ff_engrave_params(
                    params,
                    [size / 2, length / 2, -size],
                    "bottom",
                    max_width  = size - 3,
                    max_height = length - 4,
                    rotations  = [0, 90]
                );
            }
        }
}
