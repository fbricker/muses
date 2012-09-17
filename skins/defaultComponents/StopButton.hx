////////////////////////////////////////////////////////////////////////////////
//
//  Muses Radio Player - Radio Streaming player written in Haxe.
//
//  Copyright (C) 2009-2012  Federico Bricker
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  This Project was initially based on FOggPlayer by Bill Farmer. So 
//  my special thanks to him! :)
//
//  Federico Bricker  f bricker [at] gmail [dot] com.
//
////////////////////////////////////////////////////////////////////////////////
package skins.defaultComponents;

class StopButton extends Button{
    // Create a new StopButton
    public function new() {
		super();
		draw();
    }

    // Draw the button
    override function draw() {
		// Array of pointers (sorry, not allowed to say that) to
		// ButtonState graphic objects

		var ag : Array<flash.display.Graphics> = 
			[cast(downState, ButtonState).graphics,
			 cast(hitTestState, ButtonState).graphics,
			 cast(overState, ButtonState).graphics,
			 cast(upState, ButtonState).graphics];

		// Draw the button shaded background
		super.draw();

		// Draw the button symbol on all four ButtonStates
		for (i in 0...ag.length) {
			var g : flash.display.Graphics = ag[i];
			g.beginFill(0x404040);
			g.drawRect(5, 5, 11, 11);
			g.endFill();
		}
    }
}
