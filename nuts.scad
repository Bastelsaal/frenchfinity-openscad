module frenchfinity_1_0_nut(width, include_filament_hole) {
    module filament_hole () {
        yrot(90)
        translate([
            frenchfinity_1_0_slot_outer_height / -2,
            (
                frenchfinity_1_0_slot_inner_width +
                frenchfinity_1_0_slot_outer_width
            ),
            width / 2
        ])
        cylinder(d=filament_hole_size, h=width, center=true, $fn=100);
    }
    
    module basic_nut () {
        cube([
            width,
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
            width,
            frenchfinity_1_0_slot_inner_width,
            frenchfinity_1_0_slot_inner_height     ,
        ]);
    }

    if (include_filament_hole) {
        union() {
            basic_nut();
            filament_hole();
        }
    } else {
        difference() {
            basic_nut();
            filament_hole();
        }
    }
}

module nut(width, include_filament_hole) {
    // TODO: Add support for different nuts
    frenchfinity_1_0_nut(width, include_filament_hole);
}