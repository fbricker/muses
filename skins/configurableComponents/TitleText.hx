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
import flash.text.TextFormatAlign;
import skins.Configurable;

class TitleText extends flash.text.TextField{
    public function new(){
		super();
		// Set the dimensions
		height = 15;
		width = 250;	
		selectable = false;
		// Create a TextFormat for the embedded font

		var format : flash.text.TextFormat = new flash.text.TextFormat();

		format.font = "Silkscreen";
		format.size = 12;
			
		embedFonts = true;
		defaultTextFormat = format;
    }
	
	public function configure(skin: skins.Configurable, elem:Xml){
		x=Configurable.parseInt(elem.get('x'),0);
		y=Configurable.parseInt(elem.get('y'),0);
		width=Configurable.parseInt(elem.get('width'),0);
		height = Configurable.parseInt(elem.get('height'), 0);
		var align : String = elem.get('align');
		var format : flash.text.TextFormat = new flash.text.TextFormat();
		
		format.align = switch(align) {
			case 'center': TextFormatAlign.CENTER;
			case 'right': TextFormatAlign.RIGHT;
			default : TextFormatAlign.LEFT;
		}
		format.font = elem.get('font');
		format.size = Configurable.parseInt(elem.get('size'),12);
		format.color = Configurable.parseColor(elem.get('color'));
		embedFonts = (elem.get('font')=="Silkscreen")?true:false;
		defaultTextFormat = format;
		this.text = this.text + "";
	}
}
