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

package aac;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.ProgressEvent;
import flash.Lib;
import flash.media.SoundTransform;
import flash.net.FileReference;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.net.NetStreamAppendBytesAction;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.ByteArray;
import flash.utils.Timer;

class FLVSound  extends flash.events.EventDispatcher {
	var input : URLStream;
	var nt : NetStream;
	var syncOk : Bool;
	var mustPlay : Bool;
	var url : String;
	var nc : NetConnection;
	var contador:Int;
	
    public function new(url:String) {
		super();
		this.url = url;
		mustPlay = false;
		nc = new NetConnection();
		input = new URLStream();
        input.addEventListener(flash.events.ProgressEvent.PROGRESS, convertStream);
        input.addEventListener(flash.events.Event.COMPLETE, _on_complete);
        input.addEventListener(flash.events.IOErrorEvent.IO_ERROR, _on_error);
        input.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, _on_security);		
		nc.connect(null);
		nt = new NetStream(nc);
		nt.useHardwareDecoder = true;
		nt.backBufferTime = 1;
		nt.bufferTime = 2;
		nt.play(null);
		nt.addEventListener("metadataReceived", function (e) { trace (e); } );
	}
	
	public function setBufferingTime(time:Float) {
		nt.bufferTime = time;
	}
	
	function _on_complete(e : flash.events.Event) : Void {
		if (hasEventListener(flash.events.Event.COMPLETE)) dispatchEvent(e);
    }

    function _on_error(e : flash.events.IOErrorEvent) : Void {
	    if (hasEventListener( flash.events.IOErrorEvent.IO_ERROR)) dispatchEvent(e);
    }

    function _on_security(e : flash.events.SecurityErrorEvent) : Void  {
        if (hasEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR)) dispatchEvent(e);
    }
	
	public function play() {
		syncOk = false;
		mustPlay = true;
		input.load(new URLRequest(url));
	}
	
	public function stop() {
		mustPlay = false;
		nt.close();
        input.removeEventListener(flash.events.ProgressEvent.PROGRESS, convertStream);
        input.removeEventListener(flash.events.Event.COMPLETE, _on_complete);
        input.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, _on_error);
        input.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, _on_security);		
		input.close();
		nc.close();
		
		adtsStripper = null;
		nt = null;
		nc = null;
		input = null;
	}
	
	public function setVolume(vol:Float) {
		nt.soundTransform = new SoundTransform(vol);
	}
	
	function convertStream( e : Event ) {		
		if (!mustPlay) return;
		
		while(input.bytesAvailable >=8192){
			var data : ByteArray = new ByteArray();
			input.readBytes(data);
			nt.appendBytes(data);
		}
	}
	
	public function getProgress():Float {
		return nt.time;
	}

}
