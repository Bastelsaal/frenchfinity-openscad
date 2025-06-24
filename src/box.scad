module box_base () {
    cube([box_width, box_depth, box_height]);
}

module empty_box () {
    difference () {
        box_base();
        up(box_wall_thickness)
        right(box_wall_thickness)
        back(box_wall_thickness)
        cube([
            box_width - box_wall_thickness * 2, 
            box_depth - box_wall_thickness * 2,
            box_height - box_wall_thickness
        ]);
    }
}

module empty_box_with_nut () {
    union () {
        empty_box();
        up(box_height - (frenchfinity_1_0_slot_distance_top * 2))
            back(box_depth)
            nut(box_width, false);
    }
}

module empty_box_with_nut_and_text () {
    text_y         = box_height - 28;
    labels         = hintFileName([
        final_version_prefix_calculated,
        [
            str("w", box_width), 
            str("d", box_depth)
        ],
        [
            str("h", box_height),
            str("wt", box_wall_thickness)
        ],
    ]);
    
    difference() {
        empty_box_with_nut();
        
        for (i = [0 : len(labels)-1])
            labelVertical(
                labels[i], 
                box_width / 2, 
                text_y - i * 7,
                box_depth
            );
    }
}

  

    module feature_box_rounded_corners () {
        module left_right () {
            rounded_corner(
                [box_wall_thickness, box_wall_thickness,                   box_height],
                [box_wall_thickness, box_depth - box_wall_thickness, box_height], 
                1
            );
        }
        
        module front_back () {
             rounded_corner(
                [
                    box_width - box_wall_thickness, 
                    box_depth - box_wall_thickness,                   
                    box_height
                ],
                [
                    box_wall_thickness,
                    box_depth - box_wall_thickness,
                    box_height
                ], 
                1
            );
        }
    
        union() {
            left_right();
            left(-box_width + (box_wall_thickness * 2))
                left_right();
            front_back();
            back(-box_depth  + (box_wall_thickness * 2))
                front_back();
        }
    }
    
module feature_box () {
    module box_with_wall_thickness_cut_from_top (){
        intersection() {
            cube([box_width * 2, box_depth * 2, box_height- box_wall_thickness]);
            empty_box_with_nut_and_text();
        }
    }

    module box_with_added_rounded_corners_on_top () {
        box_with_wall_thickness_cut_from_top();
            up(box_height - box_wall_thickness)
                rounded_square(box_width, box_depth, box_wall_thickness);
    }


   box_with_added_rounded_corners_on_top();    
}