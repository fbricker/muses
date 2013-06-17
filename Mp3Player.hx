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
import flash.errors.EvalError;
import flash.utils.Timer;

class Mp3Player extends Player {
	var sound : flash.media.Sound;
    var channel   : flash.media.SoundChannel;
	var oldPlayingChannel : flash.media.SoundChannel;
	var oldPlayingPosition : Float;
	var switchChannelTimer : Timer;
	
	public function new(ui:UI,url:String,tracker:Tracker,fallbackUrl:String,introUrl:String,reconnectTime:Int){
		super(ui,url,tracker,fallbackUrl,introUrl,reconnectTime);
		switchChannelTimer = new Timer(100, 1);
		switchChannelTimer.addEventListener(flash.events.TimerEvent.TIMER, switchChannels);
	}
	
	override function createSoundObject(){
		sound=new flash.media.Sound();
		soundObject=sound;
	}
	
	override function closeSound() {
		sound.close();
		Reflect.deleteField(this,'sound');
		sound = null;
		soundObject = null;
	}
	
	override function loadSound(request:flash.net.URLRequest){
		var sc:flash.media.SoundLoaderContext=new flash.media.SoundLoaderContext(buffering*1000,false); // set the buffering time in seconds.
		sound.load(request,sc);
	}

	override function startSound() {
		channel = sound.play();
		trafficControl();
	}
	
	override function soundLength():Float{
		return sound.length;
	}
	
	override function getProgress() : Float {
		return sound.bytesLoaded;
	}
	
	override private function updateVolume(){
		// Set the volume, if the channel isn't null
		if (channel != null){
			var transform = channel.soundTransform;
			transform.volume = volume;
			channel.soundTransform = transform;
		}
	}

	override function soundOpen(e : OpenEvent){
		channel = e.channel;
		super.soundOpen(e);
    }
	
	override function stop(){
		trafficControlTimer.stop();
		if(!playBuffer){
			stopOldChannel(); // this goes here in order to stop an old buffer if the users presses STOP button.
		}
		if (channel != null){
			if(!playBuffer){
				channel.stop();
			}else{
				switchChannels();
			}
			channel = null;			
			super.stop();
		}
		ui.setStatus(PlayerStatus.stop);
		playBuffer=false;
	}
	
	function stopOldChannel(){
		if(oldPlayingChannel!=null){
			oldPlayingChannel.stop();
			oldPlayingChannel=null;
		}
	}
	
	function playingOldChannel():Bool{
		if(oldPlayingChannel==null){
			return false;
		}
		if(oldPlayingPosition==oldPlayingChannel.position){
			return false;
		}
		oldPlayingPosition=oldPlayingChannel.position;
		return true;
	}
	
	function setOldChannel(){
		stopOldChannel();
		oldPlayingChannel=channel;
		oldPlayingPosition=oldPlayingChannel.position;
	}
		
	function switchChannels(e=null){
		if(e==null){
			if(oldPlayingChannel!=null) return;
			setOldChannel();
		}else{
			if(sound!=null && playing && !sound.isBuffering && sound.bytesLoaded > 0){
				stopOldChannel();
				return;
			}
			if(!playingOldChannel()){
				stopOldChannel();
				return;
			}
		}
		switchChannelTimer.reset();
		switchChannelTimer.start();
	}
	
	override function isBuffering(){
		return sound!=null && sound.isBuffering;
	}

	override function forceSynchronization() {
		var oc = channel;
		channel = sound.play(oc.position+128);
		oc.stop();
		updateVolume();
	}
}