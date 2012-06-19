package skins.defaultComponents;
import FFMp3ButtonStates;

class Button extends flash.display.SimpleButton {
	
    // Create a new button
    public function new() {
		super();
		useHandCursor = false;
		enabled = false;
		// Create shapes to show the button graphics
		downState = new ButtonState(down);
		hitTestState = new ButtonState(out);
		overState = new ButtonState(over);
		upState = new ButtonState(out);
    }

    // Draw the button graphics, this gets called from the instances of the button

    public function draw(){
		cast(downState, ButtonState).draw();
		cast(hitTestState, ButtonState).draw();
		cast(overState, ButtonState).draw();
		cast(upState, ButtonState).draw();
    }
}
