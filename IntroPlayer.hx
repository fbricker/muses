////////////////////////////////////////////////////////////////////////////////
//
//  Muses Radio Player - Radio Streaming player written in Haxe.
//
//  Copyright (C) 2009-2012  Federico Bricker
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
import flash.events.Event;
import flash.utils.Timer;

class IntroPlayer {
	var sound : flash.media.Sound;
    var channel : flash.media.SoundChannel;
	var internalTimer : Timer;
	var request   : flash.net.URLRequest;
	var volume : Float;
	var streamingPlayer : Player;
	  
	public function new(url:String, splayer:Player){
		channel=null;
		streamingPlayer = splayer;
		if (url == '') return;
		sound=new flash.media.Sound();
		request = new flash.net.URLRequest(url);
		var sc:flash.media.SoundLoaderContext=new flash.media.SoundLoaderContext(5000,false); 
		sound.load(request, sc);
		volume = 1;
	}
	
	public function startSound(){
		if (sound == null) {
			streamingPlayer.playSound();
			return;
		}
		if(channel==null){
			channel = sound.play();
			channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			setVolume(volume);
			streamingPlayer.reportIntro();
		}
	}
	
	public function stopSound(){
		if(channel!=null){
			channel.stop();
			channel = null;
		}
	}
	
	public function setVolume(volume:Float){
		this.volume = volume;
		if (channel != null){
			var transform = channel.soundTransform;
			transform.volume = volume;
			channel.soundTransform = transform;
		}
	}
	
    function soundComplete(e){
		stopSound();
		streamingPlayer.playSound();
	}

}