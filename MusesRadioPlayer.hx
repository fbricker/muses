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
import flash.system.Capabilities;
import internationalization.AbstractLanguage;
import internationalization.LanguageFactory;

// MusesRadioPlayer Main class
class MusesRadioPlayer{

    var url					: String;
	var introUrl	        : String;
	var fallbackUrl			: String;
    var autoplay			: Bool;
	var player				: Player;
	var ui					: UI;
	var lang				: String;
	var codec				: String;
	var tracking			: Bool;
	var volume				: Int;
	var welcome				: String;
	var buffering			: Int;
	var metadataInterval	: Int;
	var usesMetadataLoader	: String;
	var metadataLoader		: MetadataLoader;
	var metadataUrl		    : String;
	
	public static var VERSION = "0.4.7";
	public static var FPS:Int = 12;
	
    // Kick things off
    public static function main(){
		var musesRadioPlayer = new MusesRadioPlayer();
    }

	// Create a new Player
    function new(){
		// Create the UI
		#if skindefault
		ui=new skins.Default();
		#elseif skintiny
		ui=new skins.Tiny();
		#elseif skinconfigurable
		ui=new skins.Configurable(flash.Lib.current.loaderInfo.parameters);		
		#end
		
		metadataLoader = null;
		
		ui.setLanguage(LanguageFactory.factory(Capabilities.language));
		
		flash.Lib.current.addChild(ui);		
		// If there's an Error in FlashVars, crate ContextMenu and abort.
		if (!getParameters()) {
			ui.buildContextMenu();
			return;
		}
		
		if (lang != "auto" && lang != Capabilities.language) {
			ui.setLanguage(LanguageFactory.factory(lang));
		}
		
		ui.buildContextMenu();
		switch (codec) {
			case "ogg": player=new OggPlayer(ui,url,new Tracker(tracking),fallbackUrl,introUrl);
			default: player=new Mp3Player(ui,url,new Tracker(tracking),fallbackUrl,introUrl);
		}
		
		ui.enable(player);
		ui.volumeControl.setVolume(volume/100.0);
		ui.showInfo(welcome);
		player.setBuffering(buffering);
		
		if(autoplay){ // If autoplay, then start playing (LOL)
			player.jsPlaySound();
		}
		
		if(usesMetadataLoader != "false"){
			metadataLoader = new MetadataLoader(player, ui, metadataInterval, usesMetadataLoader,null,metadataUrl);
			//metadataLoader = new MetadataLoader(player, ui, metadataInterval, usesMetadataLoader,"proxy.php",metadataUrl);
		}

    }
	
    // Get the url and title
    function getParameters() : Bool{
		var clip : flash.display.MovieClip = flash.Lib.current;
		var pars : Dynamic<String> = clip.loaderInfo.parameters;

		// Check the url
		if (pars.url == null) {
			ui.setDefaultTitle("No URL");
			return false;
		}
		// If there's a url, see if there's a title
		url   = pars.url;
		codec = pars.codec;
		lang  = pars.lang;
		fallbackUrl = pars.fallback;
		introUrl = (pars.introurl!=null)?pars.introurl:'';
		
		ui.setDefaultTitle((pars.title != null)?pars.title:("No Title: " + url));
		
		// Check for autoplay
		if (pars.autoplay == null || pars.autoplay == 'false' ){
			autoplay=false;
		}else{
		    autoplay=true;
		}
		
		// Buffering time
		if (pars.buffering == null){
			buffering=0;
		}else{
			buffering=Std.parseInt(StringTools.trim(pars.buffering));
		}
		
		// Check javascript events callback
		if (pars.jsevents == 'true' ){
			ui.enableJsEvents();
		}		
		
		if (pars.volume == null){
			volume=100;
		}else{	
			volume=Std.parseInt(StringTools.trim(pars.volume));
		}
		
		if (pars.interval != null) {
			metadataInterval = Std.parseInt(StringTools.trim(pars.interval));
		}else {
			metadataInterval = 20;
		}
		
		usesMetadataLoader = switch( pars.querymetadata ) {
			case "icecast":	"icecast";
			case "shoutcast": "shoutcast";
			case "streamtheworld": "streamtheworld";
			default: "false";
		}
		
		if (pars.murl != null) {
			metadataUrl = pars.murl;
		}
		
		welcome=pars.welcome;
		
		tracking=(pars.tracking!='false');
		return true;
	}

}
