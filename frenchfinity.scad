wall_anchor_height = 60;
wall_anchor_length = 100;
wall_anchor_width = 20;
wall_anchor_bottom_angle = 45;

frenchfinity_1_0_slot_inner_height = 8.5;
frenchfinity_1_0_slot_inner_width = 4.5;
frenchfinity_1_0_slot_outer_width = 5.6;
frenchfinity_1_0_slot_outer_height = 6.5;
frenchfinity_1_0_slot_distance_top = 7.394;

filament_hole_size = 1.70;

module basic_wall_anchor() {
    difference() {
        cube([
            wall_anchor_length,
            wall_anchor_width,
            wall_anchor_height
        ]);
        translate([
            0,
            -0.1,
            -wall_anchor_width
        ])
        rotate([
            wall_anchor_bottom_angle, 
            0, 
            0
        ])
        cube([
            wall_anchor_length, 
            wall_anchor_width * 2, 
            wall_anchor_height
        ]);
    }
}

module frenchfinity_1_0_nut() {
    union() {
        cube([
            wall_anchor_length,
            frenchfinity_1_0_slot_outer_width,
            frenchfinity_1_0_slot_outer_height     ,
        ]);       
        translate([
            0,
            frenchfinity_1_0_slot_outer_width,
            (
                frenchfinity_1_0_slot_outer_height -
                frenchfinity_1_0_slot_inner_height 
            ) / 2
        ])
        cube([
            wall_anchor_length,
            frenchfinity_1_0_slot_inner_width,
            frenchfinity_1_0_slot_inner_height     ,
        ]); 
        
        rotate([0, 90, 0])
        translate([
            frenchfinity_1_0_slot_outer_height / -2,
            (
                frenchfinity_1_0_slot_inner_width +
                frenchfinity_1_0_slot_outer_width
            ),
            wall_anchor_length / 2
        ])
        cylinder(d=filament_hole_size, h=wall_anchor_length, center=true, $fn=100);
    }
}

module wall_anchor_with_nut_cutout () {
    difference() {
        basic_wall_anchor();
        translate([
            0,
            0,
            (
                wall_anchor_height -
                frenchfinity_1_0_slot_outer_height -
                frenchfinity_1_0_slot_distance_top
            ),
        ])
        frenchfinity_1_0_nut();

    }
}

wall_anchor_with_nut_cutout();