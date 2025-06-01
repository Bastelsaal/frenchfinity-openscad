include <../lib/BOSL2/std.scad>

//
// Parameters
//
//

/* [Feature] */
feature = "wall_anchor"; //[french_plate, screw_plate, screw_driver, wall_anchor]

/* [Wall anchor] */
wall_anchor_height = 60;
wall_anchor_width = 100;
wall_anchor_depth = 20;
wall_anchor_bottom_angle = 45;
wall_anchor_render_screw_holes = true;
wall_anchor_screw_thread_diameter = 2;
wall_anchor_screw_head_height = 2;
wall_anchor_screw_head_diameter = 4.3;
wall_anchor_screw_distance = 30;

/* [French plate] */
french_plate_width = 100;
french_plate_height = 100;
french_plate_depth = 20;

/* [Screw plate] */
screw_plate_width = 160;
screw_plate_height = 100;
screw_plate_depth = 20;
screw_plate_screw_thread_diameter = 4;
screw_plate_screw_head_diameter = 8;
screw_plate_screw_head_height = 4;
screw_plate_screw_hole_padding = 40;


/* [Screwdriver] */


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
frenchfinity_1_0_slot_total_height_calculated = frenchfinity_1_0_slot_outer_height;
final_version_prefix_calculated= str("v", version, version_prefix);

//
// Base imports
//

include <labels.scad>
include <nuts.scad>
include <screws.scad>

//
// Features
//

include <french_plate.scad>
include <screw_plate.scad>
include <wall_anchor.scad>



screwdriver_bottom_height = 10;
screwdriver_handle_width = 26;
screwdriver_padding_sides = 10;
screwdriver_padding_top = 40;
screwdriver_stick_width = 18;
screwdriver_inset_height = 10;


module screw_driver_positive () {
    module stick () {
        cylinder(
            d=screwdriver_stick_width, 
            h=screwdriver_bottom_height, 
            center=false, 
            $fn=100
        );
    }
    
    module handle () {
         cylinder(
            d=screwdriver_handle_width,
            h=screwdriver_inset_height,
            center=false,
            $fn=100
        );
    }

    union () {
        up(screwdriver_inset_height)
            handle();
        stick();
    }
}   

module screw_driver_clearance() {
    half_handle_width = screwdriver_handle_width / 2;
    half_stick_width  = screwdriver_stick_width / 2;
    polygon_front_end = half_handle_width + screwdriver_padding_sides;

    linear_extrude(height = base_height, center= true)
    polygon(
           [
               [-half_stick_width,  0],
               [half_stick_width,   0],
               [half_handle_width , polygon_front_end],
               [-half_handle_width, polygon_front_end]
           ],
           [[0, 1, 2, 3]]
    );
}

module screw_driver_base (base_height, base_width_and_depth) {
    module raw_base () {        
        up(screwdriver_bottom_height)
            cube(
                [
                    base_width_and_depth,
                    base_width_and_depth,
                    base_height
                ], 
                center=true
            );  
    }


    difference () {
        raw_base(); 
        screw_driver_clearance();
        screw_driver_positive();
    }
}

module screw_driver_holder_without_nut (base_height, base_width_and_depth) {
    module back_plate () {
        up(base_height)
        back(-base_width_and_depth/2)
        yrot(270)
        linear_extrude(height = base_width_and_depth, center= true)
        polygon(
            [
                [0,  0],
                [0,  screwdriver_padding_sides - 2],
                [screwdriver_padding_top,  screwdriver_padding_sides / 2],
                [screwdriver_padding_top ,  0],
            ],
            [[0, 1, 2, 3]]
        );
    }
    
    union () {
        back_plate();
        screw_driver_base(base_height, base_width_and_depth);
    }
}

// TODO: text
// TODo: absand oben
// TODO: rundung

module feature_screw_driver () {
    base_height          = screwdriver_bottom_height + screwdriver_inset_height;
    base_width_and_depth = screwdriver_handle_width + (screwdriver_padding_sides * 2);
    
    
    up(base_height + screwdriver_padding_top - (frenchfinity_1_0_slot_distance_top * 2))
    left(base_width_and_depth/2)
    back(-base_width_and_depth/2)
    mirror([0, 1, 0])
    nut(base_width_and_depth, false);
    
    screw_driver_holder_without_nut(base_height, base_width_and_depth);
}


//
// Selected feature
//

module render_selected_feature () {
    if (feature == "french_plate") feature_french_plate();
    if (feature == "screw_plate")  feature_screw_plate();
    if (feature == "screw_driver") feature_screw_driver();
    if (feature == "wall_anchor")  feature_wall_anchor();
}

render_selected_feature();
