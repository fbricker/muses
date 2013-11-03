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

class VolumeControlBase extends flash.display.Sprite {
    var volume : Float;
    // Create a new VolumeControl
	var w:Int;
	var h:Int;
	var horizMargin:Int;
	var horizDesp:Int;
	var vertMargin:Int;
	var vertDesp:Int;
	var barStep:Int;
	var barWidth:Int;
	var bgColors:Array<UInt>;
	var barColors:Array<Int>;
	var spriteBar:flash.display.Sprite;
	var firstDraw:Bool;
	var mode:String;
	var holder:flash.display.MovieClip;

    public function new(){
		super();
		firstDraw=true;
		// Add event listener for click event
		addEventListener(flash.events.MouseEvent.MOUSE_DOWN, mouseDown);
		addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
		addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, mouseWheel);
		volume = 1.0;
		setMode('bars');
		draw(graphics);
    }
	
	function setMode(mode:String){
		switch(mode.toLowerCase()){
			case 'bars': draw=drawBars;
			case 'holder': draw=drawHolder;
			case 'vholder': draw=drawVHolder;
			default: draw=drawNone;
		}
		this.mode=mode;
	}

	function bgDraw(g : flash.display.Graphics){
		if(!firstDraw){
			return;
		}
		if(bgColors!=null){
			// Create a nice gradient
			var alphas : Array<Int> = [1, 1];
			var ratios : Array<Int> = [0, 255];
			var matrix : flash.geom.Matrix = new flash.geom.Matrix();
			
			matrix.createGradientBox(w, h, Math.PI/2, 0, 0);
			g.beginGradientFill(flash.display.GradientType.LINEAR, 
						bgColors,
						alphas,
						ratios, 
						matrix, 
						flash.display.SpreadMethod.PAD, 
						flash.display.InterpolationMethod.LINEAR_RGB, 
						0);

			// Draw the background
			g.drawRoundRect(0, 0, w+2, h+2, 5, 5);
			g.endFill();
		}else{
			var mc=new flash.display.MovieClip();
			mc.graphics.beginFill(0xffffff,0);
			mc.graphics.drawRoundRect(0, 0, w+2, h+2, 5, 5);
			mc.graphics.endFill();
			addChild(mc);
		}
		firstDraw=false;
	}
	
	dynamic function draw(g : flash.display.Graphics){}
    function drawNone(g : flash.display.Graphics){}

	function drawHolder(g : flash.display.Graphics){
		bgDraw(g);
		holder.x=volume*(w-holder.width)+holder.width/2;
	}

	function drawVHolder(g : flash.display.Graphics){
		bgDraw(g);
		holder.y=(1-volume)*(h-holder.height)+holder.height/2;
	}
	
    // Draw the volume control
    function drawBars(g : flash.display.Graphics){
		if(barColors==null || barStep==0){
			return;
		}
		bgDraw(g);
		var varCount=Math.round((w-horizMargin*2)/barStep);
		if(varCount==0){
			return;
		}
		var heightStep=(h-vertMargin*2+1)/varCount;
		
		var hComplete=h-vertMargin+vertDesp;
		var wComplete=horizMargin+horizDesp;
		
		// Draw vertical bars coloured according to the volume setting
		g.beginFill(barColors[0]);
		for (i in 0...Math.round(volume * varCount)){
			g.drawRect(wComplete+i*barStep, hComplete-i*heightStep, barWidth, i*heightStep);
		}
		
		g.endFill();
		g.beginFill(barColors[1]);
		for (i in Math.round(volume * varCount)...varCount){
			g.drawRect(wComplete+i*barStep, hComplete-i*heightStep, barWidth, i*heightStep);
		}
		g.endFill();
	}

	public function setVolume(v:Float){
		volume=v;
		if (volume > 1) volume = 1;
		if (volume < 0) volume = 0;
		draw(graphics);
		// Dispatch an event if there's a listener
		if (hasEventListener(ValueChangeEvent.VALUE_CHANGE)){
			dispatchEvent(new ValueChangeEvent(volume));
		}
	}
	
	public function getVolume():Float{
		return volume;
	}
	
	// Click event
	function mouseDown(e:flash.events.MouseEvent) {
		var margin:Float=0.06;
		var position:Float;
		var lenght:Float;
		
		if(mode != 'vholder'){
			position = e.localX;
			lenght = width;
		}else {
			position = height-e.localY;
			lenght = height;
		}
		
		position -= lenght * margin;
		if (position < 0) position = 0;
		position = Math.round(position * (1 + margin));
		if (position > lenght) position = lenght;
		setVolume(position / (lenght - 2));
    }
	
	function mouseMove(e:flash.events.MouseEvent) {
		if(e.buttonDown){
			mouseDown(e);
		}
    }	
	
	function mouseWheel(e:flash.events.MouseEvent) {
		if(e.delta > 0){
			setVolume(volume+0.025);
		}else{
			setVolume(volume-0.025);
		}
    }	
		
}
