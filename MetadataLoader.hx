////////////////////////////////////////////////////////////////////////////////
//
//  Muses Radio Player - Radio Streaming player written in Haxe.
//
//  Copyright (C) 2009-2014  Federico Bricker
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
		if(proxy!=null && proxy!=''){
			this.proxy=proxy;
		}
		delay=MusesRadioPlayer.FPS*interval;
		counter=delay-Math.round(MusesRadioPlayer.FPS/2);
		ui.addEventListener(flash.events.Event.ENTER_FRAME,loop);
	}
	
	public function loop(_){
		counter++;
		if(counter>=delay && player.isPlaying()){
			counter = 0;
			var url:String=null;
			url = switch(metadataSource) {			
				case "icecast": player.getCurrentUrl().split("?")[0] + ".xspf";
				case "streamtheworld": mUrl + "&" + Date.now().getTime();
				case "shoutcast": player.getCurrentUrl().substr(0,player.getCurrentUrl().indexOf('/',9)) + '/7.html';
				default: null;
			}
			if(proxy!=null){
				url=proxy+'?url='+StringTools.replace(url,':','%3A');
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
			case "shoutcast": loadShoutcastEvent;
			default: null; } );
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
		var data:String = loader.data;
		data=StringTools.replace(data,'<html>','');
		data=StringTools.replace(data,'</html>','');
		data=StringTools.replace(data,'<body>','');
		data=StringTools.replace(data,'</body>','');
		var parsed:Array<String> = data.split(",");
		var currentSong:String=parsed[6];
		for(i in 7 ... parsed.length) currentSong += ','+parsed[i];
		ui.setMetadataFromString(StringTools.trim(currentSong));
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
