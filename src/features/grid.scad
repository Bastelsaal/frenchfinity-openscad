//
// Grid (Frenchfinity 1.0 "grid holder")
//
// A box divided into grid_rows x grid_columns cells, e.g. for drill bits, pens or small parts.
// grid_width and grid_depth are the outer size, grid_height is the depth of the cells.
// grid_wall_thickness is the thickness of the outer walls and the floor, grid_inner_wall_thickness
// the thickness of the walls between the cells. All cells have the same size, unless
// grid_legacy_layout places the inner walls exactly like Frenchfinity 1.0 did (its outer cells are
// slightly larger than the inner ones).
//

function grid_params() = concat(
    [
        ["w", grid_width],
        ["d", grid_depth],
        ["h", grid_height],
        ["r", grid_rows],
        ["c", grid_columns],
        ["owt", grid_wall_thickness],
        ["iwt", grid_inner_wall_thickness]
    ],
    grid_legacy_layout ? [["legacy", ""]] : []
);

// Top edge of the grid, the bottom is at z = 0. A low grid gets a thicker floor.
function grid_top() = max(grid_height + grid_wall_thickness, ff_tongue_bottom_offset());

// Size of one cell when all cells are equal, along an inner length divided into `count` cells.
function grid_cell_size(inner, count) = (inner - (count - 1) * grid_inner_wall_thickness) / count;

// Start positions of the inner walls between `count` cells along an inner length that starts at
// `start`. Frenchfinity 1.0 placed the wall centers every (inner + iwt / count) / count mm.
function grid_wall_positions(start, inner, count) =
    count < 2 ? [] :
    grid_legacy_layout
        ? [
            for (i = [1 : count - 1])
                start + i * (inner + grid_inner_wall_thickness / count) / count - grid_inner_wall_thickness / 2
        ]
        : [
            for (i = [1 : count - 1])
                start + i * grid_cell_size(inner, count) + (i - 1) * grid_inner_wall_thickness
        ];

// Parameters on the bottom face, along the longer side of it.
module grid_label(params) {
    along_depth = grid_depth > grid_width;

    ff_engrave_params(
        params,
        [grid_width / 2, grid_depth / 2, 0],
        "bottom",
        max_width  = grid_width - 4,
        max_height = grid_depth - 4,
        rotation   = along_depth ? 90 : 0
    );
}

module feature_grid() {
    wall         = grid_wall_thickness;
    inner_wall   = grid_inner_wall_thickness;
    inner_width  = grid_width - 2 * wall;
    inner_depth  = grid_depth - 2 * wall;
    top          = grid_top();
    floor_top    = top - grid_height;
    params       = grid_params();

    assert(inner_width > 0 && inner_depth > 0, "grid_wall_thickness is too thick for grid_width and grid_depth.");
    assert(
        grid_cell_size(inner_width, grid_columns) > 0,
        "The cells have no width left: reduce grid_columns or grid_inner_wall_thickness, or increase grid_width."
    );
    assert(
        grid_cell_size(inner_depth, grid_rows) > 0,
        "The cells have no depth left: reduce grid_rows or grid_inner_wall_thickness, or increase grid_depth."
    );

    ff_echo_file_name("grid-holder", params);

    difference() {
        ff_holder(grid_width, top)
            difference() {
                cube([grid_width, grid_depth, top]);

                translate([wall, wall, floor_top])
                    cube([inner_width, inner_depth, grid_height + 1]);
            }

        if (floor_top > 2 * text_depth)
            grid_label(params);
    }

    // Walls between the columns (along y) and between the rows (along x).
    for (x = grid_wall_positions(wall, inner_width, grid_columns))
        translate([x, wall - ff_eps, floor_top - ff_eps])
            cube([inner_wall, inner_depth + 2 * ff_eps, grid_height + ff_eps]);

    for (y = grid_wall_positions(wall, inner_depth, grid_rows))
        translate([wall - ff_eps, y, floor_top - ff_eps])
            cube([inner_width + 2 * ff_eps, inner_wall, grid_height + ff_eps]);
}
