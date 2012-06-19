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
		}
		channel = null;
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
		if(channel!=null){
			channel.stop();
		}
		streamingPlayer.playSound();
	}

}