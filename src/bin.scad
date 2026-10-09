// File: bin.scad

module feature_bin() {
    w = bin_width;
    d = bin_depth;
    h = bin_height;
    t = bin_wall;
    
    // Fixed: set to 0 to ensure connector reaches the wall anchor
    connector_pull_in = 0; 

    union() {
        // 1. Build the Main Body (Walls & Floor)
        // A. Bottom Floor
        cube([w, d, t]);

        // B. Back Wall (Full Height)
        translate([0, d - t, 0]) 
            cube([w, t, h]);

        // C. Front Wall (Lip Height)
        cube([w, t, lip_height]);

        // D. Side Walls (The Custom Shape)
        side_profile = [
            [0, 0],              // Bottom Front
            [d, 0],              // Bottom Back
            [d, h],              // Top Back
            [d * 0.4, h],        // Top Flat section
            [0, lip_height] // Angle down to Front Lip
        ];

        // Left Wall
        translate([0, 0, 0]) 
            rotate([90, 0, 90]) 
            linear_extrude(t)
            polygon(side_profile);

        // Right Wall
        translate([w - t, 0, 0]) 
            rotate([90, 0, 90]) 
            linear_extrude(t)
            polygon(side_profile);

        // 2. Attach the Connector
        translate([0, d - connector_pull_in, h - (frenchfinity_1_0_slot_distance_top * 2)])
            nut(w, false); 
    }
}