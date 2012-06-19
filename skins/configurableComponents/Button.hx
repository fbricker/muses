package skins.configurableComponents;
import FFMp3ButtonStates;
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
