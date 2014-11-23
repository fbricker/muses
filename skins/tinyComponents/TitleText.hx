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
package skins.tinyComponents;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

// TitleText class

class TitleText extends TextField
{
    // Create a new TitleText

    public function new(){
		super();

		// Set the dimensions

		height = 14;
		width = 120;
			
		selectable = false;
		createTextFormat('play');
    }
    
    public function createTextFormat(testString:String){
		// Create a TextFormat for the embedded font
		var format : flash.text.TextFormat = new flash.text.TextFormat();

		format.font = "Silkscreen";
		format.size = 11;
		format.align = TextFormatAlign.CENTER;
		defaultTextFormat = format;
		embedFonts = true;

		var auxText=text;
		text=testString;
		if(this.textWidth==0){
			y-=1;
			embedFonts=false;
		}
		text=auxText;
    }

}
