package skins;
import skins.configurableComponents.Button;
import skins.configurableComponents.VolumeControl;
import skins.configurableComponents.TitleText;
import skins.configurableComponents.StatusLed;

class Configurable extends UI {
	var playButton    : Button;
	var stopButton    : Button;
	var statusLed	  : StatusLed;
	var skin		  : Xml;
	var skinLoader    : flash.net.URLLoader;
	var skinFolder	  : String;
	var baseURL       : String;
	var skinDomain	  : String;

	public static function parseInt(s:String, defaultVal:Int):Int{
		return (s==null)?defaultVal:Std.parseInt(s);
	}
	
	public static function parseColor(s:String):Int{
		if(s==null || s=='' || s=='#'){
			return 0;
		}
		var char=s.charAt(s.length-1).toUpperCase();
		var rest=s.substr(0,s.length-1);
		var val:Int;
		if(char>='0' && char <='9'){
			val=char.charCodeAt(0)-48;
		}else{
			if(char>='A' && char <='F'){
				val=10+char.charCodeAt(0)-65;
			}else{
				return 0;
			}
		}
		return val+16*parseColor(rest);
	}
	
	public function loadImage( url : String ) : flash.display.Loader {
		var l : flash.display.Loader = new flash.display.Loader();
		var urlRequest : flash.net.URLRequest=new flash.net.URLRequest();
		urlRequest.url=skinFolder+url;
		l.load(urlRequest);
		return l;
	}

	private function getDirName(path:String):String {
		var index:Int = path.lastIndexOf('/');
		if (index == -1) return '';
		return path.substr(0, index+1);
	}

	private function getDomainName(path:String):String {
		path += '/';
		var index:Int = path.indexOf('://');
		if (index == -1) return '';
		return path.substr(0, path.indexOf('/',index+3));
	}

	private function makeAbsolute(path:String):String {
		if (path.indexOf('://') != -1) return path;
		if (path.charAt(0) == '/') return skinDomain + path;
		return baseURL + path;
	}
	
	function loadSkin(url:String){
		var urlRequest : flash.net.URLRequest=new flash.net.URLRequest();
		skinLoader = new flash.net.URLLoader();
		urlRequest.url = url;
		baseURL = getDirName(url);
		skinDomain = getDomainName(url);
		skinLoader.addEventListener( flash.events.Event.COMPLETE, loadSkinEvent );
		skinLoader.load(urlRequest);
	}
	
	function configure(elem:Xml){
		var bg=this.loadImage(elem.get('image'));	
		bg.x=parseInt(elem.get('x'),0);
		bg.y=parseInt(elem.get('y'),0);
		this.addChildAt(bg,0);
	}
	
	static function XmlToLower(xml:Xml){
		for( attr in xml.attributes() ){ 
			xml.set(attr.toLowerCase(),xml.get(attr));
		}		
	}
	
	function loadSkinEvent(e: flash.events.Event){
		var loader=cast(e.target,flash.net.URLLoader);
		skin=Xml.parse(loader.data);
		for( base in skin.elements() ) {
			if(base.nodeName.toLowerCase()!='ffmp3-skin'){ // CHECK THIS IS A VALID XML
				return;
			}
			XmlToLower(base); // CHANGE EVERY ATTRIBUTE TO LOWERCASE JUST IN CASE
			skinFolder = (base.get('folder') == null)?(""):(base.get('folder'));
			if (skinFolder.length>0 && skinFolder.charAt(skinFolder.length-1) != '/') skinFolder += "/";
			skinFolder = makeAbsolute(skinFolder);
			for( elem in base.elements() ) {
				XmlToLower(elem); // CHANGE EVERY ATTRIBUTE TO LOWERCASE JUST IN CASE
				switch(elem.nodeName.toLowerCase()){
					case "bg": this.configure(elem);
					case "play": this.playButton.configure(this,elem);
					case "stop": this.stopButton.configure(this,elem);
					case "text": cast(this.titleText,TitleText).configure(this,elem);
					case "status": statusLed.configure(this,elem);
					case "volume": cast(this.volumeControl,VolumeControl).configure(this,elem);
					case "artist": cast(this.artistText,TitleText).configure(this,elem);
					case "songtitle" : cast(this.songTitleText,TitleText).configure(this,elem);
					default:
				}				
			}
		}
	}
	
	public function new(pars : Dynamic<String>){
		super();

		// Create the buttons and volume control
		playButton    = new Button();
		stopButton    = new Button();
		volumeControl = new VolumeControl();
		statusLed	  = new StatusLed();
		
		// And the text field
		titleText = new TitleText();
		titleText.width=0;
		
		artistText = new TitleText();
		artistText.width=0;

		songTitleText = new TitleText();
		songTitleText.width=0;
		
		// Position the buttons etc
		stopButton.x = playButton.width;
		
		addChild(statusLed);
		addChild(playButton);
		addChild(stopButton);
		addChild(titleText);
		addChild(artistText);
		addChild(songTitleText);
		addChild(volumeControl);
		if(pars.skin!=null){
			loadSkin(pars.skin);
		}
	}
	
	public override function enable(player:Player){
		playButton.addEventListener(flash.events.MouseEvent.CLICK, player.playSound);
		stopButton.addEventListener(flash.events.MouseEvent.CLICK, player.stopSound);
		volumeControl.addEventListener(ValueChangeEvent.VALUE_CHANGE,player.changeVolume);		
	}
	
	override public function setStatus(status:FFMp3PlayerStatus, autorestore:Bool = true){
		super.setStatus(status, autorestore);
		if(status==FFMp3PlayerStatus.play){
			statusLed.on();
		}else{
			statusLed.off();
		}
	}
	
}