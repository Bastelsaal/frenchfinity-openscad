//
// Frenchfinity 2.0 - the customizable French cleat subsystem
//
// https://frenchfinity.xyz
// https://github.com/Bastelsaal/frenchfinity-openscad
//
// Pick a part in the "Part" section and adjust the section of that part. Every part uses the same
// slot profile, so the holders fit the wall anchors and plates of this generator, the Frenchfinity
// 1.0 parts made with Fusion 360 and wooden parts milled with the M5 T-slot router bit.
//
// Licensed under CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
//

include <../lib/BOSL2/std.scad>

/* [Part] */
// The part to generate. Wall anchors and plates carry a slot, holders carry the matching tongue.
feature = "wall_anchor"; // [wall_anchor:Wall anchor, french_plate:French plate, screw_plate:Screw plate, ikea_skadis_plate:IKEA Skadis plate, welding_table_plate:Welding table plate, nussbaum_sl_smart_lift_plate:Nussbaum SL smart lift plate, custom_base_adapter:Custom base adapter, angle_adapter:Angle adapter, allen_key_holder:Allen key holder, bin:Bin, bit_holder:Bit holder, box:Box, caliper_holder:Caliper holder, can_holder:Can holder, crowbar_holder:Crowbar holder, einhell_battery_holder:Einhell battery holder, einhell_single_charger_holder:Einhell single charger holder, file_holder:File holder, glubot_holder:GluBot holder, grid:Grid holder, gridfinity_adapter:Gridfinity adapter, hammer_holder:Hammer holder, hook:Hook, lifting_clamp_holder:Lifting clamp holder, locksmith_corner_holder:Locksmith corner holder, meter_stick_holder:Meter stick holder, pliers_holder:Pliers holder, rectangular_tool_holder:Rectangular tool holder, ring_wrench_holder:Ring wrench holder, round_hanging_holder:Round hanging holder, sandpaper_holder:Sandpaper holder, screw_driver:Screwdriver holder, small_hole_holder:Small hole holder, t_handle_holder:T-handle holder, tablet_holder:Tablet holder, tape_holder:Tape holder, toilet_paper_holder:Toilet paper holder, tray:Tray, triangle_top_holder:Triangle top holder, wolfcraft_accumobil_drilling_aid_holder:Wolfcraft Accumobil drilling aid holder, wolfcraft_corner_clamp_es22_holder:Wolfcraft corner clamp ES22 holder, wrench_holder:Wrench holder, guide:Guide, tongue_cleaner:Tongue cleaner, letter:Letter]

/* [Slot profile] */
// "frenchfinity" fits Frenchfinity 1.0 parts and wooden parts milled with the M5 T-slot router bit. "openscad_v1_legacy" fits parts printed with version 1 of this generator.
slot_profile = "frenchfinity"; // [frenchfinity, openscad_v1_legacy, custom]
// Clearance removed from every side of a tongue so it slides into a slot.
print_tolerance = 0.12; // [0:0.01:0.5]
// Adds a channel for a piece of 1.75 mm filament that removes any play between tongue and slot.
filament_hole = true;
// Diameter of the filament channel (1.7 for 1.75 mm filament).
filament_hole_diameter = 1.7; // [1:0.05:2.5]
// Only used with slot_profile = custom: height of the slot opening.
slot_custom_neck_height = 5.6;
// Only used with slot_profile = custom: depth of the slot opening.
slot_custom_neck_depth = 6.5;
// Only used with slot_profile = custom: height of the wide part of the slot.
slot_custom_head_height = 8.5;
// Only used with slot_profile = custom: depth of the wide part of the slot.
slot_custom_head_depth = 4.5;
// Only used with slot_profile = custom: distance from the top edge of a part to the center of its slot.
slot_custom_center_from_top = 10.194;

/* [Labels] */
// Engrave the version and the parameters into the part, like Frenchfinity 1.0 does.
render_text = true;
// Maximum text size, labels shrink to fit on small parts.
text_size = 5; // [2:0.5:10]
// Depth of the engraving.
text_depth = 0.6; // [0.2:0.1:2]
// Font of the labels, "Liberation Sans" ships with OpenSCAD. Labels are sized for its metrics (same as Arial), wider fonts may overflow.
text_font = "Liberation Sans:style=Bold";
// Version written into labels and file names, together with the prefix (v2scad).
version = 2;
version_prefix = "scad";

/* [Quality] */
// Smallest facet size of curves in mm, smaller values render slower.
curve_resolution = 0.5; // [0.1:0.05:2]

/* [Wall anchor] */
// Width of the anchor along the wall.
wall_anchor_width = 100; // [20:1:500]
// Height of the back face. The front face is shorter by wall_anchor_depth * tan(wall_anchor_bottom_angle).
wall_anchor_height = 40.4; // [30:0.1:200]
// Thickness of the anchor, should match the thickness of the wall cleats.
wall_anchor_depth = 20; // [15:0.5:40]
// Angle of the bevel that hooks onto the wall cleats.
wall_anchor_bottom_angle = 45; // [30:1:60]
// Radius of the rounded lower edge of the bevel (where the anchor touches the wall).
wall_anchor_bevel_rounding = 1.5; // [0:0.1:5]
// Countersunk holes to screw the anchor to the wall, reachable through the slot.
wall_anchor_render_screw_holes = true;
// One screw hole per this many mm of width.
wall_anchor_screw_distance = 40; // [20:1:200]
// Diameter of the screws (the print tolerance is added).
wall_anchor_screw_thread_diameter = 2; // [1:0.1:5]
// Diameter of the screw heads (the print tolerance is added).
wall_anchor_screw_head_diameter = 4.3; // [2:0.1:9]
// Height of the countersunk screw heads.
wall_anchor_screw_head_height = 2; // [0.5:0.1:5]

/* [French plate] */
// Width of the plate along the wall.
french_plate_width = 100; // [20:1:500]
// Height of the plate, the slot and the tongue run along its top edge (Frenchfinity 1.0 "ph80" = 100).
french_plate_height = 100; // [20:1:500]
// Thickness of the plate without the tongue.
french_plate_depth = 16; // [13:0.5:40]
// Number of slots on the front, one below the other, to hang holders at several heights.
french_plate_front_slot_count = 1; // [0:1:10]
// Number of tongues on the back, one below the other.
french_plate_back_tongue_count = 1; // [0:1:10]
// Distance between the slots (and between the tongues) when there are several.
french_plate_slot_spacing = 30; // [10:0.5:200]

/* [Screw plate] */
// Width of the plate along the wall.
screw_plate_width = 170; // [20:1:500]
// Height of the plate, the slot runs along its top edge.
screw_plate_height = 100; // [30:1:500]
// Thickness of the plate.
screw_plate_depth = 16; // [13:0.5:40]
// Diameter of the screws (the print tolerance is added).
screw_plate_screw_thread_diameter = 4; // [2:0.1:8]
// Diameter of the screw heads (the print tolerance is added).
screw_plate_screw_head_diameter = 8; // [4:0.1:16]
// Height of the countersunk screw heads.
screw_plate_screw_head_height = 4; // [1:0.1:8]
// Horizontal distance between the screw holes, also the maximum vertical distance.
screw_plate_screw_distance = 50; // [20:1:200]
// Minimum distance from a screw hole to the side and bottom edges of the plate.
screw_plate_screw_edge_distance = 12.5; // [5:0.5:50]

/* [IKEA Skadis plate] */
// Width of the plate, one hook per 40 mm (the hole pattern of the pegboard).
ikea_skadis_plate_width = 150; // [40:1:500]
// Height of the plate, the slot runs along its top edge.
ikea_skadis_plate_height = 100; // [30:1:500]
// Thickness of the plate without the hooks.
ikea_skadis_plate_depth = 16; // [13:0.5:40]

/* [Welding table plate] */
// Width of the plate, the pins are spread over it in the grid of the table.
welding_table_plate_width = 100; // [30:1:500]
// Height of the plate, the slot runs along its top edge.
welding_table_plate_height = 100; // [30:1:500]
// Thickness of the plate without the pins.
welding_table_plate_depth = 20; // [13:0.5:40]
// Diameter of the holes in the welding table (D16 or D28 system).
welding_table_hole_diameter = 28; // [16, 28]
// Grid of the holes in the welding table.
welding_table_hole_distance = 100; // [50, 100]
// Length of the pins that go into the holes of the table.
welding_table_pin_length = 50; // [5:1:100]
// The pins are this much thinner than the holes.
welding_table_pin_clearance = 0.3; // [0:0.05:1]

/* [Nussbaum SL Smart Lift plate] */
// Width of the plate. The screw holes and the rim stay at the edge where x = 0.
nussbaum_sl_smart_lift_plate_width = 200; // [80:1:500]
// Height of the plate, the slot runs along its top edge. The screw holes and the rim stay at the bottom edge.
nussbaum_sl_smart_lift_plate_height = 190; // [185:1:500]
// Thickness of the plate without the locating rim on its back.
nussbaum_sl_smart_lift_plate_depth = 20; // [13:0.5:40]
// Diameter of the four screw holes (Fusion: durchmesser_loch).
nussbaum_sl_smart_lift_plate_hole_diameter = 6; // [2:0.1:9]
// Distance of the screw holes from the outer edges of the hole pattern of the lift column (Fusion: lochabstand_von_aussen).
nussbaum_sl_smart_lift_plate_hole_distance_from_outside = 11; // [5:0.1:15]

/* [Custom base adapter] */
// Length of the adapter along the slot.
custom_base_adapter_width = 40; // [10:1:500]

/* [Angle adapter] */
// Angle in degrees by which the holders on the extension wall are turned compared to holders on the wall. 90 = they face to the left, parallel to the wall.
angle_adapter_angle = 90; // [30:1:150]
// Width of the back plate along the wall, the extension wall stands at its right edge.
angle_adapter_width = 50; // [16:1:300]
// Length of the extension wall, measured from the front face of the back plate.
angle_adapter_extension_width = 120; // [10:1:300]
// Height of the back plate and the extension wall.
angle_adapter_height = 80; // [17:1:300]
// Thickness of the back plate and of the extension wall behind its slot.
angle_adapter_wall_thickness = 5; // [2:0.5:20]

/* [Allen key holder] */
// Size of the allen key across flats (the wrench size), the hole gets allen_key_holder_key_tolerance added.
allen_key_holder_key_size = 1.5; // [0.7:0.1:30]
// Added to the key size so the key slides in easily.
allen_key_holder_key_tolerance = 1; // [0:0.1:3]
// Length of the short leg of the key, the depth of the hole.
allen_key_holder_head_length = 10; // [3:0.5:100]
// The beam rises by this angle in degrees, so the key cannot slide out.
allen_key_holder_angle = 10; // [0:1:45]
// Material around the hole: the beam is 2 x padding + key size wide and high (at least 14 mm).
allen_key_holder_padding = 5; // [2:0.5:20]

/* [Bin] */
// Outer width of the bin (along the wall).
bin_width = 60; // [20:1:300]
// Outer depth of the bin (from the wall to the front).
bin_depth = 80; // [20:1:300]
// Outer height of the bin at the back wall.
bin_height = 50; // [17:1:300]
// Height of the front wall. The side walls slope down to it, so the parts are easy to reach.
bin_lip_height = 30; // [1:1:300]
// Thickness of the walls and the floor.
bin_wall_thickness = 2.5; // [1:0.1:10]

/* [Bit holder] */
// Number of rows of holes (from back to front).
bit_holder_rows = 7; // [1:1:20]
// Number of columns of holes (from left to right).
bit_holder_columns = 5; // [1:1:20]
// Diameter of the bit shank, the hole gets bit_holder_hole_tolerance added (7.2 for 1/4" hex bits).
bit_holder_hole_diameter = 7.2; // [0.5:0.1:60]
// Added to the hole diameter so the bits slide in easily.
bit_holder_hole_tolerance = 0.5; // [0:0.05:2]
// Material between the holes and around the outer holes.
bit_holder_hole_padding = 5; // [2:0.5:40]
// Slope of the top face in degrees, the holes are drilled at a right angle into it.
bit_holder_angle = 30; // [0:1:60]
// Size of the block: the holes are this minus 5 mm deep, the back and front faces this plus 5 mm tall.
bit_holder_height = 18; // [10:1:80]

/* [Box] */
// Inner width of the box (along the wall): the width of the tool plus some clearance.
box_width = 12; // [1:0.1:300]
// Inner depth of the box (from the wall to the front): the depth of the tool plus some clearance.
box_depth = 22; // [1:0.1:300]
// Inner height of the box: how deep the tool sinks into it.
box_height = 50; // [1:0.1:300]
// Thickness of the walls and the floor.
box_wall_thickness = 5; // [1:0.1:20]

/* [Caliper holder] */
// Inner depth of the jaw pockets, the thickness of the caliper jaws.
caliper_holder_thickness = 8.5; // [3:0.1:30]
// Free space between the two pockets for the head and the slider of the caliper.
caliper_holder_head_width = 43; // [20:0.5:120]
// Width of the left pocket that holds the short inside jaws.
caliper_holder_inner_jaw_length = 13; // [5:0.5:40]
// Slope of the left pocket floor in degrees, follows the edge of the inside jaws.
caliper_holder_inner_jaw_angle = 31.61; // [0:0.01:60]
// Width of the right pocket that holds the long outside jaws.
caliper_holder_outer_jaw_length = 30; // [5:0.5:80]
// Slope of the right pocket floor in degrees, follows the edge of the outside jaws.
caliper_holder_outer_jaw_angle = 21.8; // [0:0.01:45]

/* [Can holder] */
// Diameter of the can, the pocket gets can_holder_can_padding added.
can_holder_can_diameter = 23; // [3:0.5:150]
// Added to the can diameter so the can slides in easily.
can_holder_can_padding = 2; // [0:0.1:5]
// Depth of the pocket, measured along the pocket from the sloped top.
can_holder_can_inset = 80; // [20:1:250]
// Material around the pocket and below it.
can_holder_padding = 8; // [2:0.5:30]
// Length of the flat top between the back face and the sloped top (makes room for the tilted pocket).
can_holder_padding_left = 22; // [0:0.5:100]
// Forward tilt of the pocket in degrees.
can_holder_angle = 20; // [0:1:60]
// Adds a window at the bottom of the front wall, so dirt and drops fall out of the pocket.
can_holder_hole_bottom = false;

/* [Crowbar holder] */
// Width of the groove for the crowbar shaft on the back of the front wall.
crowbar_holder_shaft_width = 18.54; // [10:0.01:40]
// Depth of the groove for the crowbar shaft, its flanks keep the 1.0 angle.
crowbar_holder_shaft_depth = 6.73; // [2:0.01:11]

/* [Einhell battery holder] */
// Tilt of the battery plate in degrees, it rises towards the front by this angle + 2 degrees (like Frenchfinity 1.0).
einhell_battery_holder_angle = 20; // [0:1:45]

/* [Einhell single charger holder] */
// Diameter of the pin heads that go through the keyholes of the charger.
einhell_single_charger_holder_mount_screw_width = 5.6; // [4.5:0.1:15]
// Diameter of the pin necks that slide into the narrow part of the keyholes.
einhell_single_charger_holder_mount_screw_stick_width = 4.3; // [1:0.1:5.5]
// Length of the pin necks: the wall thickness of the charger housing at the keyholes.
einhell_single_charger_holder_margin_to_chassis_outside = 3.6; // [1:0.1:15]
// Length of the pin heads.
einhell_single_charger_holder_screw_thicker_width = 3.4; // [1:0.1:15]
// Plate margin above the upper pins and below the lower pin.
einhell_single_charger_holder_screw_padding_horizontal = 20; // [5:0.5:100]
// Plate margin left of the left pin and right of the right pin.
einhell_single_charger_holder_screw_padding_vertical = 50; // [10:0.5:200]

/* [File holder] */
// Diameter of the file handle where it rests in the holder, the pocket is 2 mm wider.
file_holder_handle_width = 22.5; // [5:0.1:100]
// Half the width of the slot for the blade: the slot is 2 x this wide (Frenchfinity 1.0 measures it from the center line).
file_holder_file_width = 7.2; // [0.5:0.1:50]
// Depth of the pocket the handle rests in.
file_holder_handle_inset = 12; // [2:0.5:100]
// Thickness of the floor below the pocket.
file_holder_height = 10; // [2:0.5:100]
// Material around the pocket, the holder is file_holder_handle_width + 2 x this wide and deep.
file_holder_padding = 10; // [3:0.5:50]

/* [Glubot holder] */
// Depth of the pocket for the foot of the bottle, measured perpendicular to its tilted floor.
glubot_holder_height = 14; // [3:0.5:60]
// Clearance between the foot of the bottle and the pocket walls (the pocket of Frenchfinity 1.0 has 5).
glubot_holder_padding = 5; // [2:0.1:12]
// Thickness of the pocket walls and of the pocket floor.
glubot_holder_wall_thickness = 3; // [1:0.1:10]

/* [Grid] */
// Outer width of the grid (along the wall).
grid_width = 26; // [5:0.1:300]
// Outer depth of the grid (from the wall to the front).
grid_depth = 50; // [5:0.1:300]
// Depth of the cells.
grid_height = 20; // [1:0.1:200]
// Number of cells from the wall to the front.
grid_rows = 3; // [1:1:50]
// Number of cells along the wall.
grid_columns = 9; // [1:1:50]
// Thickness of the outer walls and the floor.
grid_wall_thickness = 2; // [0.8:0.1:10]
// Thickness of the walls between the cells.
grid_inner_wall_thickness = 1; // [0.4:0.1:10]
// Place the inner walls exactly like Frenchfinity 1.0 (its outer cells are slightly larger) instead of making all cells the same size.
grid_legacy_layout = false;

/* [Gridfinity adapter] */
// Number of Gridfinity units from the wall to the front (42 mm each).
gridfinity_adapter_grid_rows = 3; // [1:1:10]
// Number of Gridfinity units along the wall (42 mm each).
gridfinity_adapter_grid_columns = 5; // [1:1:12]
// Angle in degrees by which the plate is tilted towards the front. Frenchfinity 1.0 parts named "a10" are tilted by 20 degrees.
gridfinity_adapter_angle = 20; // [0:1:60]

/* [Hammer holder] */
// Width of the holder along the wall.
hammer_holder_width = 60; // [20:1:300]
// Width of the hammer head (front to back) where it rests on the holder.
hammer_holder_hammer_width = 26; // [5:0.5:150]
// Width of the U shaped gap the handle hangs through.
hammer_holder_handle_hole_width = 28; // [5:0.5:150]
// Height of the lip at the front that keeps the head from sliding off.
hammer_holder_drop_protection_height = 5; // [0:0.5:50]
// Thickness of the lip at the front.
hammer_holder_drop_protection_width = 3; // [1:0.5:20]
// Extra room in front of and behind the hammer head.
hammer_holder_hammer_padding = 2; // [0:0.5:20]
// Depth of the crater in the resting area that keeps the head centered, 0 for a flat area.
hammer_holder_crater_depth = 1.5; // [0:0.1:10]
// Total height of the holder.
hammer_holder_height = 50; // [20:1:200]
// Height of the bottom plate the head rests on.
hammer_holder_bottom_height = 15; // [3:0.5:100]
// Thickness of the back plate where it meets the bottom plate.
hammer_holder_back_thickness = 10; // [2:0.5:50]
// Thickness of the back plate at its top edge.
hammer_holder_back_angle_width_top = 4; // [2:0.5:50]

/* [Hook] */
// Width of the hook along the wall.
hook_width = 20; // [6:1:200]
// Total height from the top edge down to the bottom of the bend.
hook_height = 88; // [35:1:400]
// Outer diameter of the bend, the hook reaches this far from the wall. The opening is this minus 2 x hook_thickness.
hook_hook_diameter = 36; // [12:1:200]
// Thickness of the back plate, the bend and the free end.
hook_thickness = 6; // [3:0.5:20]
// Height of the free end above the center of the bend, including its round tip.
hook_hook_end_height = 10; // [2:0.5:200]

/* [Lifting clamp holder] */
// Width of the foot plate of the lifting clamp (along the wall).
lifting_clamp_holder_foot_width = 64; // [10:0.5:200]
// Thickness of the foot plate.
lifting_clamp_holder_foot_height = 4; // [1:0.1:30]
// Length of the foot plate (from the wall to the front).
lifting_clamp_holder_foot_length = 84; // [10:0.5:300]
// The holder points this many degrees upwards, so the clamp does not slide out by itself.
lifting_clamp_holder_angle = 2; // [0:0.5:20]
// Clearance between the foot plate and the pocket on every side.
lifting_clamp_holder_tolerance = 1; // [0:0.1:5]
// Width of the opening in the bottom for the body of the clamp, smaller than the foot so the foot rests on both sides of it.
lifting_clamp_holder_opening_width = 47; // [5:0.5:200]

/* [Locksmith corner holder] */
// Thickness of the blade of the square, the groove gets 2 x locksmith_corner_holder_tolerance more.
locksmith_corner_holder_angle_stick_width = 5; // [1:0.1:30]
// Thickness of the stock (the thick leg) of the square, the arm is this + 2 x side padding wide.
locksmith_corner_holder_angle_foot_width = 20; // [5:0.5:100]
// Length of the support for the blade, the arm is this + 2 x side padding + 15 mm long.
locksmith_corner_holder_holder_width = 70; // [10:1:300]
// Width of the blade (how deep it sinks into the groove), also half the height of the back plate.
locksmith_corner_holder_angle_stick_height = 20; // [3:0.5:100]
// Angle in degrees by which the arm rises towards the front.
locksmith_corner_holder_angle = 40; // [0:1:75]
// Clearance on each side of the blade in the groove.
locksmith_corner_holder_tolerance = 0.5; // [0:0.1:3]
// Material on each side of the stock, added to the width and the length of the arm.
locksmith_corner_holder_side_padding = 5; // [1:0.5:30]
// Thickness of the back plate and of the floor below the groove.
locksmith_corner_holder_wall_thickness = 5; // [2:0.5:20]

/* [Meter stick holder] */
// Number of folded meter sticks that lie on top of each other.
meter_stick_holder_meter_slots = 7; // [1:1:30]
// Length of a folded meter stick (Frenchfinity 1.0 used cm here, 24.5 cm = 245 mm).
meter_stick_holder_meter_length = 245; // [50:0.5:500]
// Width of a folded meter stick (from the wall to the front).
meter_stick_holder_meter_height = 35; // [5:0.5:150]
// Thickness of a folded meter stick.
meter_stick_holder_meter_width = 16; // [2:0.1:60]
// Clearance on every side of the meter sticks.
meter_stick_holder_meter_tolerance = 3; // [0:0.1:10]
// Thickness of the walls and the floor.
meter_stick_holder_wall_thickness = 5; // [1:0.1:20]
// Diameter of the finger hole in the front wall and the floor, 0 for none.
meter_stick_holder_finger_hole_diameter = 80; // [0:1:300]

/* [Pliers holder] */
// Height from the bottom of the holder to the top of the tongue (Frenchfinity 1.0), the part itself is about 6 mm taller.
pliers_holder_height = 60; // [30:1:300]
// Width of the slot shaped hole for one handle of the pliers.
pliers_holder_hole_diameter = 14; // [5:0.5:60]
// Depth of the holder without the arms.
pliers_holder_depth = 50; // [20:1:200]
// Wall thickness around the hole. The side walls are 1.5 x this thick, so the holder is pliers_holder_hole_diameter + 3 x this wide.
pliers_holder_hole_border_padding = 5; // [2:0.5:20]
// Height of the open part above the middle block, as a fraction of pliers_holder_height.
pliers_holder_opening_height_ratio = 0.4; // [0.1:0.05:0.9]
// Depth of the round trough across the top of the middle block (at most half its width of pliers_holder_hole_diameter + pliers_holder_hole_border_padding), 0 for a flat top.
pliers_holder_center_trough_height = 5; // [0:0.5:40]
// Width of each arm at its front end.
pliers_holder_arms_width = 5; // [2:0.5:30]
// Height of the arms at the bottom front.
pliers_holder_arms_height = 10; // [3:0.5:50]
// Length of the arms in front of the holder, 0 for no arms.
pliers_holder_arms_length = 30; // [0:1:150]

/* [Rectangular tool holder] */
// Width of the flat, rectangular part of the tool that rests in the pocket (along the wall).
rectangular_tool_holder_tool_width = 36.5; // [5:0.1:300]
// Length of the rectangular part of the tool (from the wall to the front).
rectangular_tool_holder_tool_length = 69; // [5:0.1:300]
// Depth of the pocket the rectangular part sinks into.
rectangular_tool_holder_tool_slot_height = 5; // [1:0.1:100]
// Width of the hole for the handle or shaft below the rectangular part. The left and right holes reach from the side wall to 5.5 mm short of where a centered hole would end (like Frenchfinity 1.0).
rectangular_tool_holder_holder_hole_width = 25; // [1:0.1:300]
// Position of the hole.
rectangular_tool_holder_hole_position = "center"; // [left, center, right]
// Thickness of the walls around the pocket.
rectangular_tool_holder_wall_thickness = 5; // [1:0.1:20]

/* [Ring wrench holder] */
// Diameter of the stick the wrenches hang on.
ring_wrench_holder_stick_diameter = 24; // [8:0.5:60]
// Length of the stick.
ring_wrench_holder_stick_length = 34; // [10:1:250]
// The stick rises by this angle in degrees, so the wrenches cannot slide off.
ring_wrench_holder_angle = 10; // [0:1:30]
// Print the stick. Without it only the base with the bolt hole is printed (Frenchfinity 1.0 "no-stick").
ring_wrench_holder_stick = true;
// Diameter of the bolt that reinforces the stick (6 for M6).
ring_wrench_holder_screw_hole_diameter = 6; // [2:0.5:12]
// Size of the bolt head across flats (10 for M6).
ring_wrench_holder_screw_head_size = 10; // [4:0.5:20]
// Height of the bolt head, the depth of its recess in the front of the stick.
ring_wrench_holder_screw_depth = 4; // [1:0.5:10]
// Added to the bolt hole and the head recess so the bolt fits.
ring_wrench_holder_screw_tolerance = 0.3; // [0:0.05:1]

/* [Round hanging holder] */
// Diameter of the round head of the tool.
round_hanging_holder_tool_diameter = 59; // [10:0.5:200]
// Thickness of the head, the depth of the pocket behind the front lip.
round_hanging_holder_holder_depth = 9; // [2:0.5:100]
// Width of the slot in the bottom of the cradle for the shaft of the tool.
round_hanging_holder_bottom_hole_width = 20; // [2:0.5:150]
// The opening of the front lip is this much smaller than the head, so the head cannot slide forward.
round_hanging_holder_inset_depth = 2.25; // [0:0.25:30]
// Thickness of the back plate, the cradle and the front lip.
round_hanging_holder_wall_thickness = 5; // [2:0.5:20]

/* [Sandpaper holder] */
// Inner width of the compartment (along the wall): the width of the sheets plus some clearance.
sandpaper_holder_width = 110; // [20:0.5:300]
// Inner depth of the compartment (from the wall to the open front).
sandpaper_holder_depth = 160; // [20:0.5:300]
// Inner height of the compartment.
sandpaper_holder_height = 50; // [5:0.5:200]
// Thickness of the walls and the floor.
sandpaper_holder_wall_thickness = 2; // [1:0.1:10]
// Leave out the tongue on the back: the holder sits on another sandpaper holder (stacked) instead of hanging on the wall itself.
sandpaper_holder_attached = false;

/* [Screwdriver holder] */
// Diameter of the handle where it rests in the holder, the pocket gets exactly this diameter.
screwdriver_handle_width = 15; // [3:0.1:150]
// Diameter of the shaft (or the narrow end of the handle) below the pocket, the hole in the floor gets exactly this diameter.
screwdriver_stick_width = 11; // [1:0.1:150]
// Depth of the pocket the handle rests in.
screwdriver_inset_height = 10; // [0:0.5:100]
// Thickness of the floor below the pocket.
screwdriver_bottom_height = 10; // [2:0.5:100]
// Total height of the holder, the back plate with the tongue reaches up to here.
screwdriver_height = 50; // [20:1:300]
// Material left and right of the pocket, the holder is screwdriver_handle_width + 2 x this wide.
screwdriver_padding_sides = 5; // [2:0.5:50]
// Material in front of and behind the pocket.
screwdriver_handle_padding = 3; // [1:0.5:30]
// The hole for the shaft opens to the front and widens by this much per side, so the screwdriver can be pulled out to the front.
screwdriver_pull_out_tolerance = 3; // [0:0.5:30]
// Thickness of the back plate at its top edge.
screwdriver_back_width_min = 5; // [2:0.5:50]
// Thickness of the back plate where it meets the block with the pocket.
screwdriver_back_width_max = 10; // [2:0.5:50]

/* [Small hole holder] */
// Width of the hole in the tool, the pin is small_hole_holder_hole_tolerance thinner.
small_hole_holder_hole_width = 6; // [1:0.1:50]
// Width of the tool, the plate behind the pin is 5 mm wider.
small_hole_holder_tool_width = 20; // [5:0.5:200]
// Length of the pin.
small_hole_holder_hole_length = 8; // [1:0.5:100]
// The pin is this much thinner than the hole.
small_hole_holder_hole_tolerance = 0.5; // [0:0.05:3]
// The pin points this many degrees upwards, so the tool does not slide off.
small_hole_holder_angle = 2; // [0:0.5:30]

/* [T-handle holder] */
// The whole holder (except the tongue) is scaled by this factor, the other parameters describe the tool at scale 1.
t_handle_holder_scale = 0.6; // [0.55:0.01:2]
// Diameter of the handle around the stick (its widest part).
t_handle_holder_handle_width = 30; // [10:0.5:80]
// Diameter of the stick, the slot to the front is this wide.
t_handle_holder_stick_diameter = 7; // [1:0.5:30]
// Diameter of the bottom of the handle where the stick comes out.
t_handle_holder_hole_bottom_diameter = 17; // [2:0.5:60]
// Diameter of the front end of the handle.
t_handle_holder_end_front_diameter = 23; // [5:0.5:80]
// Diameter of the back end of the handle, the trough is half as deep.
t_handle_holder_end_back_diameter = 25; // [5:0.5:80]
// Distance from the stick to the back end of the handle.
t_handle_holder_stick_center_to_back_end_distance = 50; // [10:1:200]
// Distance from the stick to the front end of the handle.
t_handle_holder_stick_center_to_front_end_distance = 50; // [10:1:200]
// Half the length of the hole for the bottom of the handle (from its center to the front).
t_handle_holder_bottom_hole_to_front_bottom_distance = 15; // [1:0.5:100]

/* [Tablet holder] */
// Width of the holder along the wall. Use two holders for larger tablets.
tablet_holder_width = 30; // [10:1:300]
// Length of the slanted back rest, usually the height of the tablet. The holder is this x cos(angle) high.
tablet_holder_tablet_height = 135; // [40:1:400]
// Angle in degrees by which the tablet leans back from the vertical.
tablet_holder_angle = 20; // [5:1:60]
// Thickness of the back plate, the bottom bar and the lip.
tablet_holder_wall_thickness = 6; // [2:0.5:20]
// Thickness of the tablet (with its case). The channel at the bottom gets 2 x tablet_holder_tablet_tolerance more, the back rest is as thick as the tablet.
tablet_holder_tablet_thickness = 7.6; // [2:0.1:40]
// Clearance on each side of the tablet in the channel.
tablet_holder_tablet_tolerance = 1; // [0:0.1:5]

/* [Tape holder] */
// Width of the tape roll.
tape_holder_tape_width = 38; // [5:0.5:150]
// Outer diameter of a full roll.
tape_holder_max_tape_diameter = 130; // [30:1:300]
// Outer diameter of an empty roll (the core), the rods are placed for this size.
tape_holder_min_tape_diameter = 130; // [20:1:300]
// Diameter of the rods the roll rests on.
tape_holder_rest_diameter = 6; // [2:0.5:15]
// Clearance around the roll: left and right, behind it and below the empty roll.
tape_holder_padding = 5; // [1:0.5:20]
// Thickness of the side walls and the back plate.
tape_holder_wall_thickness = 5; // [2:0.5:15]

/* [Toilet paper holder] */
// Height of the plate.
toilet_paper_holder_height = 70; // [30:1:200]
// Diameter of the dowel that carries the rolls, the diameter of the recess.
toilet_paper_holder_hole_diameter = 19.5; // [5:0.5:60]
// Depth of the recess for the end of the dowel.
toilet_paper_holder_hole_depth = 3; // [0.5:0.5:10]
// Distance from the top edge of the plate to the recess.
toilet_paper_holder_hole_padding_top = 10; // [5:0.5:50]
// Material left and right of the recess.
toilet_paper_holder_hole_padding_side = 10; // [3:0.5:50]
// Thickness of the plate.
toilet_paper_holder_base_plate_width = 8; // [5:0.5:20]
// Diameter of the hole for the screw that holds the dowel.
toilet_paper_holder_screw_hole_diameter = 4; // [2:0.1:8]
// Diameter of the counterbore for the screw head in the back face.
toilet_paper_holder_screw_head_hole_diameter = 8; // [4:0.1:15]
// Depth of the counterbore for the screw head.
toilet_paper_holder_screw_head_hole_depth = 3; // [1:0.5:8]

/* [Tray] */
// Outer width of the tray (along the wall).
tray_width = 150; // [50:1:400]
// Outer depth of the tray (from the wall to the front).
tray_depth = 60; // [30:1:200]
// Outer height of the tray.
tray_height = 30; // [15:1:100]
// Thickness of the walls and the floor.
tray_wall_thickness = 2; // [1.2:0.4:5]
// Radius of the rounded corners.
tray_corner_radius = 5; // [1:20]

/* [Triangle top holder] */
// Width of the tool (along the wall), the pocket gets 2 x triangle_top_holder_tolerance more.
triangle_top_holder_tool_width = 96; // [5:0.5:300]
// Height of the pocket above the inner floor (the tip of the V).
triangle_top_holder_holder_height = 155; // [15:1:400]
// Height of the triangular end of the tool: the corners of the V and the top of the front wall are this (plus the tolerance) above the bottom of the holder.
triangle_top_holder_triangle_height = 47; // [5:0.5:300]
// Thickness of the tool (from the wall to the front), the depth of the pocket.
triangle_top_holder_tool_depth = 11; // [1:0.5:100]
// Clearance added on the left and on the right of the tool.
triangle_top_holder_tolerance = 1; // [0:0.1:5]
// Thickness of the walls and the floor.
triangle_top_holder_wall_thickness = 5; // [2:0.5:20]

/* [Wolfcraft Accumobil drilling aid holder] */
// Clearance between the drilling aid and the walls of the tray.
wolfcraft_accumobil_drilling_aid_holder_padding = 1; // [0:0.1:5]
// Thickness of the walls of the tray.
wolfcraft_accumobil_drilling_aid_holder_wall_thickness = 3; // [1:0.1:10]
// Height of the drilling aid. The walls of the tray are 5 mm lower so it can be grabbed.
wolfcraft_accumobil_drilling_aid_holder_height = 20; // [8:0.5:60]

/* [Wolfcraft corner clamp ES 22 holder] */
// Clearance between the corner clamp and the walls of the tray, also around the cut-out for the parts below the clamp.
wolfcraft_corner_clamp_es22_holder_padding = 2; // [0:0.1:5]
// Thickness of the walls of the tray.
wolfcraft_corner_clamp_es22_holder_wall_thickness = 3; // [1:0.1:10]

/* [Wrench holder] */
// Thickness of the wrench heads. The teeth are this plus wrench_holder_slot_separator_width apart, the slots between them 1 mm wider than the wrench with the default separators.
wrench_holder_wrench_width = 3.4; // [1:0.1:30]
// Length of the rails the wrenches hang on (Frenchfinity 1.0 calls it width).
wrench_holder_width = 27; // [10:1:300]
// Size of the rail profile, match it to the wrenches (Frenchfinity 1.0 used 0.44 for 3.4 mm thick wrench heads, 1 for 8 mm, 1.78 for 15 mm).
wrench_holder_scale = 0.44; // [0.2:0.01:3]
// Gap between two slots in addition to the wrench width.
wrench_holder_slot_separator_width = 3; // [1:0.5:10]
// Thickness of the teeth between the slots (front to back).
wrench_holder_slot_separator_height = 2; // [1:0.5:10]

/* [Guide] */
// Length of the guide.
guide_width = 140; // [40:1:500]
// Adds a block of this height on top of the 45 degree bevel, makes the guide taller. The slot keeps its position below the top of the bevel.
guide_extra_padding = 0; // [0:1:100]

/* [Tongue cleaner] */
// Length of the toothed edge that cleans the slot, the handle grows with it.
tongue_cleaner_width = 150; // [40:1:400]

/* [Letter] */
// The letter, digit or short text.
letter_text = "A";
// Height of a capital letter in mm (the cap height of the default font).
letter_height = 200; // [33:1:500]
// Thickness of the letter.
letter_thickness = 10; // [3:0.5:50]
// Font of the text. Liberation Sans ships with OpenSCAD, "Arial:style=Bold" matches Frenchfinity 1.0 exactly where it is installed.
letter_font = "Liberation Sans:style=Bold";
// cap_height: the capitals reach the top edge, all letters share the baseline (Frenchfinity 1.0). top: the highest point of the text reaches the top edge, use it for lowercase letters and symbols.
letter_alignment = "cap_height"; // [cap_height, top]

/* [Hidden] */

$fa = 6;
$fs = curve_resolution;

//
// Core
//

include <core/profile.scad>
include <core/labels.scad>
include <core/helpers.scad>

//
// Parts
//

include <features/allen_key_holder.scad>
include <features/angle_adapter.scad>
include <features/bin.scad>
include <features/bit_holder.scad>
include <features/box.scad>
include <features/caliper_holder.scad>
include <features/can_holder.scad>
include <features/crowbar_holder.scad>
include <features/custom_base_adapter.scad>
include <features/einhell_battery_holder.scad>
include <features/einhell_single_charger_holder.scad>
include <features/file_holder.scad>
include <features/french_plate.scad>
include <features/glubot_holder.scad>
include <features/grid.scad>
include <features/gridfinity_adapter.scad>
include <features/guide.scad>
include <features/hammer_holder.scad>
include <features/hook.scad>
include <features/ikea_skadis_plate.scad>
include <features/letter.scad>
include <features/lifting_clamp_holder.scad>
include <features/locksmith_corner_holder.scad>
include <features/meter_stick_holder.scad>
include <features/nussbaum_sl_smart_lift_plate.scad>
include <features/pliers_holder.scad>
include <features/rectangular_tool_holder.scad>
include <features/ring_wrench_holder.scad>
include <features/round_hanging_holder.scad>
include <features/sandpaper_holder.scad>
include <features/screw_driver.scad>
include <features/screw_plate.scad>
include <features/small_hole_holder.scad>
include <features/t_handle_holder.scad>
include <features/tablet_holder.scad>
include <features/tape_holder.scad>
include <features/toilet_paper_holder.scad>
include <features/tongue_cleaner.scad>
include <features/tray.scad>
include <features/triangle_top_holder.scad>
include <features/wall_anchor.scad>
include <features/welding_table_plate.scad>
include <features/wolfcraft_accumobil_drilling_aid_holder.scad>
include <features/wolfcraft_corner_clamp_es22_holder.scad>
include <features/wrench_holder.scad>

module render_selected_feature() {
    if (feature == "wall_anchor") feature_wall_anchor();
    else if (feature == "french_plate") feature_french_plate();
    else if (feature == "screw_plate") feature_screw_plate();
    else if (feature == "ikea_skadis_plate") feature_ikea_skadis_plate();
    else if (feature == "welding_table_plate") feature_welding_table_plate();
    else if (feature == "nussbaum_sl_smart_lift_plate") feature_nussbaum_sl_smart_lift_plate();
    else if (feature == "custom_base_adapter") feature_custom_base_adapter();
    else if (feature == "angle_adapter") feature_angle_adapter();
    else if (feature == "allen_key_holder") feature_allen_key_holder();
    else if (feature == "bin") feature_bin();
    else if (feature == "bit_holder") feature_bit_holder();
    else if (feature == "box") feature_box();
    else if (feature == "caliper_holder") feature_caliper_holder();
    else if (feature == "can_holder") feature_can_holder();
    else if (feature == "crowbar_holder") feature_crowbar_holder();
    else if (feature == "einhell_battery_holder") feature_einhell_battery_holder();
    else if (feature == "einhell_single_charger_holder") feature_einhell_single_charger_holder();
    else if (feature == "file_holder") feature_file_holder();
    else if (feature == "glubot_holder") feature_glubot_holder();
    else if (feature == "grid") feature_grid();
    else if (feature == "gridfinity_adapter") feature_gridfinity_adapter();
    else if (feature == "hammer_holder") feature_hammer_holder();
    else if (feature == "hook") feature_hook();
    else if (feature == "lifting_clamp_holder") feature_lifting_clamp_holder();
    else if (feature == "locksmith_corner_holder") feature_locksmith_corner_holder();
    else if (feature == "meter_stick_holder") feature_meter_stick_holder();
    else if (feature == "pliers_holder") feature_pliers_holder();
    else if (feature == "rectangular_tool_holder") feature_rectangular_tool_holder();
    else if (feature == "ring_wrench_holder") feature_ring_wrench_holder();
    else if (feature == "round_hanging_holder") feature_round_hanging_holder();
    else if (feature == "sandpaper_holder") feature_sandpaper_holder();
    else if (feature == "screw_driver") feature_screw_driver();
    else if (feature == "small_hole_holder") feature_small_hole_holder();
    else if (feature == "t_handle_holder") feature_t_handle_holder();
    else if (feature == "tablet_holder") feature_tablet_holder();
    else if (feature == "tape_holder") feature_tape_holder();
    else if (feature == "toilet_paper_holder") feature_toilet_paper_holder();
    else if (feature == "tray") feature_tray();
    else if (feature == "triangle_top_holder") feature_triangle_top_holder();
    else if (feature == "wolfcraft_accumobil_drilling_aid_holder") feature_wolfcraft_accumobil_drilling_aid_holder();
    else if (feature == "wolfcraft_corner_clamp_es22_holder") feature_wolfcraft_corner_clamp_es22_holder();
    else if (feature == "wrench_holder") feature_wrench_holder();
    else if (feature == "guide") feature_guide();
    else if (feature == "tongue_cleaner") feature_tongue_cleaner();
    else if (feature == "letter") feature_letter();
    else assert(false, str("Unknown feature: ", feature));
}

render_selected_feature();
