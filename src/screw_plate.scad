module screw_plate_base () {
    cube([
        screw_plate_width,
        screw_plate_depth,
        screw_plate_height
    ]);
}

module screw_plate_with_groove () {
    y = (
        screw_plate_height -
        frenchfinity_1_0_slot_distance_top - 
        frenchfinity_1_0_slot_total_height_calculated
    );

    module local_groove() {
        translate([0, 0, y])
            nut(screw_plate_width, true);
    }

    difference() {
        screw_plate_base();
        local_groove();
    }
}

module screw_plate_screw_hole (effective_height, x, y) {
    thread_depth = screw_plate_depth + 2;
    
    xrot(90)
    yrot(180)
    translate([
         (screw_plate_width / -2) + x,
         ((effective_height / 2) + (screw_plate_height - effective_height) + y),
        -1
    ])
    screw (
        screw_plate_screw_thread_diameter, 
        thread_depth, 
        screw_plate_screw_head_height, 
        screw_plate_screw_head_diameter
    );
}

module screw_plate_with_screw_holes () {
    forbidden_y      = frenchfinity_1_0_slot_total_height_calculated - 10;
    effective_height = screw_plate_height - forbidden_y;
    screw_footprint  = screw_plate_screw_head_diameter + screw_plate_screw_hole_padding;
    screw_rows       = floor(screw_plate_width / screw_footprint);
    screw_columns    = floor(effective_height / screw_footprint);
    initialX         = ((screw_rows * screw_footprint) - screw_footprint) / 2;
    initialY         = ((screw_columns * screw_footprint) - screw_footprint) / 2;
    
    difference() {
        screw_plate_with_groove();
    
        for (column = [0 : screw_columns-1]) {
            for (row = [0 : screw_rows-1]) {
                x = initialX - (row * screw_footprint);
                y = initialY - (column * screw_footprint);
            
                screw_plate_screw_hole(effective_height, x, y);
            }
        }
    }
}

module screw_plate_with_screw_holes_and_text () {
    text_box_width = screw_plate_width / 2;
    text_y         = screw_plate_height - 30;
    labels         = hintFileName([
        final_version_prefix_calculated,
        str("w",   screw_plate_width),
        str("h",   screw_plate_height),
        str("d",   screw_plate_depth),
        str("std", screw_plate_screw_thread_diameter),
        str("shd", screw_plate_screw_head_diameter),
        str("shh", screw_plate_screw_head_height),
        str("shp", screw_plate_screw_hole_padding)
    ]);
    
    
    difference() {
        screw_plate_with_screw_holes();
        
        for (i = [0 : len(labels)-1])
            labelVertical(
                labels[i], 
                text_box_width, 
                text_y - i * 7,
                screw_plate_depth
            );
    }
}

module feature_screw_plate () {
    screw_plate_with_screw_holes_and_text();
}