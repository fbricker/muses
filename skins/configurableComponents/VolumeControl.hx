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