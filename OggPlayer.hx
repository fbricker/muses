////////////////////////////////////////////////////////////////////////////////
//
//  Muses Radio Player - Radio Streaming player written in Haxe.
//
//  Copyright (C) 2009-2013  Federico Bricker
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
import flash.utils.Timer;

class OggPlayer extends Player {
	
	var sound(default,null): OGGSound;

    static function init_statics() : Void {
        org.xiph.fogg.Buffer._s_init();
        org.xiph.fvorbis.FuncFloor._s_init();
        org.xiph.fvorbis.FuncMapping._s_init();
        org.xiph.fvorbis.FuncTime._s_init();
        org.xiph.fvorbis.FuncResidue._s_init();
    }
	
	public function new(ui:UI,url:String,tracker:Tracker,fallbackUrl:String,introUrl:String){
		init_statics();
		super(ui,url,tracker,fallbackUrl,introUrl,0);
		fileextension="ogg";
	}

	override function getProgress() : Float {
		return sound.getPosition();
	}
	
	override function createSoundObject(){
		sound = new OGGSound();
		soundObject=sound;
		sound.addEventListener(MetadataEvent.METADATA_EVENT,setMetadata);
	}
	
	override function closeSound(){
		if(sound!=null){
			sound.close();
			Reflect.deleteField(this,'sound');
			sound=null;
		}
		Reflect.deleteField(this,'soundObject');
		soundObject=null;
	}
	
	override function loadSound(request:flash.net.URLRequest){
		if(sound!=null){
			sound.load(request);
		}
	}
	
	override function startSound(){
		if (sound != null) {
			sound.play();
			trafficControl(null);
		}
	}
	
	override function soundLength():Float{
		return sound.length;
	}
	
	override private function updateVolume(){
		if(sound!=null){
			sound.setVolume(volume);
		}
	}
	
	override private function setMetadata(e:MetadataEvent){
		ui.setMetadata(e.value);
	}
	
	override public function stop(){
		if(sound!=null){
			sound.stop();
		}
		trafficControlTimer.stop();
		super.stop();
	}
	
}