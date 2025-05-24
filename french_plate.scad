module french_plate_base () {
    cube([
        french_plate_width,
        french_plate_depth,
        french_plate_height
    ]);
}

module french_plate_with_tongue_and_groove () {
    y = (
        french_plate_height -
        frenchfinity_1_0_slot_distance_top - 
        frenchfinity_1_0_slot_total_height_calculated
    );

    module local_groove() {
        translate([0, 0, y])
            nut(true);
    }

    module local_tongue() {
        translate([0, french_plate_depth, y])
            nut(false);
    }

    union () {
        difference() {
            french_plate_base();
            local_groove();
        }
        local_tongue();
    }
}

module french_plate_with_tongue_and_groove_and_text () {
    text_box_width = french_plate_width / 2;
    text_y         = french_plate_height - 30;
    labels         = hintFileName([
        final_version_prefix_calculated,
        str("w", french_plate_width),
        str("h", french_plate_height),
        str("d", french_plate_depth)
    ]);
    
    difference() {
        french_plate_with_tongue_and_groove();
        
        for (i = [0 : len(labels)-1])
            labelVertical(
                labels[i], 
                text_box_width, 
                text_y - i * 7,
                french_plate_depth
            );
    }
}

module feature_french_plate () {
    french_plate_with_tongue_and_groove_and_text();
    
}
