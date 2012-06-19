import flash.accessibility.Accessibility;
import flash.events.Event;
// MetadataLoader Main class

class MetadataLoader {
	var player	  : Player;
	var ui		  : UI;
	var counter	  : Int;
	var delay     : Int;
	var fileLoader: flash.net.URLLoader;
	var proxy	  : String;
	var metadataSource : String;
	var mUrl      : String;
	
    public function new(player:Player, ui:UI, interval:Int, metadataSource:String, proxy:String, mUrl:String) {
		if (metadataSource != "icecast" && metadataSource != "streamtheworld" && metadataSource != "shoutcast") {
			return;
		}
		this.player=player;
		this.ui = ui;
		this.metadataSource = metadataSource;
		this.mUrl = mUrl;
		if(proxy!=null){
			this.proxy=proxy;
		}
		delay=FFMp3.FPS*interval;
		counter=delay-Math.round(FFMp3.FPS/2);
		ui.addEventListener(flash.events.Event.ENTER_FRAME,loop);
	}
	
	public function loop(_){
		counter++;
		if(counter>=delay && player.isPlaying()){
			counter = 0;
			var url:String=null;
			url = switch(metadataSource) {
				case "icecast": player.getCurrentUrl() + ".xspf";
				case "streamtheworld": mUrl + "&" + Date.now().getTime();
				case "shoutcast": StringTools.replace(player.getCurrentUrl(), ';', '');
			}
			if(proxy!='' && proxy!=null){
				url='proxy.php?url='+StringTools.replace(url,':','%3A');
			}
			loadMetadata(url);
		}
	}

	function loadMetadata(url:String){
		var urlRequest : flash.net.URLRequest=new flash.net.URLRequest();
		fileLoader = new flash.net.URLLoader();
		urlRequest.url = url;
		this.fileLoader.addEventListener(Event.COMPLETE, switch(metadataSource) {
			case "icecast": loadIcecastEvent;
			case "streamtheworld": loadStreamTheWorldEvent;
			case "shoutcast": loadShoutcastEvent; } );
		fileLoader.load(urlRequest);
	}
	
	function loadStreamTheWorldEvent(e: Event) {
		var loader=cast(e.target,flash.net.URLLoader);
		var base = Xml.parse(loader.data).firstChild();
		if(base.nodeName.toLowerCase()!='nowplaying-info-list'){ // CHECK THIS IS A VALID XML
			return;
		}
		var arr : Array<AudioMetadata> = new Array<AudioMetadata>();
		var metadata : AudioMetadata;
		for ( elem in base.elementsNamed("nowplaying-info")) {
			metadata = new AudioMetadata();
			for (track in elem.elementsNamed("property")) {
				if (track.get("name") == 'cue_title')
					metadata.title = track.firstChild().nodeValue;
				if (track.get("name") == 'track_artist_name')
					metadata.artist = track.firstChild().nodeValue;
				if (track.get("name") == 'cue_time_start')
					metadata.comment = track.firstChild().nodeValue;
			}
			arr.push(metadata);
		}
		ui.setMetadataFromArray(arr);
	}
	
	function loadShoutcastEvent(e: Event) {
		var loader=cast(e.target,flash.net.URLLoader);
		var data = loader.data;
		var variable:Array<String> = data.split("<font class=default>Current Song: </font></td><td><font class=default><b>");
		variable = variable[1].split("</b>");
		ui.setMetadataFromString(variable[0]);
	}

	function loadIcecastEvent(e: Event){
		var loader=cast(e.target,flash.net.URLLoader);
		var base = Xml.parse(loader.data).firstElement();
		if (base.nodeName.toLowerCase() != 'playlist') return;		
		for ( elem in base.elements()) {
			if (elem.nodeName.toLowerCase() != 'tracklist') continue;
			for(track in elem.elements()){
				if (track.nodeName.toLowerCase() != 'track') continue;
				for (title in track.elements()) {
					if (title.nodeName.toLowerCase() != 'title') continue;
					ui.setMetadataFromString(title.firstChild().nodeValue);
					return;
				}
			}
		}
	}
	
}