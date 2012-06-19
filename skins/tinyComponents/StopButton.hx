package skins.tinyComponents;

import flash.display.Graphics;

// StopButton class

class StopButton extends Button
{
    // Create a new StopButton

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
	    g.drawRect(4, 6, 16, 16);
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
    g.beginFill(0xaa0000);
    g.drawCircle(12,14,14);
      g.lineStyle(1,0x333333);
	    g.beginFill(0xee0000);
	    g.drawRect(4, 6, 16, 16);
	    g.endFill();
	}
    }
}
