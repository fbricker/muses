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
import flash.utils.Timer;

class UI extends flash.display.MovieClip {
	
    var titleTimer : Timer;
    var title      : String;
    var titleText  : flash.text.TextField;
    var artistText : flash.text.TextField;
    var albumText  : flash.text.TextField;
    var songTitleText : flash.text.TextField;
	var lang	   : internationalization.AbstractLanguage;
	var jsEvents   : Bool;
	var lastMetadata : String;
	var lastMetadataJson : String;
	public var volumeControl : VolumeControlBase;
		
	public function new(){
		super();
		lastMetadataJson = "";
		lastMetadata = "";
		try{
			flash.external.ExternalInterface.addCallback('showInfo', showInfo);
		}catch(_:Dynamic){}
	}
	
	public function enable(player:Player) { }
	public function togglePlayStop(play:Bool) { }
	
    // Restore the title after a delay
    private function restoreTitle(e=null){
		if(e!=null){ // if this is an event request
			titleText.text = title;
		}else{ //This is a normal request
			// If there's a timer, stop it	
			if (titleTimer != null){
				titleTimer.stop();
			}
			// Create a new timer, 2 secs
			titleTimer = new Timer(2000, 1);
			titleTimer.addEventListener(flash.events.TimerEvent.TIMER, restoreTitle);
			titleTimer.start();
		}
    }

    // Set the title after a delay
    public function setDefaultTitle(title:String){
		this.title = title;
		this.setTitle(title);
    }

    // Set the title after a delay
    private function setTitle(title:String){
		titleText.text = title;
    }
	
	public function resetTitle(){
		this.setTitle(this.title);
	}
	
    // Set the title after a delay
    public function showInfo(title:String,restore:Bool=true){
		if(title!=null){
			setTitle(title);
			if(restore){
				restoreTitle();
			}
		}else{
			setTitle(this.title);
		}
    }	
	
	public function enableJsEvents(){
		jsEvents=true;
	}

	public function disableJsEvents(){
		jsEvents=false;
	}
	
	private function callBack(event:String,param:String){
		if(!jsEvents) return;
		try{
			flash.external.ExternalInterface.call("musesCallback",event,param);
		}catch(_:Dynamic){}
	}
	
	public function informSource(url:String,isFallback:Bool) {
		callBack('source', url);
		callBack('fallback', isFallback?'true':'false');
	}
	
	public function informIntroUrl(url:String) {
		callBack('intro-url', url);
	}
	
	public function setMetadata(am:AudioMetadata){
		var metadataJson:String=am.getJson();
		if(metadataJson==lastMetadataJson) return;
		artistText.text = am.artist;
		songTitleText.text = am.title;
		albumText.text = am.album;
		lastMetadataJson=metadataJson;
		callBack("metadata",am.artist+" - "+am.title);
		callBack("metadata-json",metadataJson);
	}
	
	public function setMetadataFromString(title:String) {
		if(lastMetadata==title) return;
		artistText.text = ""; // we can't separate the artist from the song title
		songTitleText.text = title;
	    lastMetadata=title;
		callBack("metadata", title);
	}
	
	public function setMetadataFromArray(arr : Array<AudioMetadata>) {
		var metadata : AudioMetadata = arr[0];
		var actualMetadata : String = metadata.artist + " - " + metadata.title;
		if (lastMetadata != actualMetadata) {
			lastMetadata = actualMetadata;
			callBack("metadata", actualMetadata);
		}
			
		var jSonString : String = "";
		for (track in arr)
			jSonString += (jSonString != "" ? "," : "") + track.getJson();
			
		if (lastMetadataJson != jSonString) {
			lastMetadataJson = jSonString;
			artistText.text = arr[0].artist;
			songTitleText.text = arr[0].title;
			callBack("metadata-json", "[" + jSonString + "]");
		}
	}
	
	public function setStatus(status:PlayerStatus, autorestore:Bool = true ) {
		callBack(Type.enumConstructor(status),"0");
		if(status==PlayerStatus.buffering){
			return;
		}
		setTitle(lang.getTextByStatus(status));
		if(autorestore) restoreTitle();
	}
	
	public function setVolume(volume:Float){
		callBack('volume',""+Math.round(volume * 100));
		setTitle(lang.getText("volume")+": "+ Math.round(volume * 100) + "%");
		restoreTitle();
	}
	
	public function setLanguage(lang){
		this.lang=lang;		
	}
	
	public function buildContextMenu(){
		var cm=new flash.ui.ContextMenu();
		cm.hideBuiltInItems();
		var item = new flash.ui.ContextMenuItem(lang.getText('about')+' ('+lang.getText('version')+' '+MusesRadioPlayer.VERSION+')');
		cm.customItems.push(item);
		item.addEventListener(flash.events.ContextMenuEvent.MENU_ITEM_SELECT, aboutMusesRadioPlayer);
		flash.Lib.current.contextMenu=cm;
	}
	
	function aboutMusesRadioPlayer(e: flash.events.ContextMenuEvent){
		flash.Lib.getURL(new flash.net.URLRequest('http://www.musesradioplayer.com'));
	}
	
}