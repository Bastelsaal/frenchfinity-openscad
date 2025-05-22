include <lib/BOSL2/std.scad>

//
// Parameters
//
//

/* [Wall anchor] */
wall_anchor_height = 60;
wall_anchor_width = 100;
wall_anchor_depth = 20;
wall_anchor_bottom_angle = 45;
wall_anchor_render_screw_holes = true;
wall_anchor_screw_thread_width = 2;
wall_anchor_screw_head_height = 2;
wall_anchor_screw_head_width = 4.3;
wall_anchor_screw_distance = 30;

/* [Frenchfinity 1.0 slot] */
frenchfinity_1_0_slot_inner_height = 8.5;
frenchfinity_1_0_slot_inner_width = 4.5;
frenchfinity_1_0_slot_outer_width = 5.6;
frenchfinity_1_0_slot_outer_height = 6.5;
frenchfinity_1_0_slot_distance_top = 7.394;

/* [Miscellaneous] */
filament_hole_size = 1.70;

/* [Text] */
render_text = true;
text_depth = 1;
text_size = 5;


/* [Versioning] */
version = 1;
version_prefix = "scad";

//
// Helper variables (usually end with "_calculated")
//

frenchfinity_1_0_slot_total_width_calculated = frenchfinity_1_0_slot_inner_width + frenchfinity_1_0_slot_outer_width;
final_version_prefix_calculated= str("v", version, version_prefix);

//
// Labels
//


module labelVertical (text, width_box, y) {
    if (render_text) {
        translate([width_box, 0, y])
            xrot(90)
                text3d(text, size=text_size, height=text_depth, anchor=CENTER);
    }
}

//
// Nuts
//

module frenchfinity_1_0_nut() {
    union() {
        cube([
            wall_anchor_width,
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
            wall_anchor_width,
            frenchfinity_1_0_slot_inner_width,
            frenchfinity_1_0_slot_inner_height     ,
        ]); 
        yrot(90)
        translate([
            frenchfinity_1_0_slot_outer_height / -2,
            (
                frenchfinity_1_0_slot_inner_width +
                frenchfinity_1_0_slot_outer_width
            ),
            wall_anchor_width / 2
        ])
        cylinder(d=filament_hole_size, h=wall_anchor_width, center=true, $fn=100);
    }
}

module nut() {
    // TODO: Add support for different nuts
    frenchfinity_1_0_nut();
}

//
// Wall anchor
//

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
            nut();
    }

    difference() {
        wall_anchor_basic();
        local_nut();
    }
}

module wall_anchor_with_nut_cutout_and_text () {
    text_box_width = wall_anchor_width / 2;
    text_y         = wall_anchor_height - 22;
    labels         = [
        final_version_prefix_calculated,
        str("w", wall_anchor_width),
        str("h", wall_anchor_height),
        str("d", wall_anchor_depth)
    ];
    
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
    union() {
        cylinder(d=wall_anchor_screw_thread_width, h=thread_depth, center=false, $fn=100);
        cylinder(h=wall_anchor_screw_head_height, r1=wall_anchor_screw_head_width, r2=wall_anchor_screw_thread_width);
    }
    
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


/// DEV
wall_anchor_with_nut_cutout_and_text_and_holes();