//
// French plate
//
// Slides into a wall anchor and offers a slot at the same height on its front. It adds height
// below a holder, so short holders still lean against the wall cleat and stay securely in place.
// Optionally the plate carries several slots on its front and several tongues on its back, one
// below the other, french_plate_slot_spacing apart (contributed by JGoodwillieV).
//

function french_plate_params() = concat(
    [
        ["w", french_plate_width],
        ["h", french_plate_height],
        ["d", french_plate_depth]
    ],
    // Only in the label and the file name when they differ from Frenchfinity 1.0 (one of each).
    ff_optional_params([
        ["fs", french_plate_front_slot_count, 1],
        ["bt", french_plate_back_tongue_count, 1]
    ]),
    max(french_plate_front_slot_count, french_plate_back_tongue_count) > 1
        ? [["ss", french_plate_slot_spacing]]
        : []
);

// Top edges (as passed to ff_slot / ff_tongue) of `count` slots or tongues, the first one at the
// top edge of the plate.
function french_plate_tops(count) =
    [for (i = [0 : 1 : count - 1]) french_plate_height - i * french_plate_slot_spacing];

module feature_french_plate() {
    front_count = french_plate_front_slot_count;
    back_count  = french_plate_back_tongue_count;
    lowest_top  = french_plate_height - (max(front_count, back_count, 1) - 1) * french_plate_slot_spacing;

    assert(front_count >= 0 && back_count >= 0, "The numbers of slots and tongues must not be negative.");
    assert(
        lowest_top >= ff_min_height(),
        max(front_count, back_count) <= 1
            ? str("french_plate_height must be at least ", ff_min_height(), " mm.")
            : str(
                "The plate is too low for ", max(front_count, back_count), " slots or tongues: ",
                "increase french_plate_height or reduce french_plate_slot_spacing."
            )
    );
    assert(
        max(front_count, back_count) <= 1 || french_plate_slot_spacing >= ff_head_height() + 2,
        str("french_plate_slot_spacing must be at least ", ff_head_height() + 2, " mm.")
    );
    assert(french_plate_depth >= ff_slot_depth() + 2, str("french_plate_depth must be at least ", ff_slot_depth() + 2, " mm."));

    params = french_plate_params();

    // The label sits on the back face below the lowest tongue.
    label_top = back_count > 0
        ? french_plate_height - (back_count - 1) * french_plate_slot_spacing - ff_slot_bottom_offset() - 2
        : french_plate_height - 2;
    label_bottom = 2;

    ff_echo_file_name("french-plate", params);

    difference() {
        union() {
            translate([0, -french_plate_depth, 0])
                cube([french_plate_width, french_plate_depth, french_plate_height]);

            for (top = french_plate_tops(back_count))
                ff_tongue_at(french_plate_width, top, -french_plate_depth);
        }

        for (top = french_plate_tops(front_count))
            ff_slot(french_plate_width, top);

        ff_engrave_params(
            params,
            [french_plate_width / 2, -french_plate_depth, (label_top + label_bottom) / 2],
            "back",
            max_width  = french_plate_width - 6,
            max_height = label_top - label_bottom
        );
    }
}
