//
// Frenchfinity core: small geometry helpers shared by all parts
//

// `count` positions, `spacing` apart, centered on `center`.
function ff_centered_positions(count, spacing, center) =
    count < 1 ? [] : [for (i = [0 : count - 1]) center + (i - (count - 1) / 2) * spacing];

// `count` positions evenly distributed from `from` to `to` (the middle if count is 1).
function ff_distributed_positions(count, from, to) =
    count < 1 ? [] :
    count == 1 ? [(from + to) / 2] :
    [for (i = [0 : count - 1]) from + i * (to - from) / (count - 1)];

// Number of segments for a circle of `radius` ($fn): the $fa / $fs rule of OpenSCAD, but at least
// `minimum`, so small holes and rods stay round. With minimum = 5 it is the number OpenSCAD uses.
function ff_fn(radius, minimum = 24) = max(minimum, ceil(min(360 / $fa, 2 * PI * radius / $fs)));

// Countersunk screw hole along the z axis: the screw head sinks into a surface at z = 0, the shaft
// reaches down to z = -length. `clearance` mm above the surface are cleared as well, so the hole
// also cuts through material that sits in front of the surface.
module ff_countersunk_hole(diameter, head_diameter, head_height, length, clearance = 1) {
    union() {
        translate([0, 0, -length - ff_eps])
            cylinder(d = diameter, h = length + 2 * ff_eps);

        translate([0, 0, -head_height])
            cylinder(d1 = diameter, d2 = head_diameter, h = head_height + ff_eps);

        cylinder(d = head_diameter, h = clearance);
    }
}

// Extrudes a 2D profile drawn in the (y, z) plane along the x axis from x = 0 to x = length.
// Same as ff_extrude_along_x, named for readability in part files.
module ff_profile_extrude(length) {
    ff_extrude_along_x(length)
        children();
}

// Extrudes a 2D profile drawn in the (x, z) plane along the y axis from y = from to y = to.
module ff_extrude_along_y(from, to) {
    translate([0, to, 0])
        rotate([90, 0, 0])
            linear_extrude(height = to - from)
                children();
}

// Two triangles of the quad `face`. It is split along the diagonal that has the other two corners on
// opposite sides, so the triangles do not fold over even if the quad is not convex.
function ff_split_quad(verts, face) =
    let(
        a = verts[face[0]],
        b = verts[face[1]],
        c = verts[face[2]],
        d = verts[face[3]]
    )
    cross(c - a, b - a) * cross(c - a, d - a) < 0
        ? [[face[0], face[1], face[2]], [face[0], face[2], face[3]]]
        : [[face[1], face[2], face[3]], [face[1], face[3], face[0]]];

// Splits all faces of a VNF into triangles, like BOSL2 vnf_triangulate(), but splits quads directly,
// which is much faster.
function ff_triangulate(vnf) =
    let(verts = vnf[0])
    [
        verts,
        [
            for (face = vnf[1])
                each (
                    len(face) == 3 ? [face] :
                    len(face) == 4 ? ff_split_quad(verts, face) :
                    polygon_triangulate(verts, face)
                )
        ]
    ];

// BOSL2 offset_sweep() (with its default anchor: the bottom at z = 0), built from triangles. The
// faces between two rounding steps are often not planar, and after a rotation not even the caps are
// exactly planar any more. OpenSCAD 2021.01 (CGAL) cannot always handle that ("PolySet has nonplanar
// faces", CGAL assertions, broken meshes). Regions with several parts are swept part by part, like
// BOSL2 does.
module ff_offset_sweep(path, height, bottom = [], top = [], steps = 16, extra = 0, convexity = 10) {
    parts = is_region(path) ? region_parts(path) : [[path]];

    for (part = parts) {
        assert(len(part) == 1, "ff_offset_sweep() does not support regions with holes.");

        vnf = ff_triangulate(
            offset_sweep(part[0], height = height, bottom = bottom, top = top, steps = steps, extra = extra)
        );

        polyhedron(vnf[0], vnf[1], convexity = convexity);
    }
}

// 2D fillet: the material that rounds an inside corner with radius r. `corner` is the corner point,
// `direction` ([1, 1], [-1, 1], ...) points into the free quadrant. Subtracted from a part it rounds
// an outside corner instead, `direction` then points into the material.
module ff_fillet_2d(corner, direction, r) {
    translate(corner)
        scale(direction)
            difference() {
                translate([-ff_eps, -ff_eps])
                    square([r + ff_eps, r + ff_eps]);

                translate([r, r])
                    circle(r = r, $fs = min($fs, r / 4));
            }
}

// 2D profile (u, v) of a pocket from u0 to u1, from v_bottom up to v_top and 1 mm beyond, whose
// edges at v_top flare out with radius r. As a cut it rounds the rim of the pocket.
module ff_flared_profile_2d(u0, u1, v_bottom, v_top, r) {
    translate([u0, v_bottom])
        square([u1 - u0, v_top - v_bottom + 1]);

    ff_fillet_2d([u0, v_top], [-1, -1], r);
    ff_fillet_2d([u1, v_top], [1, -1], r);

    translate([u0 - r, v_top])
        square([u1 - u0 + 2 * r, 1]);
}

// Cut body of a rectangular pocket from x0 to x0 + width, y0 to y0 + depth and z_bottom up through
// z_top, its rim rounded with radius r. Like the Fusion 360 fillets of Frenchfinity 1.0, the
// roundings meet in mitered corners: the cut is the intersection of a profile along x and one along y.
module ff_rounded_pocket(x0, y0, width, depth, z_bottom, z_top, r) {
    intersection() {
        ff_extrude_along_y(y0 - r - 1, y0 + depth + r + 1)
            ff_flared_profile_2d(x0, x0 + width, z_bottom, z_top, r);

        translate([x0 - r - 1, 0, 0])
            ff_extrude_along_x(width + 2 * r + 2)
                ff_flared_profile_2d(y0, y0 + depth, z_bottom, z_top, r);
    }
}

// Adds the tongue to a holder. children() is the holder body with its back face in the mounting
// plane and its top edge at z = top. The tongue runs from x = 0 to x = width.
module ff_holder(width, top) {
    union() {
        children();
        ff_tongue(width, top);
    }
}
