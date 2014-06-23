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
package skins.configurableComponents;
import ButtonStates;
import flash.events.MouseEvent;
import skins.Configurable;

class Button extends flash.display.MovieClip {
	var mouseOverState:flash.display.MovieClip;
	var mouseDownState:flash.display.MovieClip;
	var noMouseState:flash.display.MovieClip;
	
    public function new() {
		super();
		mouseOverState = new flash.display.MovieClip();	
		mouseDownState = new flash.display.MovieClip();
		noMouseState = new flash.display.MovieClip();	
		addChild(noMouseState);
		addChild(mouseDownState);
		addChild(mouseOverState);
		mouseDownState.visible=false;
		mouseOverState.alpha=0;
		addEventListener(MouseEvent.MOUSE_UP   ,updateStatus);
		addEventListener(MouseEvent.MOUSE_OUT  ,updateStatus);
		addEventListener(MouseEvent.MOUSE_OVER ,updateStatus);
		addEventListener(MouseEvent.MOUSE_DOWN ,updateStatus);
    }
	
	public function updateStatus(e:MouseEvent){
		switch(e.type){
			case MouseEvent.MOUSE_UP: 
				mouseDownState.visible=false;
				mouseOverState.alpha=1;
			case MouseEvent.MOUSE_DOWN: 
				mouseDownState.visible=true;
				mouseOverState.alpha=0;
			case MouseEvent.MOUSE_OVER:
				mouseOverState.alpha=1;
				noMouseState.alpha=0;
				noMouseState.visible=false;
			case MouseEvent.MOUSE_OUT:
				mouseOverState.alpha=0;
				mouseDownState.visible=false;
				noMouseState.alpha=1;
				noMouseState.visible=true;
			default:
		}
	}
	
	public function configure(skin: skins.Configurable, elem:Xml){
		x=Configurable.parseInt(elem.get('x'),0);
		y=Configurable.parseInt(elem.get('y'),0);
		mouseOverState.addChild(skin.loadImage(elem.get('image')));
		if(elem.get('clickimage')!=null){
			mouseDownState.addChild(skin.loadImage(elem.get('clickimage')));
		}
		if(elem.get('bgimage')!=null){
			noMouseState.addChild(skin.loadImage(elem.get('bgimage')));
		}
	}
	
}
