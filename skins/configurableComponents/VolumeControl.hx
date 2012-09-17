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
import skins.Configurable;

class VolumeControl extends VolumeControlBase {
	var hImg:flash.display.Loader;
	
	public function new(){
		this.w=0;
		this.h=0;
		this.horizMargin=0;
		this.vertMargin=0;
		this.barStep=2;
		this.barWidth=1;
		bgColors = null;
		barColors = null;
		super();
	}
	
	public function configure(skin: skins.Configurable, elem:Xml){
		x=Configurable.parseInt(elem.get('x'),0);
		y=Configurable.parseInt(elem.get('y'),0);
		w=Configurable.parseInt(elem.get('width'),0);
		h=Configurable.parseInt(elem.get('height'),0);
		barColors = [skins.Configurable.parseColor(elem.get('color1')), skins.Configurable.parseColor(elem.get('color2'))];
		barStep=Configurable.parseInt(elem.get('barstep'),2);
		barWidth=Configurable.parseInt(elem.get('barwidth'),1);
		var mode=(elem.get('mode')!=null)?elem.get('mode').toLowerCase():null;
		setMode(mode);
		if(mode=='holder' || mode=='vholder' ){		
			hImg=skin.loadImage(elem.get('holderimage'));
			hImg.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,holderLoad);
			holder=new flash.display.MovieClip();
			holder.addChild(hImg);
			this.addChild(holder);
			holder.visible=false;
		}
		draw(graphics);
	}
	
	private function holderLoad(e:flash.events.Event){
		holder.visible=true;
		holder.y=h/2;
		holder.x=w/2;
		hImg.x=-1*hImg.width/2;
		hImg.y=-1*hImg.height/2;
		holder.visible=true;
		draw(graphics);
	}
}