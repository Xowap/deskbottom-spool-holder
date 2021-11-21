/**
 * Hanging spool holder
 *
 * It is designed to be inserted on the edge of a table and let the
 * spool hang underneath. There is a hole that lets the filament
 * reach the printer.
 */


/*[ Adjust for yourself ]*/

// How thick the table on which you'll hang this is
table_thickness = 36;

// What is the width of the spool
spool_width = 60;

// What is the radius of the spool
spool_radius = 100;


/*[ Elements dimensions ]*/

top_arm_thickness = 10;
top_arm_length = 60;
bottom_arm_thickness = 10;
bottom_arm_length = 60;
side_thickness = 25;
spool_arm_thickness = 20;
spool_width_margin = 10;
spool_radius_margin = 20;
side_margin = 0;
holder_radius = 15;
stop_radius = 20;
stop_angle = 60;
support_bevel_side = 10;
pass_inner_radius = 2;
pass_outer_radius = 3;
proof_width = 25;
proof_small_width = 10;
proof_depth = 6;
proof_wide_depth = 3;
proof_height = 8 * 4;
proof_platform = 1.8;
proof_distance = 10;
proof_margin = 5;
cable_trap_depth = 2;
cable_trap_padding = 5;
cable_trap_padding_bottom = 10;
cable_trap_between = 20;

overall_width = 
    spool_width 
    + spool_width_margin * 2 
    + side_margin * 2 
    + spool_arm_thickness;

underneath_height = 
    support_bevel_side
    + spool_radius_margin
    + spool_radius;

cable_trap_width =
    cable_trap_padding * 2
    + pass_inner_radius * 2
    + cable_trap_between;
    
cable_trap_height =
    cable_trap_padding_bottom
    + cable_trap_padding
    + pass_inner_radius * 2;

rotate([90, -90, 180])
build();

/**
 * Assembles all the elements
 */
module build() {
    c = table_thickness + bottom_arm_thickness;
    b = side_thickness;
    a = sqrt(b * b + c * c);
    alpha = acos(b / a);
    h = (
        top_arm_thickness 
        + bottom_arm_thickness 
        + table_thickness
    );
    w = (h * cos(alpha)) / sqrt(1 - cos(alpha) * cos(alpha));

    union() {
        clip();

        translate([
            side_margin,
            top_arm_length / 2 - holder_radius + side_thickness, 
            -underneath_height
        ])
        translate([0, holder_radius * 2, 0])
        rotate([0, 0, -90])
        bottom_part();

        translate([
            0,
            -(proof_depth + proof_distance + proof_margin),
            0
        ])
        proof_holder();

        translate([
            (
                (overall_width / 2)
                + pass_outer_radius
                + (
                    overall_width
                    - (overall_width / 2)
                    - pass_outer_radius
                ) / 2
                - cable_trap_width / 2
            ),
            w,
            h
        ])
        cable_trap();
    }
}

/**
 * The cable trap is basically two holes into which you can lock
 * the filament when you're done priting it.
 */
module cable_trap() {
   difference() {
        cube([
            cable_trap_width,
            cable_trap_depth,
            cable_trap_height
        ]);
   
        translate([
            pass_inner_radius + cable_trap_padding,
            -1,
            pass_inner_radius + cable_trap_padding_bottom
        ])
        rotate([-90, 0, 0])
        cylinder(
            h=(cable_trap_depth + 2),
            r=pass_inner_radius,
            $fn=100
        );
       
        translate([
            pass_inner_radius + cable_trap_padding + cable_trap_between,
            -1,
            pass_inner_radius + cable_trap_padding_bottom
        ])
        rotate([-90, 0, 0])
        cylinder(
            h=(cable_trap_depth + 2),
            r=pass_inner_radius,
            $fn=100
        );
    }
}

/**
 * If you're using calibration shapes to figure what are the good
 * settings for your filament (see
 * https://github.com/Xowap/cr30-calibration) then you can hang
 * them on this holder, this way you can remember the printing
 * temperature and other things for this particular filament.
 */
module proof_holder() {
    union() {
        translate([proof_margin, proof_margin, 0]) {
            cube([
                proof_width,
                proof_depth + proof_distance,
                proof_platform
            ]);

            translate([proof_width, proof_depth, proof_platform])
            rotate([0, 0, 180])
            union() {
                cube([
                    proof_width,
                    proof_wide_depth,
                    proof_height + 1
                ]);

                translate([(proof_width - proof_small_width) / 2, 0, 0])
                cube([
                    proof_small_width,
                    proof_depth,
                    proof_height + 1
                ]);
            }
        }

        cube([
            proof_margin * 2 + proof_width,
            proof_margin + proof_depth,
            proof_platform
        ]);
    }
}

/**
 * This is a "tunnel" for the filament to go from the spool to the
 * printer. This allows for the filament to leave the spool with a
 * more or less tangent direction while on the other end of the
 * hole you can pull it sideways without shifting the spool's
 * position.
 *
 * Let's note that it is specifically aligned with the upper table
 * edge in order to give the biggest entry angle possible so that
 * the filament thread is more or less tangent to the spool.
 */
module bottom_pass(with_hole) {
    c = table_thickness + bottom_arm_thickness;
    b = side_thickness;
    a = sqrt(b * b + c * c);
    alpha = acos(b / a);

    translate([(overall_width - pass_outer_radius * 2) / 2, 0, 0])
    rotate([-90+alpha, 0, 0])
    translate([0, -pass_outer_radius * 2, 0])
    pass_pipe(with_hole);
}

/**
 * Basic shape used by bottom_pass(). The "with_hole" argument
 * allows to choose if you want the whole or not in the output.
 * This is because you can also use it in a difference() to empty
 * the space before putting the tunnel there.
 */
module pass_pipe(with_hole) {
    difference() {
        cube([
            pass_outer_radius * 2, 
            pass_outer_radius * 2,
            1000
        ]);

        difference() {
            translate([-1, -1, -1])
            cube([
                pass_outer_radius * 2 + 2,
                pass_outer_radius * 2 + 2,
                1002
            ]);

            translate([pass_outer_radius, pass_outer_radius, -2])
            cylinder(
                h=1004,
                r=pass_outer_radius,
                $fn=100
            );

            translate([-2, pass_outer_radius, -4])
            cube([
                pass_outer_radius * 2 + 4,
                pass_outer_radius + 2,
                1008
            ]);
        }

        if (with_hole) {
            translate([pass_outer_radius, pass_outer_radius, -1])
            cylinder(
                h=1002,
                r=pass_inner_radius,
                $fn=100
            );
        }
    }
}

/**
 * Group generations of the holding arm/bottom part of the holder.
 */
module bottom_part() {
    union() {
        spool_arm();
        
        translate([holder_radius, (overall_width - side_margin * 2), 0])
        rotate([0, -90, 90])
        holder();
    }
}

/**
 * That's just an arm that goes down to hold the cylinder on which
 * the spool is held. There is some kind of inner bevel for more
 * strength due to the fact that it'll have to hold the whole
 * spool. Not sure how useful it is though. But I guess it'll at
 * least limit the wear by limiting how much jiggling the arm can
 * do.
 */
module spool_arm() {
    union() {
        cube([
            holder_radius * 2,
            spool_arm_thickness,
            underneath_height
        ]);

        translate([
            holder_radius * 2,
            spool_arm_thickness,
            underneath_height
        ])
        rotate([0, 180, 0])
        rotate([90, 0, 90])
        linear_extrude(holder_radius * 2)
        polygon([
            [0, 0],
            [0, support_bevel_side],
            [support_bevel_side, 0]
        ]);
    }
}

/**
 * The holder itself is just a cylinder with another cylinder at
 * the end. Here the stop cylinder is actually angled and not flat
 * so it can be easily printed on a CR-30 without supports.
 */
module holder() {
    union() {
        cylinder(
            h=(overall_width - side_margin * 2),
            r=holder_radius,
            $fn=100
        );
        
        cylinder(
            h=stop_radius * tan(stop_angle),
            r1=stop_radius,
            r2=0,
            $fn=100
        );
    }
}

/**
 * That's the clip_base() described below but including the cable
 * pass.
 */
module clip() {
    union() {
        difference() {
            clip_base();

            bottom_pass(false);
        }

        difference() {
            bottom_pass(true);

            translate([0, 0, bottom_arm_thickness + table_thickness + top_arm_thickness])
            cube([
                overall_width,
                1000,
                1000
            ]);
        }
    }
}

/**
 * That's the "clip" that you slide around the table. Due to the
 * design, all the force will be on the bottom face of the top arm.
 * The lower part of the clip is just there to hold the part that
 * holds the spool while the side is just there to bind both parts
 * together. In other words, the clip does not need to be tightly
 * adjusted to the table to hold in place.
 */
module clip_base() {
    union() {
        cube([
            overall_width, 
            bottom_arm_length + side_thickness,
            bottom_arm_thickness
        ]);

        translate([0, 0, bottom_arm_thickness + table_thickness])
        cube([
            overall_width, 
            top_arm_length + side_thickness, 
            top_arm_thickness
        ]);

        cube([
            overall_width,
            side_thickness,
            bottom_arm_thickness + table_thickness + top_arm_thickness
        ]);
    }
}