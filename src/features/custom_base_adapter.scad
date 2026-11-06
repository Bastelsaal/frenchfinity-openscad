//
// Custom base adapter
//
// Two tongues back to back. Connects two parts with slots, e.g. a wooden holder with a milled slot
// to a wall anchor or plate.
//

function custom_base_adapter_params() = [
    ["w", custom_base_adapter_width]
];

module feature_custom_base_adapter() {
    params     = custom_base_adapter_params();
    // Places the lowest point of the tongues on z = 0.
    top        = ff_tongue_bottom_offset();
    neck_top   = ff_slot_z(top) + ff_neck_height() / 2 - print_tolerance;
    neck_depth = ff_neck_depth() + print_tolerance;

    ff_echo_file_name("custom-base-adapter", params);

    difference() {
        union() {
            ff_tongue(custom_base_adapter_width, top);

            mirror([0, 1, 0])
                ff_tongue(custom_base_adapter_width, top);
        }

        ff_engrave_params(
            params,
            [custom_base_adapter_width / 2, 0, neck_top],
            "top",
            max_width  = custom_base_adapter_width - 4,
            max_height = 2 * neck_depth - 2,
            per_line   = 1
        );
    }
}
