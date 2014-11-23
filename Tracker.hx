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

class Tracker {
	var enabled:Bool;
	var tracked:Map<String,Bool>;
	
	public function new (enabled:Bool){
		this.enabled=enabled;
		tracked=new Map<String,Bool>();
	}
	
	public function track(player:Player,justOnce:Bool){
		// HERE IS THE CODE FOR TRACKING AT GOOGLE ANALYTICS
		// TRACKING CAN BE EASLITY DISABLED BY PASSING tracking=false WITH THE FLASHVARS
		// IF YOU WANT ACCESS TO TRACKING STATISTICS, JUST WRITE ME TO FBRCKER(AT)GMAIL.COM
		// AND I'LL GIVO YOU FULL ACCESS TO THIS STATISTICS :)
		
		var playerClass:String = Type.getClassName(Type.getClass(player));
		var url:String = player.getCurrentUrl();
		
		if(enabled && (!justOnce || !tracked.get(url))){
			try {
				flash.Lib.getURL(new flash.net.URLRequest("javascript:
					(function (){
					   ifrm = document.createElement('IFRAME');
					   ifrm.setAttribute('src', 'https://hosted.muses.org/tracker/track.php?version="+MusesRadioPlayer.VERSION+"&url="+url+"&player="+playerClass+"&skin="+MusesRadioPlayer.SKIN+"');
					   ifrm.style.width = 1+'px';
					   ifrm.style.height = 1+'px';
					   ifrm.style.display = 'none';
					   document.body.appendChild(ifrm); 
					})(); "),
					'_self');
				tracked.set(url,true);				
			} catch(_:Dynamic) {}
		}
	}
}