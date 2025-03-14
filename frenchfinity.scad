wall_anchor_height = 60;
wall_anchor_length = 100;
wall_anchor_width = 20;
wall_anchor_bottom_angle = 45;

module basic_wall_anchor() {
    difference() {
        cube([
            wall_anchor_length,
            wall_anchor_width,
            wall_anchor_height
        ]);

        translate([0, -0.1, -wall_anchor_width])
        rotate([wall_anchor_bottom_angle, 0, 0])
        cube([
            wall_anchor_length, 
            wall_anchor_width * 2, 
            wall_anchor_height
        ]);
    }
}

basic_wall_anchor();


