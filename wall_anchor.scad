module wall_anchor_basic() {
    module angle_bottom () {
        radius = 1;
   
        back(1)
            yrot(90)                
                minkowski() {
                    linear_extrude(height = wall_anchor_width)
                        right_triangle([
                            wall_anchor_depth - (radius * 2),
                            wall_anchor_depth - (radius * 2)
                        ]);
                    cylinder(h=0.01, r=radius, $fn=100); 
                }
    }
    up(wall_anchor_depth)
    union() {
        cube([
            wall_anchor_width,
            wall_anchor_depth,
            wall_anchor_height - wall_anchor_depth
        ]);
        angle_bottom();    
    }  
}


module wall_anchor_with_nut_cutout () {
    module local_nut() {
        translate([
            0,
            0,
            (
                wall_anchor_height -
                frenchfinity_1_0_slot_outer_height -
                frenchfinity_1_0_slot_distance_top
            ),
        ])
        mirror([0, 1, 0])
        translate([0, -wall_anchor_depth, 0])
            nut(wall_anchor_width, true);
    }

    difference() {
        wall_anchor_basic();
        local_nut();
    }
}

module wall_anchor_with_nut_cutout_and_text () {
    text_box_width = wall_anchor_width / 2;
    text_y         = wall_anchor_height - 22;
    labels         = hintFileName([
        final_version_prefix_calculated,
        str("w", wall_anchor_width),
        str("h", wall_anchor_height),
        str("d", wall_anchor_depth)
    ]);
    
    difference() {
        wall_anchor_with_nut_cutout();
        
        for (i = [0 : len(labels)-1])
            labelVertical(
                labels[i], 
                text_box_width, 
                text_y - i * 7
            );
    }
}

module wall_anchor_screw_hole (x) {
    thread_depth = wall_anchor_depth - frenchfinity_1_0_slot_total_width_calculated + 2;
    
    left(x)
    up(wall_anchor_height - frenchfinity_1_0_slot_distance_top - (frenchfinity_1_0_slot_outer_height / 2))
    left(wall_anchor_width / -2)
    back(thread_depth -1)
    xrot(90)
    
    screw (
        wall_anchor_screw_thread_diameter, 
        thread_depth, 
        wall_anchor_screw_head_height, 
        wall_anchor_screw_thread_diameter
    );
}

module wall_anchor_with_nut_cutout_and_text_and_holes () {
    if (wall_anchor_render_screw_holes) {
        screw_holes = floor(wall_anchor_width / wall_anchor_screw_distance);

        difference() {
            wall_anchor_with_nut_cutout_and_text();
            wall_anchor_screw_hole(0);
            for (i = [0 : screw_holes-1]) {
                wall_anchor_screw_hole(wall_anchor_screw_distance * i);
                wall_anchor_screw_hole(wall_anchor_screw_distance * -i);
            }
        }
    } else {
        wall_anchor_with_nut_cutout_and_text();
    }
}

module feature_wall_anchor () {
    wall_anchor_with_nut_cutout_and_text_and_holes();
}