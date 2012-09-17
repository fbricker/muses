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

class ButtonState extends flash.display.Shape {
    // The state of this particular ButtonState

    var state : ButtonStates;
    // Create a new ButtonState

    public function new(s : ButtonStates)    {
		super();
		state = s;
    }

    // Draw the shape
    public function draw() {
		var g : flash.display.Graphics = graphics;
		// Create a nice gradient
		var w:Int = 21;
		var h:Int = 21;
		var colors : Array<Int> = [];
		var alphas : Array<Int> = [1, 1];
		var ratios : Array<Int> = [0, 255];
		var matrix : flash.geom.Matrix = new flash.geom.Matrix();

		// Change the colours according to the state
		switch (state) {
			case over: colors = [0xF0F0F0, 0xA0A0A0];
			case down: colors = [0xA0A0A0, 0xF0F0F0];
			case out: colors = [0xD0D0D0, 0xB0B0B0];
		}

		// Create a gradient

		matrix.createGradientBox(w-2, h-2, Math.PI/2, 0, 0);
		g.beginGradientFill(flash.display.GradientType.LINEAR,colors,alphas,ratios,matrix,flash.display.SpreadMethod.PAD,flash.display.InterpolationMethod.LINEAR_RGB,0);

		// Draw the button
		g.drawRoundRect(0, 0, w, h, 5, 5);
		g.endFill();
	}
}
