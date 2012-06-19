package skins.configurableComponents;
import skins.Configurable;

class StatusLed extends flash.display.MovieClip {
	var playMC:flash.display.MovieClip;
	var stopMC:flash.display.MovieClip;
	
    public function new() {
		super();
		playMC = new flash.display.MovieClip();	
		stopMC = new flash.display.MovieClip();	
		addChild(playMC);
		addChild(stopMC);
		playMC.visible=false;
		stopMC.visible=true;
    }
	
	public function configure(skin: skins.Configurable, elem:Xml){
		x=Configurable.parseInt(elem.get('x'),0);
		y=Configurable.parseInt(elem.get('y'),0);
		if(elem.get('imageplay')!=null){
			playMC.addChild(skin.loadImage(elem.get('imageplay')));
		}
		if(elem.get('imagestop')!=null){
			stopMC.addChild(skin.loadImage(elem.get('imagestop')));
		}
	}
	
	public function on(){
		playMC.visible=true;
		stopMC.visible=false;
	}
	
	public function off(){
		playMC.visible=false;
		stopMC.visible=true;
	}
		
}