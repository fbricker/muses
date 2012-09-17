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
package skins.tinyComponents;
import flash.display.Graphics;

// PlayButton class

class PlayButton extends Button
{
    // Create a new PlayButton

    public function new()
    {
	super();
	draw();
	overdraw();
    }

    // Draw the button

    override function draw()
    {
	// Array of pointers (sorry, not allowed to say that) to
	// ButtonState graphic objects

	var ag : Array<Graphics> = 
	    [cast(hitTestState, ButtonState).graphics,
       cast(upState, ButtonState).graphics];
	// Draw the button shaded background
	super.draw();
	// Draw the button symbol on HIT and UP ButtonStates
	for (i in 0...ag.length)
	{
	    var g : Graphics = ag[i];
	    g.beginFill(0x000000);
	    g.moveTo(5, 5);
	    g.lineTo(22, 14);
	    g.lineTo(4, 24);
	    g.lineTo(4, 4);
	    g.endFill();
	}
    }
    function overdraw()
    {
	// ButtonState graphic objects
	var ag : Array<Graphics> = 
	    [cast(downState, ButtonState).graphics,
	     cast(overState, ButtonState).graphics];
	// Draw the button shaded background
	super.draw();
	// Draw the button symbol on OVER and DOWN ButtonState
	for (i in 0...ag.length)
	{
	    var g : Graphics = ag[i];
    // draw a PLAY circle
    g.lineStyle(1,0x333333);
    g.beginFill(0x006600);
    g.drawCircle(11,14,14);
	    g.beginFill(0x00cc00);
	    g.moveTo(5, 5);
	    g.lineTo(22, 14);
	    g.lineTo(4, 24);
	    g.lineTo(4, 4);
	    g.endFill();
	}
    }
}
