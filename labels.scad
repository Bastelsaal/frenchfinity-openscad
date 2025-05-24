module labelVertical (text, width_box, y, x = 0) {
    if (render_text) {
        y_rotation = x > 0 ? 180 : 0;
        
        translate([width_box, x, y])
            xrot(90)
            yrot(y_rotation)
                text3d(text, size=text_size, height=text_depth, anchor=CENTER);
    }
}