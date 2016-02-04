/************************************************************************************

koios.scad - structural and tool objects required to build an Koios delta platform
Copyright 2014 Jerry Anzalone
Author: Jerry Anzalone <jerry@3d4edu.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

************************************************************************************/

// requires the common delta modules
include <simple_delta_common.scad>

/************  layer_height is important - set it to the intended print layer height  ************/
layer_height = 0.33; // layer height that the print will be produced with

// [w, l, t] = [y, x, z]
$fn = 48;
pi = 3.1415926535897932384626433832795;

// bar clamp dims
t_bar_clamp = 8;
h_bar_clamp = 10;

h_apex = 1.5 * 25.4; // for proper fit to 1.5" x 0.75" Al rectangular tubing

// the following sets the spacing of the linking board mounts on motor/idler ends
cc_motor_mounts = 120; // c-c of mounts on idler end - large to maximize x-y translation when in fixed tool mode and minimizes material use for bases
cc_idler_mounts = 75; // c-c of mounts on idler end

// printer dims
r_printer = 175; // radius of the printer - typically 175; 203.5 yields exact same geometry with 12" Al rod and 3/8" bearing
l_tie_rod = 250; // length of the tie rods - typically 250; with 12" Al rod + 3/8" bearing = 312.477

// guide rod and clamp dims
cc_guides = 60; // center-to-center of the guide rods
d_guides = 8.3;//8.5; // diameter of the guide rods
pad_clamp = 8; // additional material around guide rods
gap_clamp = 2; // opening for clamp

// following for tabs on either side of clamp to which linking boards are attached
// the radius of the delta measured from the center of the guide rods to the center of the triangle
// as drawn here, the tangent is parallel to the x-axis and the guide rod centers lie on y=0
//cc_mount = 75; // center to center distance of linking board mount pivot points standard = 75
w_mount = 15.2; // thickness of the tabs the boards making up the triangle sides will attach to - for koios, it's the inside width of a 1.5" x 0.75" x 0.125" rectangular aluminum tube, need to add 3mm to make up for the recess pocket Changed to 15.2 09/14/15
l_mount = 40; // length of said tabs
h_mount = 31.8; // height of the tab - for koios, it's the inside length of a 1.5" x 0.75" x 0.125" rectangular aluminum tube
cc_mount_holes = 16;
l_base_mount = l_mount;
w_base_mount = 14.1;
t_base_mount = 8.0;
r_base_mount = 3;
l_mount_slot = 2; // length of the slot for mounting screw holes

cc_v_board_mounts = 2 * (cc_guides / 2 - pad_clamp + d_M3_screw / 2); // c-c mounts for vertical boards

l_idler_relief = cc_guides - 25; // with guide rod clamp design, the length needs to be smaller so there are walls for bridging
w_idler_relief = 15;
r_idler_relief = 2; // radius of the relief inside the apex
l_clamp = cc_guides + d_guides + pad_clamp;
w_clamp = 30;
h_clamp = h_mount + 0.25 * 25.4;
l_motor_cage = l_NEMA17 + 13; // length of a side on the motor cage - more is added in the x-direction
h_motor_mount = 6; // thickness of motor mount base
h_idler_spacer = (l_motor_cage - w_clamp) / 2;
z_offset_guides = 6;

// ball joint mount dimensions
l_ball_joint = 7 + h_M3_washer;
d_ball_joint = 6;
d_ball_socket = 10; // diameter of the ball joint socket
d_mount_ball_joint = d_ball_joint + 4;
l_mount_ball_joint = l_ball_joint + 6;
offset_mount = 3;

// magnetic ball joint dims
d_ball_bearing = 3 * 25.4 / 8;
id_magnet = 15 * 25.4 / 64;
od_magnet = 3 * 25.4 / 8;
h_magnet = 25.4 / 8;
r_bearing_seated = pow(pow(d_ball_bearing / 2, 2) - pow(id_magnet / 2, 2), 0.5); // depth ball bearing sinks into magnet id
h_carriage_magnet_mount = 9;
h_effector_magnet_mount = 10;
r_pad_carriage_magnet_mount = 2;
r_pad_effector_magnet_mount = 2;

// effector dims
l_effector = 60; // this needs to be played with to keep the fan from hitting the tie rods
h_effector = equilateral_height_from_base(l_effector);
r_effector = l_effector * tan(30) / 2 + d_mount_ball_joint;
t_effector = 6;
h_triangle_inner = h_effector + 12;
r_triangle_middle = equilateral_base_from_height(h_triangle_inner) * tan(30) / 2;

// for the small tool end effector:
d_small_effector_tool_mount = 30; // diameter of the opening in the end effector that the tool will pass through
d_small_effector_tool_magnet_mount = 1 + d_small_effector_tool_mount + od_magnet + 2 * r_pad_effector_magnet_mount; // ring diameter of the effector tool magnet mounts

// for the large tool end effector:
d_large_effector_tool_mount = 50;
d_large_effector_tool_magnet_mount = h_triangle_inner;

// Bowden sheath dims
d_175_sheath = 4.8;
175_bowden = [d_M4_nut, h_M4_nut, d_175_sheath];

t_hotend_cage = t_heat_x_jhead - h_groove_jhead - h_groove_offset_jhead;
d_hotend_side = d_large_jhead + 8; // 8 for a normal j-head, 16 for large all-metal j-head
z_offset_retainer = t_hotend_cage - t_effector / 2 - 3;  // need an additional 3mm to clear the interior of the cage
a_fan_mount = 15;
l_fan = 39.5;
r_flare = 6;
h_retainer_body = h_groove_jhead + h_groove_offset_jhead + 4;
r1_retainer_body = d_hotend_side / 2 + r_flare * 3 / t_hotend_cage;
r2_retainer_body = r1_retainer_body - r_flare * h_retainer_body / t_hotend_cage;
r2_opening = (d_hotend_side - 5 ) / 2 + r_flare * (t_hotend_cage - 6 - t_effector + 3.0) / (t_hotend_cage - 6);//r1_opening - r_flare * (t_effector + 1.5) / t_hotend_cage;
r1_opening = r2_opening - 1.5;
d_retainer_screw = d_M2_screw;

// carriage dims:
w_carriage_web = 4;
h_carriage = l_lm8uu + 4;
carriage_offset = 18.6; // distance from center of guide rods to center of ball mount pivot
y_web = - od_lm8uu / 2 - (3 - w_carriage_web / 2);
stage_mount_pad = 2.2;

// limit switch dims
l_limit_switch = 24;
w_limit_switch = 6;
t_limit_switch = 14;
cc_limit_mounts = 9.5;
limit_x_offset = 11; // 11 places limit switch at guide rod, otherwise center at cc_guides / 2 - 8
limit_y_offset = d_M3_screw - carriage_offset;

// lead screw dims
r_leadnut_mounts = 8;	// radius of leadnut mounting screw circle
d_screw_leadnut = d_M3_screw; // diameter of the leadnut mounting screw
d_leadscrew = 8.2; // diameter of the leadscrew plus some clearance
d_leadscrew_collar = 10.2; // the leadnut has additional length of this diameter that the leadscrew passes through

// following for calculating length of guide rods and vertical boards
l_leadscrew = 400; // req'd to calculate length of guide rods
overhang_leadscrew = 30; // the leadscrews don't have to reach the idler, they can be above the idler by this amount
h_NEMA17 = 48; // height of the NEMA 17 motor, req'd for calculating length of verticals
h_baseplate = 0; // thickness of the baseplate mounted atop the linking boards

l_guides = ceil(l_leadscrew - h_motor_mount + 2 * (h_clamp - z_offset_guides) + overhang_leadscrew + h_baseplate); // length of the guide rods
l_verticals = ceil(l_guides + 2 * z_offset_guides + (h_NEMA17 - h_clamp + h_motor_mount) + 5);

// aluminum member dims
l_vertical_board = 3 * 25.4; // long dimension of rectangular tube making vertical board
w_vertical_board = 25.4; // short dimension of rectangular tube making vertical board
l_linking_board = 38.6;
w_linking_board = 3 * 25.4 / 4;

// center-to-center of tie rod pivots
tie_rod_angle = acos((r_printer - r_effector - carriage_offset) / l_tie_rod);

echo(str("Printer radius = ", r_printer));
echo(str("Effector offset = ", r_effector, "mm"));
echo(str("Carriage offset = ", carriage_offset, "mm"));
echo(str("Printer effective radius = ", r_printer - r_effector - carriage_offset));
echo(str("Radius of base plate = ", ceil(r_printer - d_guides / 2 - 1), "mm"));
echo(str("Tie rod angle at (0, 0, 0) = ", tie_rod_angle));
echo(str("Effector tie rod c-c = ", l_effector, " mm"));
echo(str("A lead screw length of ", l_leadscrew, "mm requires a guide rod length of ", l_guides, "mm"));
echo(str("A lead screw length of ", l_leadscrew, "mm requires a vertical board length of ", l_verticals, "mm"));

module koios_end_idler(z_offset_guides = z_offset_guides) {
	difference() {
		union() {
			difference() {
				round_box(
					length = l_clamp,
					width = w_clamp,
					height = h_clamp,
					radius = 4
				);

				// trim the interior corners so that the linking bars can slide all the way onto the mounts
				// this is shoe-horned; if mount geometry changes, this will need tweaking!
				for (i = [-1, 1])
					translate([i * (l_clamp / 2), - w_clamp / 2, 0])
						rotate([0, 0, i * 30])
							cube([10, 5.5, h_clamp + 1], center = true);
			}

			koios_apex(
				l_slot = 0,
				height_apex = h_clamp,
				height_tab = h_mount,
				cc_mount = cc_idler_mounts,
				base_mount = false,
				nut_pocket = 1
			);
		}

		// interior
		round_box(
			length = l_idler_relief,
			width = w_idler_relief,
			height = h_clamp + 1,
			radius = r_idler_relief
		);

		rotate([90, 0, 0])
			round_box(
				length = l_idler_relief,
				width = w_idler_relief,
				height = h_mount + 1,
				radius = r_idler_relief
			);

		// guide rod pockets make a floor so that it prints nicely at the top of the clamp pocket
		difference() {
			translate([0, 0, -z_offset_guides])
				guide_rod_pockets(height = h_clamp);

			translate([-cc_guides / 2, -d_guides / 2 - 1, h_bar_clamp / 2 + layer_height])
				cube([cc_guides, d_guides + 2, layer_height]);
		}

		// clamp pockets
		for (i = [-1, 1])
			translate([i * cc_guides / 2, 0, 0]) {
				// the bar clamp will be rectangular but the pocket it sits in will be trapezoidal so that the clamp can be pressed against the guide rod
				translate([i * -t_bar_clamp / 2, 0, 0]) {
					hull() {
						translate([0, -w_clamp / 2 - 1, 0])
							cube([t_bar_clamp, 0.1, h_bar_clamp + 2 * layer_height], center = true);

						translate([i, w_clamp / 2 + 1, 0])
							cube([t_bar_clamp + 2, 0.1, h_bar_clamp + 2 * layer_height], center = true);
					}

					translate([i * (pad_clamp / 2 + 1), w_clamp / 2 - 7, 0])
						rotate([0, 90, 0])
							cylinder(r = d_M3_screw / 2, h = 2 * pad_clamp, center = true);
				}
			}

		translate([0, w_clamp / 2 - 7, 0])
			rotate([0, 90, 0])
				difference() {
					cylinder(r = d_M3_nut / 2 + 0.5, h = l_clamp + 15, center = true);

					cylinder(r = d_M3_nut / 2 + 1, h = l_clamp - 1.6, center = true);
				}

		koios_vertical_board_relief(length = w_clamp);
	}
}

module koios_end_motor(z_offset_guides = z_offset_guides) {
	difference() {
		union() {
			round_box(
				length = l_motor_cage + 4,
				width = l_motor_cage,
				height = h_clamp,
				radius = 4);

			translate([0, l_motor_cage / 4, 0])
				cube([l_clamp, l_motor_cage / 2, h_clamp], center = true);

			round_box(
				length = l_clamp,
				width = w_clamp,
				height = h_clamp,
				radius = 4);

			koios_apex(
				l_slot = 0,
				height_apex = h_clamp,
				height_tab = h_mount,
				cc_mount = cc_motor_mounts,
				base_mount = false,
				nut_pocket = 1
			);		}

		// pocket for motor
		translate([0, 0, h_motor_mount])
			round_box(
				length = l_NEMA17 + 1,
				width = l_NEMA17 + 1,
				height = h_clamp,
				radius = 6);

		// motor mount holes
		translate([0, 0,  (h_motor_mount - h_clamp) / 2])
			NEMA_parallel_mount(
				height = h_motor_mount + 1,
				l_slot = 0,
				motor = NEMA17);

		// guide rod pockets make a floor so that it prints nicely at the top of the clamp pocket
		difference() {
			translate([0, 0, -z_offset_guides])
				guide_rod_pockets(height = h_clamp);

			translate([-cc_guides / 2, -d_guides / 2 - 1, 10 + layer_height])
				cube([cc_guides, d_guides + 2, layer_height]);
		}

		// clamps are inserted from motor pocket:
		cube([cc_guides + 1, 16, 20 + 2 * layer_height], center = true);

		// clamp screw pockets
//		for (i = [-1, 1])
//			translate([0, i * (w_clamp - 10) / 2, 0])
//				rotate([0, 90, 0]) {
//					cylinder(r = d_M3_screw / 2, h = 2 * l_clamp, center = true);

//					for (j = [0, 1])
//						mirror([0, 0, j])
//							translate([0, 0, l_clamp / 2 - 0.8])
//								cylinder(r = d_M3_nut / 2 + 0.5, h = 4);
//				}

		// holes for mounting vertical board
		koios_vertical_board_relief(
			length = l_motor_cage,
			washer_inset = 1,
			v_spacing = 25
		);
	}
}

module koios_carriage() {
	union() {
		difference() {
			union() {
				carriage_body(limit_switch_mount = false);

				// magnet mounts
				for (i = [-1, 1])
					translate([i * l_effector / 2, -carriage_offset, stage_mount_pad + h_carriage_magnet_mount / sin(tie_rod_angle)])
						rotate([90 - tie_rod_angle, 0, 0])
							magnet_mount(r_pad = r_pad_carriage_magnet_mount, h_pad = h_carriage_magnet_mount);

				mirror([0, 0, 1])
					for (i = [-1, 1])
						translate([i * l_effector / 2, -carriage_offset, stage_mount_pad + h_carriage_magnet_mount / sin(tie_rod_angle)])
							rotate([90 - tie_rod_angle, 0, 0]) {
								magnet_mount(r_pad = r_pad_carriage_magnet_mount, h_pad = h_carriage_magnet_mount);

								// support for printing the mounts
								translate([0, 0, (h_magnet + h_carriage_magnet_mount) / 2 - r_bearing_seated + 0.25])
									difference() {
										cylinder(r = od_magnet / 2 + r_pad_carriage_magnet_mount, h = h_magnet + h_carriage_magnet_mount, center = true);

										cylinder(r = od_magnet / 2, h = h_magnet + h_carriage_magnet_mount, center = true);
									}
						}

				// leadnut mount
				translate([0, 0, -h_carriage / 2])
					difference() {
						cylinder(r = r_leadnut_mounts + 3, h = 8);

						translate([-r_leadnut_mounts, - r_leadnut_mounts + y_web, -1])
							cube([2 * r_leadnut_mounts, r_leadnut_mounts, 10]);
					}

			}

			for (i = [-1, 1])
				translate([i * cc_guides / 2, 0, 0])
					carriage_wire_tie_relief();

			carriage_bearing_relief();

			// relief for leadnut collar
			cylinder(r = d_leadscrew_collar / 2, h = h_carriage + 1, center = true); // pocket for screw

			// leadnut mount holes
			for (i = [0:2])
				rotate([0, 0, i * 90])
					translate([r_leadnut_mounts, 0, -h_carriage / 2 - 1])
						cylinder(r = d_screw_leadnut / 2, h = 10);

			// flatten the bottom
			translate([0, 0, -h_carriage])
				cube([2 * cc_guides, 4 * (od_lm8uu + 6), h_carriage], center = true);
		}

	// floor for rod opening
	for (i = [-1, 1])
		translate([i * cc_guides / 2, -0.35, l_lm8uu / 2 + layer_height])
			cube([od_lm8uu, id_lm8uu, 2 * layer_height], center = true);

	// add a protrusion for making the vertical board-mounted directional limit switch
	for (i = [-1, 1])
		translate([i * (cc_guides / 2 - (od_lm8uu / 2 + 6)),  - 7.5, 0]) // offset it from the belt terminator mount point
			rotate([0, 90, 0])
				intersection() {
					scale([1.5, 1, 1])
						cylinder(r = h_carriage / 2, h = 7, center = true);

					translate([0, h_carriage / 2, 0])
						cube([h_carriage, h_carriage, 11], center = true);
				}
	}
}

module guide_rod_pockets(height) {
	for (i = [-1, 1])
		translate([i * cc_guides / 2, 0, 0])
			cylinder(r = d_guides / 2, h = height, center = true);
}


module koios_vertical_board_relief(
	length,
	v_spacing = 20,
	washer_inset = 0) {
	// holes for mounting vertical board
	for (i = [-1, 1])
		for (j = [-1, 1])
			translate([i * (cc_guides / 2 - 6), 0, j * v_spacing / 2])
				rotate([90, 0, 0]) {
					cylinder(r = d_M3_screw / 2, h = length + 1, center = true);

					difference() {
						cylinder(r = d_M3_nut / 2 + 1, h = length + 15, center = true);

						cylinder(r = d_M3_nut / 2 + 2, h = length - 2 * washer_inset, center = true);
					}
				}
}

module idler_spacer() {
	difference() {
		translate([0, 0, 2])
			cube([l_vertical_board, h_clamp, h_idler_spacer + 4], center = true);

		// interior
		round_box(
			length = l_idler_relief + 4,
			width = w_idler_relief + 5,
			height = h_idler_spacer + 1,
			radius = r_idler_relief
		);

		round_box(
			length = l_clamp - 12,
			width = w_clamp - 18,
			height = h_idler_spacer + 1,
			radius = r_idler_relief
		);

		rotate([90, 0, 0])
			koios_vertical_board_relief(length = h_idler_spacer);

		translate([0, 0, (w_clamp + h_idler_spacer) / 2])
			rotate([90, 0, 0])
				round_box(
					length = l_clamp,
					width = w_clamp,
					height = h_clamp + 1,
					radius = 4
				);


	}
}

module motor_bar_clamp() {
//	rotate([0, -90, 0])
		difference() {
			hull() {
				cube([(cc_guides - l_NEMA17) / 2 - 2, 15, 20], center = true);

				translate([-(cc_guides - l_NEMA17) / 4 + 1, 0, 0])
					rotate([90, 0, 0])
						cylinder(r = 0.75, h = 15, center = true);
			}

			translate([h_bar_clamp / 2, 0, 0])
				cylinder(r = d_guides / 2, h = 21, center = true);

	}
}

// central_limit_switch permits mounting a switch on the interior of vertical boards
module koios_limit_switch_mount() {
	l_switch_mount = 20;
	w_switch_mount = 10;
	h_switch_mount = 20;

	difference() {
		cube([l_switch_mount, w_switch_mount, h_switch_mount], center = true);

		translate([-5, 3.5, 0])
			cube([l_switch_mount, w_switch_mount, h_switch_mount + 1], center = true);

		// limit switch mounts
		translate([l_switch_mount / 2, 2, 0])
			rotate([0, 90, 0])
				for (i = [-1, 1])
					translate([i * cc_limit_mounts / 2, 0, 0])
						cylinder(r = 0.8, h = 14, center = true);

		for (i = [-1, 1])
			translate([-2.5, 0, i * 5])
				rotate([90, 0, 0])
					hull()
						for (j = [-1, 1])
							translate([j * 2.5, 0, 0])
								cylinder(r = d_M3_screw / 2 + 0.25, h = 13, center = true);
	}
}

module template_linking_board(idler = false) {
	difference() {
		union() {
			rotate([0, -90, 0])
				mount_body(
					cc_mount = (idler) ? cc_idler_mounts : cc_motor_mounts,
					l_base_mount = 0,
					w_base_mount = 0,
					t_base_mount = 0,
					r_base_mount = 0,
					l_slot = 0,
					hole_count = 3,
					height = h_mount,
					nut_pocket = 0,
					w_mount = 5,
					echo = 1);

			translate([0, -20, 0]){
				for (i = [-1, 1])
					translate([i * (l_linking_board / 2 + 2), -l_linking_board / 2 + 4, 0])
						cube([4, 10, 5], center = true);

				translate([0, 0, -1.5])
					difference() {
						cube([l_linking_board, l_mount, 2], center = true);

						cube([l_linking_board - 10, l_mount, 2], center = true);
					}
			}
		}

		cube([l_mount + 1, 10, 10], center = true);
	}
}


module koios_apex(
	l_slot = 0,
	height_apex = h_clamp,
	height_tab = h_mount,
	cc_mount = cc_motor_mounts,
	base_mount = false,
	nut_pocket = 1
) {
	hull() {
		for (i = [-1, 1])
			translate([i * cc_mount / 2, 0, 0])
				cylinder(r = w_mount / 2, h = height_apex, center = true);
	}

	for (i = [-1, 1])
		translate([i * cc_mount / 2, 0, 0])
			rotate([0, 0, i * 30])
				mirror([(i < 0) ? i : 0, 0, 0])
					koios_mount(
						l_slot = l_slot,
						height_apex = height_apex,
						height_tab = height_tab,
						cc_mount = cc_mount,
						base_mount = base_mount,
						nut_pocket = nut_pocket,
						echo = i);
}

// kois has a different mount since the linking boards are flush on three tides of the motor and idler ends
// they'll need to be printed with support
module koios_mount(
	cc_mount,
	l_base_mount,
	w_base_mount,
	t_base_mount,
	r_base_mount,
	l_slot = 0,
	hole_count = 3,
	height_apex,
	height_tab,
	nut_pocket,
	w_mount = w_mount,
	echo) {

	// various radii and chord lengths
	a_arc_guides = asin(cc_guides / 2 / r_printer); // angle of arc between guide rods at r_printer
	a_sep_guides = 120 - 2 * a_arc_guides; // angle of arc between nearest rods on neighboring apexes
	//l_chord_guides = 2 * r_printer * sin(a_sep_guides / 2); // length of chord between nearest rods on neighboring apexes
	r_tower_center = pow(pow(r_printer, 2) - pow(cc_guides / 2, 2), 0.5); // radius to centerline of apex
	r_mount_pivot = pow(pow(r_tower_center, 2) + pow(cc_mount / 2, 2), 0.5); // radius to pivot point of apex mounts
	a_arc_mount = asin(cc_mount / 2 / r_mount_pivot);// angle subtended by arc struck between apex centerline and mount pivot point
	a_sep_mounts = 120 - 2 * a_arc_mount; // angle subtended by arc struck between mount pivot points on adjacent apexes
	l_chord_pivots = 2 * r_mount_pivot * sin(a_sep_mounts / 2); // chord length between adjacent mount pivot points
	// remove enough material from mount so that a logical length board can be cut to ensure adjacent mount pivot point chord lengths will yield a printer having r_printer
	l_brd = floor(l_chord_pivots / 10) * 10 - l_mount / 2; // length of the board that will be mounted between the apexs to yield r_printer
	l_pad_mount = (l_chord_pivots - l_brd) / 2;
	//l_boss_mount = l_mount - l_pad_mount;
	if (echo == 1) {
		//echo(str("Distance between nearest neighbor guide rods = ", l_chord_guides, "mm"));
		echo(str("Radius to centerline of tower = ", r_tower_center, "mm"));
		//echo(str("Radius to mount tab pivot = ", r_mount_pivot, "mm"));
		//echo(str("Distance between adjacent mount pivot points = ", l_chord_pivots, "mm"));
		echo(str("Length of linking board to yield printer radius of ", r_printer, "mm  = ", l_brd, "mm"));
		echo(str("Linking board tab thickness = ", height_tab, "mm"));
		echo(str("Linking board hole c-c = ", cc_mount_holes, "mm"));
		echo(str("Linking board hole offset from end = ", floor(l_pad_mount / 2), "mm"));
		//echo(str("Linking board-tab overlap = ", l_boss_mount, "mm"));
		echo(str("l_pad_mount = ", l_pad_mount));
	}

	difference() {
		hull() {
			cylinder(r = w_mount / 2, h = height_apex, center = true);

			translate([0, -l_mount + w_mount / 2, 0])
				cube([w_mount, w_mount, height_apex], center = true);
		}

		// relief for board between apexs
		translate([w_mount - 3, -l_mount / 2 - l_pad_mount, 0])
			cube([w_mount, l_mount, height_apex + 2], center = true);

		// chop top and bottom of tab portion
		if (height_apex > height_tab) {
			// top can just be chopped
			translate([0, -l_mount / 2 - l_pad_mount, height_apex / 2])
				cube([w_mount + 1, l_mount, height_apex - height_tab + 1], center = true);

			// bottom needs support - must do this here or slicer will fill guide rod pockets with support material
//			translate([-1.5, (l_mount - l_pad_mount + 1) / 2 - l_mount, -height_apex / 2])
//#				cube([w_mount - 4.5 + 8, l_mount - l_pad_mount - 0.5, height_apex - height_tab], center = true);

			translate([-1.5, (l_mount - l_pad_mount + 1) / 2 - l_mount, -height_apex / 2 + (height_apex - height_tab) / 4 + layer_height])
				cube([w_mount - 4.5, l_mount - l_pad_mount - 0.5, (height_apex - height_tab) / 2], center = true);

		}

		// screw holes to mount linking board
		translate([0, -l_mount / 2 - l_pad_mount + floor(l_pad_mount / 2), 0])
			if (hole_count == 4)
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([0, j * cc_mount_holes / 2, i * cc_mount_holes / 2]) {
							slot(l_slot = l_slot);

							if (nut_pocket != 0)
								translate([nut_pocket * (w_mount / 2 - 3), 0, 0])
									rotate([0, 90, 0])
										cylinder(r = d_M3_nut / 2, h = 2 * h_M3_nut, center = true, $fn = 6);
						}
			else if (hole_count == 3) {
				for (i = [-1, 1])
					translate([0, -cc_mount_holes / 2, i * cc_mount_holes / 2]) {
						slot(l_slot = l_slot);

						if (nut_pocket != 0)
							translate([nut_pocket * (w_mount / 2 - 3), 0, 0])
								rotate([0, 90, 0])
									cylinder(r = d_M3_nut / 2, h = 2 * h_M3_nut, center = true, $fn = 6);
					}

				translate([0, cc_mount_holes / 2, 0]) {
					slot(l_slot = l_slot);

					if (nut_pocket != 0)
						translate([nut_pocket * (w_mount / 2 - 3), 0, 0])
							rotate([0, 90, 0])
								cylinder(r = d_M3_nut / 2, h = 2 * h_M3_nut, center = true, $fn = 6);
				}
			}
	}
}

module koios_central_limit_switch(template = false) {
	l_switch_mount = 35;
	w_switch_mount = 14;
	h_switch_mount = 25;

	if (!template)
		difference() {
			cube([l_switch_mount, w_switch_mount, h_switch_mount], center = true);

			translate([-5, 3.5, 3])
				cube([l_switch_mount, w_switch_mount, h_switch_mount], center = true);

			translate([-11.5, 3.5, 0])
				cube([14, w_switch_mount, h_switch_mount + 1], center= true);

			// limit switch mounts
			translate([l_switch_mount / 2, 5, 3])
				rotate([0, 90, 0])
					for (i = [-1, 1])
						translate([i * cc_limit_mounts / 2, 0, 0])
							cylinder(r = 0.8, h = 14, center = true);

			for (i = [-1, 1])
				translate([-9, 0, i * 5])
					rotate([90, 0, 0])
						hull()
							for (j = [-1, 1])
								translate([j * 2.5, 0, 0])
									cylinder(r = d_M3_screw / 2 + 0.25, h = w_switch_mount + 1, center = true);
		}
	else
		difference() {
			cube([l_vertical_board + 6, h_switch_mount, 2], center = true);

			translate([0, 0, 1])
				cube([l_vertical_board + 1.5, h_switch_mount + 1, 2], center = true);

			// the switch and mounting holes are just about the same as the c-c of the motor mount screws:
			for (i = [-1, 1])
				translate([cc_NEMA17_mount / 2, i * 5, 0])
					cylinder(r = d_M3_screw / 2, h = 3, center = true);
		}

}

module leg_cap() {
	difference() {
		union() {
			hull() {
				translate([0, 0, -5.9])
					cube([l_vertical_board - 25.4 / 4 + 0.1, w_vertical_board - 25.4 / 4 + 0.1, 0.2], center = true);

				translate([0, 0, 5.9])
					cube([l_vertical_board - 25.4 / 4 - 0.25, w_vertical_board - 25.4 / 4 - 0.25, 0.2], center = true);
			}

			translate([0, 0, -6.8])
				cube([l_vertical_board, w_vertical_board, 2], center = true);
		}

		translate([0, 0, 5])
			rotate([90, 0, 0])
				cylinder(r = 5, h = w_vertical_board);

		translate([0, 0, 2])
			difference() {
				cube([l_vertical_board - 25.4 / 4 - 4, w_vertical_board - 25.4 / 4 - 4, 12], center = true);

				for (i = [-(l_vertical_board - 25.4 / 4) / 5, (l_vertical_board - 25.4 / 4) / 5])
					translate([i, 0, 0])
						cube([2, w_vertical_board - 25.4 / 4, 12], center = true);
			}
	}
}

module template_verticals(idler = true) {
	l_vertical = 538;
	l_printer = 512;

	difference() {
//		union() {
			translate([0, -(l_vertical - l_printer) / 4 - 1, 0])
				cube([l_vertical_board + 6, h_clamp + (l_vertical - l_printer) / 2 + 2, 2], center = true);

//			translate([0, (h_clamp + (l_vertical - l_printer) / 2) / 2, 0]) {
//				cube([l_vertical_board + 6, (l_vertical - l_printer) / 2, 2], center = true);

//				translate([0, (l_vertical - l_printer) / 4 + 2, 0])
//					cube([l_vertical_board + 6, 4, 2], center = true);
//			}
//		}

		translate([0, -(l_vertical - l_printer) / 4, 1])
			cube([l_vertical_board, h_clamp + (l_vertical - l_printer) / 2, 2], center = true);

		// wire passage
		translate([0, (idler) ? 0 : -h_clamp / 2 - 4, 0])
			cylinder(r = d_M3_screw / 2, h = 5, center = true);

		if (idler)
			rotate([90, 0, 0])
				koios_vertical_board_relief(length = w_clamp);
		else
			rotate([90, 0, 0])
				koios_vertical_board_relief(
					length = l_motor_cage,
					washer_inset = 1,
					v_spacing = 25
				);
	}
}

module connector_plate() {
	l_bbl_opening = 15; // length of barrel connector panel opening
	w_bbl_opening = 11.5; // width of barrel connector panel opening
	t_bbl_mount = 2; // thickness of the barrel connector mounting plate
	t_bbl_panel = 1.75; // thickness of the barrel connector panel (groove in barrel jack)
	l_bbl_body = l_bbl_opening + 2; // length of connector body
	w_bbl_body = w_bbl_opening + 2; // width of connector body
	h_bbl_case = 18; // height of the barrel connector case

	h_plate = 30; // tall enough for hooking into 12mm plywood

	l_rj45_housing = 36.5;
	w_rj45_housing = 22;
	w_rj45_jack = 14;
	l_rj45_jack = 16.5;
	top_offset_rj45_jack = 6;
	cc_rj45_mounts = 27.5;

	l_usb_housing = 38;
	w_usb_housing = 13;
	cc_usb_mounts = 28;
	l_usb_opening = 17;
	w_usb_opening = 9;
	r_plate_corners = 10;
	l_plate = 102; //l_rj45_housing + l_usb_housing + w_bbl_opening + 12;
	w_plate = 24; //w_rj45_housing + 2;

intersection() {
	difference() {
		cylinder(r = 150, h = h_plate, center = true);

		translate([0, 0, -2])
			cylinder(r = 147, h = h_plate, center = true);

		// barrel connector
		rotate([0, 0, 15])
			translate([148.5, 0, (h_plate - l_bbl_opening) / 2]) {
				cube([4, w_bbl_opening, l_bbl_opening + 1], center = true);

			translate([-13 - t_bbl_mount, 0, 0])
				cube([30, w_bbl_body, l_bbl_body + 2], center = true);
		}

		// rj45 jack
		translate([148.5, 0, h_plate - 33]) {
			cube([4, l_rj45_jack, w_rj45_jack], center = true);

			for (i = [-1, 1])
				translate([0, i * cc_rj45_mounts / 2, -1])
					rotate([0, 90, 0])
					cylinder(r = d_M3_screw / 2, h = h_plate + 2, center = true);
		}

		// usb jack
		rotate([0, 0, -16])
			translate([148.5, 0, h_plate - 34]) {
			for (i = [-1, 1])
				translate([0, i * cc_usb_mounts / 2, 0])
					rotate([0, 90, 0])
						cylinder(r = d_M3_screw / 2, h = h_plate + 2, center = true);

			cube([4, l_usb_opening, w_usb_opening], center = true);
		}
	}

	translate([150, 0, 0]) {
		difference() {
			cube([60, 310, h_plate + 1], center = true);

			for (i = [-20, 20])
				translate([-15, i, 0])
					cylinder(r =d_M3_screw / 2, h = h_plate + 1, center = true);
		}
	}
}
}


module anti_backlash_carriage() {
	difference() {
		union() {
			carriage_body(limit_switch_mount = false);

			// leadnut mount
			translate([0, 0, -h_carriage / 2])
				difference() {
					cylinder(r = r_leadnut_mounts + 3, h = 8);

					translate([-r_leadnut_mounts, - r_leadnut_mounts + y_web, -1])
						cube([2 * r_leadnut_mounts, r_leadnut_mounts, 10]);
				}
		}

		// relief for leadnut collar
		cylinder(r = d_leadscrew_collar / 2, h = h_carriage + 1, center = true); // pocket for screw

		// leadnut mount holes
		for (i = [0:2])
			rotate([0, 0, i * 90])
				translate([r_leadnut_mounts, 0, -h_carriage / 2 - 1])
					cylinder(r = d_screw_leadnut / 2, h = 10);

		translate([0, 0, 8])
			cube([100, 100, h_carriage], center = true);

		for (i = [-cc_guides / 2, cc_guides / 2])
			translate([i, 0, 0]) {
				hull()
					for (j = [0, 10])
						translate([0, j, 0])
							cylinder(r = d_guides / 2, h = h_carriage + 1, center = true);

				translate([0, 18, 0])
					cube([25, 25, h_carriage + 1], center = true);
			}
	}
}
