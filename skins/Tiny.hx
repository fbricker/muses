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
package skins;
import skins.tinyComponents.PlayButton;
import skins.tinyComponents.StopButton;
import skins.tinyComponents.TitleText;
import skins.tinyComponents.VolumeControl;
import flash.accessibility.AccessibilityProperties;

class Tiny extends UI {
	var playButton    : PlayButton;
	var stopButton    : StopButton;

	public function new(){
		super();
		// Create the buttons and volume control
		playButton    = new PlayButton();
		stopButton    = new StopButton();
		volumeControl = new VolumeControl();
		
		// This helps blind or print-impaired users, some of whom use Screen Reader software (like JAWS)
		playButton.accessibilityProperties = new AccessibilityProperties();
		playButton.accessibilityProperties.name = 'Play Button';
		stopButton.accessibilityProperties = new AccessibilityProperties();
		stopButton.accessibilityProperties.name = 'Stop Button';
		
		// And the text field
		titleText = new TitleText();

		// Position the buttons etc
		playButton.x = 10;
		playButton.y = 27;
		stopButton.x = playButton.width + 22;
		stopButton.y = 27;
		volumeControl.y = 27;
		volumeControl.x = playButton.x + stopButton.x + 24;
		titleText.y = 6;
		titleText.x = 5;
		titleText.width = 120;
		
		draw(this.graphics);
		
		addChild(playButton);
		addChild(stopButton);
		addChild(titleText);
		addChild(volumeControl);
	}
	
	 function OffLed(){
		// Draw OFF led
		var g = this.graphics;
		g.lineStyle(1,0xc0c0c0);
		g.beginFill(0xc0c0c0);
		g.drawCircle(40.5,29,4);
		g.lineStyle(1,0x666666);
		g.beginFill(0xdd0000);
		g.drawCircle(40.5,29,3);
	}
	
	function OnLed(){
		// Draw ON led
		var g = this.graphics;
		g.lineStyle(1,0xc0c0c0);
		g.beginFill(0xc0c0c0);
		g.drawCircle(40.5,29,4);
		g.lineStyle(1,0x666666);
		g.beginFill(0x00cc00);
		g.drawCircle(40.5,29,3);
	}
	
	override public function setStatus(status:PlayerStatus, autorestore:Bool = true) {
		super.setStatus(status, autorestore);
		if(status==PlayerStatus.play){
			OnLed();
		}else{
			OffLed();
		}
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
		// draw a SQUARE background
		g.lineStyle(2,0x666666);
		g.beginFill(0x333333);
		g.drawRoundRect(1, 1, 128, 58, 10, 10);

		// Draw ON OFF Led
		OffLed();

		// draw a PLAY shadow circle
		g.lineStyle(4,0xc0c0c0);
		g.beginFill(0xc0c0c0);
		g.drawCircle(21,41,14);

		// draw a PLAY circle
		g.lineStyle(1,0x000000);
		g.beginFill(0x00CC00);
		g.drawCircle(21,41,14);

		// draw a STOP shadow circle
		g.lineStyle(4,0xc0c0c0);
		g.beginFill(0xc0c0c0);
		g.drawCircle(60,41,14);

		// draw a STOP circle
		g.lineStyle(1,0x000000);
		g.beginFill(0xdd0000);
		g.drawCircle(60,41,14);

		// draw a VOLUME shadow rect
		g.lineStyle(2,0xc0c0c0);
		g.beginFill(0xc0c0c0);
		g.drawRoundRect(80, 25, 46, 31, 5, 5);

		// draw a VOLUME rect
		g.lineStyle(2,0x666666);
		g.beginFill(0xc0c0c0);
		g.drawRoundRect(81, 26, 44, 29, 5, 5);

		// draw a TITLE shadow rect
		g.lineStyle(2,0xc0c0c0);
		g.beginFill(0xc0c0c0);
		g.drawRoundRect(4, 4, 122, 18, 5, 5);

		// draw a TITLE rect
		g.lineStyle(2,0x666666);
		g.beginFill(0xCEDEEC);
		g.drawRoundRect(5, 5, 120, 16, 5, 5);
    }

	override public function setLanguage(lang:internationalization.AbstractLanguage){
		super.setLanguage(lang);
		cast(this.titleText,TitleText).createTextFormat(lang.getText('play'));
	}
}