package skins.tinyComponents;

class VolumeControl extends VolumeControlBase {
	public function new(){
		this.w=40;
		this.h=25;
		this.horizMargin=0;
		this.horizDesp=0;
		this.vertMargin=3;
		this.vertDesp=1;
		this.barStep=2;
		this.barWidth=1;
		bgColors = [0xCCDDEB, 0x96BFDA];
		barColors = [0x000000, 0xfffddd];		
		super();
	}

}