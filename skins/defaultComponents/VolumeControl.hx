package skins.defaultComponents;

class VolumeControl extends VolumeControlBase {
	public function new(){
		this.w=25;
		this.h=13;
		this.horizMargin=0;
		this.vertMargin=0;
		this.barStep=2;
		this.barWidth=1;
		bgColors = [0xffffff, 0xd0d0d0];
		barColors = [0x303030, 0xc0c0c0];
		super();
	}
}