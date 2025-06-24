module rounded_corner (point1, point2, radius) {
    hull() {
        translate(point1)
            sphere(r = radius, $fn = 100);

        translate(point2)
            sphere(r = radius, $fn = 100);
    }
}


module rounded_square (width, depth, height) {
    module left_right () {
        rounded_corner(
            [
                0, 
                0,     
                height
            ],
            [
                0,
                depth,
                height
            ], 
            height
        );
    }
    
    module front_back () {
         rounded_corner(
            [
                width, 
                depth,                   
                height
            ],
            [
                0,
                depth,
                height
            ], 
            height
        );
    }
    
    module rounded_corners () {
        union() {
            left_right();
            left(-width)
                left_right();
            front_back();
            back(-depth)
                front_back();
        }
    }
    
    zflip()
    down(height)
    intersection() {
        rounded_corners();
        cube([
            width,
            depth,
            height
        ]);
    }
}