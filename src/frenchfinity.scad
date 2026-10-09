include <../lib/BOSL2/std.scad>

//
// Parameters
//
//

/* [Feature] */
feature = "tray"; //[box, french_plate, grid, screw_plate, screw_driver, wall_anchor, bin, tray]

/* [Wall anchor] */
wall_anchor_height                = 60;
wall_anchor_width                 = 100;
wall_anchor_depth                 = 20;
wall_anchor_bottom_angle          = 45;
wall_anchor_render_screw_holes    = true;
wall_anchor_screw_thread_diameter = 2;
wall_anchor_screw_head_height     = 2;
wall_anchor_screw_head_diameter   = 4.3;
wall_anchor_screw_distance        = 30;

/* [French plate] */
french_plate_width                = 100;
french_plate_height               = 100;
french_plate_depth                = 20;
french_plate_front_channel_count  = 3; // [0:10]
french_plate_back_connector_count = 1; // [0:10]
french_plate_slot_spacing         = 30;

/* [Screw plate] */
screw_plate_width                 = 160;
screw_plate_height                = 100;
screw_plate_depth                 = 20;
screw_plate_screw_thread_diameter = 4;
screw_plate_screw_head_diameter   = 8;
screw_plate_screw_head_height     = 4;
screw_plate_screw_hole_padding    = 40;

/* [Screwdriver] */
screwdriver_bottom_height = 10;
screwdriver_handle_width  = 26;
screwdriver_padding_sides = 10;
screwdriver_padding_top   = 40;
screwdriver_stick_width   = 18;
screwdriver_inset_height  = 10;

/* [Box] */
box_width          = 50;
box_depth          = 30;
box_height         = 60;
box_wall_thickness = 2;

/* [ Bin] */
bin_width      = 60;
bin_depth      = 80;
bin_height     = 50;
bin_wall       = 2.5;
lip_height     = 30; // How high the front wall is

/* [Grid] */
grid_width = 200;
grid_depth = 50;
grid_height = 60;
grid_wall_thickness = 2;
grid_rows = 4;
grid_columns = 4;

/* [Simple Tray] */
tray_width           = 150; // [50:400]
tray_depth           = 60;  // [30:200]
tray_height          = 30;  // [15:100]
tray_wall_thickness  = 2;   // [1.2:0.4:5]
tray_corner_radius   = 5;   // [1:20]

/* [Frenchfinity 1.0 slot] */
frenchfinity_1_0_slot_inner_height     = 8.5;
frenchfinity_1_0_slot_inner_width      = 4.5;
// You may have to set this to 6.6 or 6.5 to generate wall anchors compatible to legacy frenchfinity parts
frenchfinity_1_0_slot_outer_width      = 5.6;
frenchfinity_1_0_slot_outer_height     = 6.5;
frenchfinity_1_0_slot_distance_top     = 7.394;

/* [Tolerances] */
// Amount to shrink the connector to make it slide easily (in mm).
// 0.2 is standard. If too tight, try 0.25 or 0.3.
connector_tolerance = 0.2; // [0:0.05:0.5]

/* [Miscellaneous] */
filament_hole_size = 1.70;

/* [Text] */
render_text = true;
text_depth  = 1;
text_size   = 5;


/* [Versioning] */
version        = 1;
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
include <rounded_corners.scad>
include <screws.scad>

//
// Features
//

include <box.scad>
include <french_plate.scad>
include <grid.scad>
include <screw_driver.scad>
include <screw_plate.scad>
include <wall_anchor.scad>
include <bin.scad>
include <tray.scad>











//
// Selected feature
//

module render_selected_feature () {
    if (feature == "box")          feature_box();
    if (feature == "french_plate") feature_french_plate();
    if (feature == "grid")         feature_grid();
    if (feature == "screw_plate")  feature_screw_plate();
    if (feature == "screw_driver") feature_screw_driver();
    if (feature == "wall_anchor")  feature_wall_anchor();
    if (feature == "bin")    feature_bin();
    if (feature == "tray")          feature_tray();
   
}

render_selected_feature();

