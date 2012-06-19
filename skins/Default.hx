package skins;
import skins.defaultComponents.PlayButton;
import skins.defaultComponents.StopButton;
import skins.defaultComponents.VolumeControl;
import skins.defaultComponents.TitleText;

class Default extends UI {
	var playButton    : PlayButton;
	var stopButton    : StopButton;

	public function new(){
		super();
		// Create the buttons and volume control
		playButton    = new PlayButton();
		stopButton    = new StopButton();
		volumeControl = new VolumeControl();
		
		// And the text field
		titleText = new TitleText();

		// Position the buttons etc
		stopButton.x = playButton.width;
		titleText.x = stopButton.x + stopButton.width + 4;
		titleText.y = 3;
		volumeControl.x = titleText.x + titleText.width + 3;
		volumeControl.y = 3;
		
		addChild(playButton);
		addChild(stopButton);
		addChild(titleText);
		addChild(volumeControl);
		draw(this.graphics);
	}
	
	public override function enable(player:Player){
		playButton.enabled = true;
		stopButton.enabled = true;
		playButton.addEventListener(flash.events.MouseEvent.CLICK, player.playSound);
		stopButton.addEventListener(flash.events.MouseEvent.CLICK, player.stopSound);
		volumeControl.addEventListener(ValueChangeEvent.VALUE_CHANGE,player.changeVolume);		
	}
	
	 // Draw the frame background
    public function draw(g : flash.display.Graphics){
		// Set up a nice gradient for the right hand end of the frame
		// to look concave
		var colors : Array<Int> = [0xA0A0A0, 0xF0F0F0];
		var alphas : Array<Int> = [1, 1];
		var ratios : Array<Int> = [0, 255];
		var matrix : flash.geom.Matrix = new flash.geom.Matrix();

		matrix.createGradientBox(285, 19, Math.PI/2, 0, 0);
		g.beginGradientFill(flash.display.GradientType.LINEAR, 
					colors,
					alphas,
					ratios, 
					matrix, 
					flash.display.SpreadMethod.PAD, 
					flash.display.InterpolationMethod.LINEAR_RGB, 
					0);

		// Draw the frame background
		g.drawRoundRect(titleText.x - 4, 0, 287, 21, 5, 5);
		g.endFill();

		// Change the colours for the text field background, and set up another gradient
		colors = [0xffffff, 0xd0d0d0];
		matrix.createGradientBox(titleText.width - 2,
					 titleText.height - 2,
					 Math.PI/2, 0, 0);

		g.beginGradientFill(flash.display.GradientType.LINEAR, 
					colors,
					alphas,
					ratios, 
					matrix, 
					flash.display.SpreadMethod.PAD, 
					flash.display.InterpolationMethod.LINEAR_RGB, 
					0);
		// Draw the text field background
		g.drawRoundRect(titleText.x, titleText.y,titleText.width, titleText.height, 5, 5);
    }
}