/************************************************************************************

koios_renderer.scad - renders components of the Koios delta platform, requires koios.scad
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

include<koios.scad>

render_part(part_to_render = 99);

module render_part(part_to_render) {
	if (part_to_render == 0) koios_end_motor();

	if (part_to_render == 1) koios_end_idler();

	if (part_to_render == 2) koios_carriage();

	if (part_to_render == 3) idler_spacer();

	if (part_to_render == 4) motor_bar_clamp();

	if (part_to_render == 5) bar_clamp();

	if (part_to_render == 6) rotate([90, 0, 0]) koios_limit_switch_mount();

	if (part_to_render == 7) template_linking_board(idler = false);

	if (part_to_render == 8) koios_central_limit_switch(template = true);

	if (part_to_render == 9) template_verticals(idler = false);

	if (part_to_render == 10) leg_cap();

	if (part_to_render == 11) connector_plate();

	if (part_to_render == 12) anti_backlash_carriage();

	if (part_to_render == 99) sandbox();
}

module sandbox() {
	difference() {
		leg_cap();

		for (i = [-1.7, -0.6, 0.6, 1.7])
			translate([i * ((l_vertical_board - 25.4 / 4) / 2 - 5) / 2, 0, 0])
				cylinder(r = 2, h = 30, center = true);
	}
}
