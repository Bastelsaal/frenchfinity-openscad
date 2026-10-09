// File: tray.scad

module feature_tray() {
    // Retrieve parameters from the main file settings
    w = tray_width;
    d = tray_depth;
    h = tray_height;
    t = tray_wall_thickness;
    r = tray_corner_radius;
    
    // Connector settings
    // We will make the connector 1/3 of the tray width, but at least 40mm, max 100mm
    // to ensure it's strong enough but doesn't dominate small trays.
    desired_conn_w = max(40, min(100, w / 3));
    // Center the connector
    conn_x_pos = (w - desired_conn_w) / 2;

    // Ensure radius isn't too big for the size, or too small for the wall thickness
    safe_r = min(r, min(w/2, d/2)); 
    inner_r = max(0.1, safe_r - t);

    union() {
        // 1. The Tray Body
        difference() {
            // Outer Shell (Rounded Box)
            hull() {
                translate([safe_r, safe_r, 0]) cylinder(r=safe_r, h=h, $fn=60);
                translate([w-safe_r, safe_r, 0]) cylinder(r=safe_r, h=h, $fn=60);
                translate([w-safe_r, d-safe_r, 0]) cylinder(r=safe_r, h=h, $fn=60);
                translate([safe_r, d-safe_r, 0]) cylinder(r=safe_r, h=h, $fn=60);
            }

            // Inner Hollow (shifted up and inward by thickness 't')
            translate([0, 0, t]) {
                 hull() {
                    translate([safe_r, safe_r, 0]) cylinder(r=inner_r, h=h, $fn=60);
                    translate([w-safe_r, safe_r, 0]) cylinder(r=inner_r, h=h, $fn=60);
                    translate([w-safe_r, d-safe_r, 0]) cylinder(r=inner_r, h=h, $fn=60);
                    translate([safe_r, d-safe_r, 0]) cylinder(r=inner_r, h=h, $fn=60);
                }
            }
        }

        // 2. The Connector on the back wall
        // Attached to back depth (d), centered horizontally, placed near top edge vertically.
        translate([conn_x_pos, d, h - (frenchfinity_1_0_slot_distance_top * 2)])
            nut(desired_conn_w, false);
    }
}