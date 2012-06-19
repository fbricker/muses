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
