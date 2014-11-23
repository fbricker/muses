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

import flash.net.URLRequest;
import aac.AACSound;

class AacPlayer extends Player {
	
	var sound(default,null): AACSound;
	
	public function new(ui:UI,url:String,tracker:Tracker,fallbackUrl:String,introUrl:String){
		super(ui,url,tracker,fallbackUrl,introUrl,0);
		fileextension="aac";
	}	
	
	override function createSoundObject(){
		sound=new AACSound(getUrl());
		soundObject = sound;
		// this wont happen until icecast and shoutcast accepts Icy Metadata as a get parameter
		//sound.addEventListener(MetadataEvent.METADATA_EVENT,setMetadata);
	}
	
	override function closeSound() {
		if(sound!=null){
			Reflect.deleteField(this,'sound');
			sound=null;
		}
		soundObject=null;
	}
	
	override function loadSound(request:flash.net.URLRequest){
		return;
	}

	override function getProgress() : Float {
		return sound.getProgress() + sound.getBufferLength();
	}
	
	override function startSound(){
		if (sound != null) {
			sound.setBufferingTime(buffering);
			sound.play();
			trafficControl(null);
		}
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
		super.stop();
	}
	
}