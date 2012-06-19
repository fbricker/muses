package skins.tinyComponents;

import flash.geom.Matrix;
import flash.display.Shape;
import flash.display.Graphics;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.InterpolationMethod;

// ButtonState class

class ButtonState extends Shape
{
    // The state of this particular ButtonState

    var state : FFMp3ButtonStates;

    // Create a new ButtonState

    public function new(s : FFMp3ButtonStates)
    {
	super();
	state = s;
    }

    // Draw the shape

    public function draw()
    {
	var g : Graphics = graphics;

	// Create a nice gradient

	var w:Int = 26;
	var h:Int = 26;
	var colors : Array<Int> = [];
	var alphas : Array<Int> = [1, 1];
	var ratios : Array<Int> = [0, 255];
	var matrix : Matrix = new Matrix();

	// Change the colours according to the state


//	switch (state)
//	{
//	case over:
//	    colors = [0xF0F0F0, 0xA0A0A0];
//	case down:
//	    colors = [0xA0A0A0, 0xF0F0F0];
//	case out:
//	    colors = [0xD0D0D0, 0xB0B0B0];
//	}

	// Create a gradient

	matrix.createGradientBox(w-2, h-2, Math.PI/2, 0, 0);
	g.beginGradientFill(GradientType.LINEAR, 
			    colors,
			    alphas,
			    ratios, 
			    matrix, 
			    SpreadMethod.PAD, 
			    InterpolationMethod.LINEAR_RGB, 
			    0);

	// Draw the button

	g.drawRoundRect(0, 0, w, h, 10, 10);
	g.endFill();

	// Add the drop-shadow filter. We don't want one
	// because the buttons are adjacent, and the full
	// height of the frame.

// 	var shadow : DropShadowFilter = new
// 	    DropShadowFilter(4, 45, 0x000000, 0.8, 4, 4, 0.65,
// 			     BitmapFilterQuality.HIGH, false, false);
// 	var af : Array<DropShadowFilter> = new Array();
// 	af.push(shadow);
// 	filters = af;
    }
}
