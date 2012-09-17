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
	var autoState:flash.display.MovieClip;
	var downState:flash.display.MovieClip;
	
    public function new() {
		super();
		autoState = new flash.display.MovieClip();	
		downState = new flash.display.MovieClip();	
		addChild(downState);
		addChild(autoState);
		downState.visible=false;
		autoState.alpha=0;
		addEventListener(MouseEvent.MOUSE_UP   ,updateStatus);
		addEventListener(MouseEvent.MOUSE_OUT  ,updateStatus);
		addEventListener(MouseEvent.MOUSE_OVER ,updateStatus);
		addEventListener(MouseEvent.MOUSE_DOWN ,updateStatus);
    }
	
	public function updateStatus(e:MouseEvent){
		switch(e.type){
			case MouseEvent.MOUSE_UP: 
				downState.visible=false;
				autoState.alpha=1;
			case MouseEvent.MOUSE_DOWN: 
				downState.visible=true;
				autoState.alpha=0;
			case MouseEvent.MOUSE_OVER:
				autoState.alpha=1;
			case MouseEvent.MOUSE_OUT:
				autoState.alpha=0;
				downState.visible=false;
			default:
		}
	}
	
	public function configure(skin: skins.Configurable, elem:Xml){
		x=Configurable.parseInt(elem.get('x'),0);
		y=Configurable.parseInt(elem.get('y'),0);
		autoState.addChild(skin.loadImage(elem.get('image')));
		if(elem.get('clickimage')!=null){
			downState.addChild(skin.loadImage(elem.get('clickimage')));
		}
	}
	
}
