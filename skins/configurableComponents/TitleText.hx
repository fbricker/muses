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
