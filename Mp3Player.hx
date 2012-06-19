import flash.errors.EvalError;
import flash.utils.Timer;

class Mp3Player extends Player {
	var sound : flash.media.Sound;
    var channel   : flash.media.SoundChannel;
	var oldPlayingChannel : flash.media.SoundChannel;
	var oldPlayingPosition : Float;
	var switchChannelTimer : Timer;
	var trafficControlTimer : Timer;
	var lastByteCount:UInt;
	
	public function new(ui:UI,url:String,tracker:Tracker,fallbackUrl:String,introUrl:String){
		super(ui,url,tracker,fallbackUrl,introUrl);
		trafficControlTimer = new Timer(20000, 1);
		trafficControlTimer.addEventListener(flash.events.TimerEvent.TIMER, trafficControl);
		switchChannelTimer = new Timer(100, 1);
		switchChannelTimer.addEventListener(flash.events.TimerEvent.TIMER, switchChannels);
	}
	
	override function createSoundObject(){
		sound=new flash.media.Sound();
		soundObject=sound;
	}
	
	override function closeSound() {
		trafficControlTimer.stop();
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
	
	function trafficControl(e = null) {
		if (e == null) {
			lastByteCount = 0;
		}
		if (lastByteCount == sound.bytesLoaded && e!=null) {
			ioError(null);
		}else{
			lastByteCount = sound.bytesLoaded;
			trafficControlTimer.reset();
			trafficControlTimer.start();
		}
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