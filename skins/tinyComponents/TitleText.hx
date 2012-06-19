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

		// Create a TextFormat for the embedded font

		var format : TextFormat = new TextFormat();
		
		format.align = TextFormatAlign.CENTER;
		format.font = "Silkscreen";
		format.size = 11;
			
		embedFonts = true;
		defaultTextFormat = format;
    }
}
