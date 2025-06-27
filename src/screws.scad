module screw (thread_diameter, thread_depth, head_height, head_diameter) {
     union() {
        cylinder(d=thread_diameter, h=thread_depth, center=false, $fn=100);
        cylinder(h=head_height, r1=head_diameter, r2=thread_diameter - 2, $fn=100);
     }
}