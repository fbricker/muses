package skins.defaultComponents;

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
}
