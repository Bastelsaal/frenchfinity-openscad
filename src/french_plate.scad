module french_plate_base () {
    cube([
        french_plate_width,
        french_plate_depth,
        french_plate_height
    ]);
}

module french_plate_with_tongue_and_groove () {
    // Calculate the Y position for the TOP-most slot
    top_y = (
        french_plate_height -
        frenchfinity_1_0_slot_distance_top - 
        frenchfinity_1_0_slot_total_height_calculated
    );

    union () {
        // 1. The base block with FRONT CHANNELS (Grooves) subtracted
        difference() {
            french_plate_base();
            
            // Only loop if the count is greater than 0
            if (french_plate_front_channel_count > 0) {
                // Loop from 0 to count-1
                for (i = [0 : french_plate_front_channel_count - 1]) {
                    translate([0, 0, top_y - (i * french_plate_slot_spacing)])
                        nut(french_plate_width, true);
                }
            }
        }

        // 2. The BACK CONNECTORS (Tongues) added
        // Only loop if the count is greater than 0
        if (french_plate_back_connector_count > 0) {
            for (i = [0 : french_plate_back_connector_count - 1]) {
                translate([0, french_plate_depth, top_y - (i * french_plate_slot_spacing)])
                    nut(french_plate_width, false);
            }
        }
    }
}

module french_plate_with_tongue_and_groove_and_text () {
    text_box_width = french_plate_width / 2;
    text_y         = french_plate_height - 30; 
    
    // Updated labels to include the new counts for reference on the print
    labels         = hintFileName([
        final_version_prefix_calculated,
        str("w", french_plate_width),
        str("h", french_plate_height),
        str("F", french_plate_front_channel_count), // F = Front Channels
        str("B", french_plate_back_connector_count)  // B = Back Connectors
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
