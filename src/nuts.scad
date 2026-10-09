module frenchfinity_1_0_nut(width, include_filament_hole) {
    
    // --- TOLERANCE LOGIC ---
    // If include_filament_hole is true, we are cutting a slot (Female), so we want EXACT size (tolerance 0).
    // If include_filament_hole is false, we are printing a connector (Male), so we SHRINK it by tolerance.
    // We default to 0 if the variable is missing to prevent errors.
    tol = (include_filament_hole) ? 0 : (is_undef(connector_tolerance) ? 0 : connector_tolerance);

    // We shrink the HEIGHT (Z) heavily to allow sliding.
    // We shrink the THICKNESS (Y) slightly to allow the hook to seat.
    eff_outer_h = frenchfinity_1_0_slot_outer_height - tol;
    eff_inner_h = frenchfinity_1_0_slot_inner_height - tol;
    eff_inner_w = frenchfinity_1_0_slot_inner_width - (tol / 2); // Shrink depth less aggressively

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
        // 1. The Neck (Base Block)
        cube([
            width,
            frenchfinity_1_0_slot_outer_width,
            eff_outer_h // Shrink height
        ]);        
        
        // 2. The Head (Locking Lip)
        translate([
            0,
            frenchfinity_1_0_slot_outer_width,
            (eff_outer_h - eff_inner_h) / 2 // Automatically centers the lip vertically based on new heights
        ])
        cube([
            width,
            eff_inner_w, // Shrink depth
            eff_inner_h  // Shrink height
        ]);
    }
    
    module final_basic_nut () {
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
    
    final_basic_nut();
}

module nut(width, include_filament_hole) {
    module selected_nut () {
        frenchfinity_1_0_nut(width, include_filament_hole);
    }

    selected_nut();
}
