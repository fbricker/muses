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
import flash.media.SoundChannel;
import org.xiph.foggy.Demuxer;
import org.xiph.fogg.Packet;
import org.xiph.fvorbis.Info;
import org.xiph.fvorbis.Comment;
import org.xiph.fvorbis.DspState;
import org.xiph.fvorbis.Block;
import org.xiph.system.Bytes;
import flash.Vector;

class OGGSound extends flash.events.EventDispatcher {
	var asink:PAudioSink;
	public var length:Float;
    var ul : flash.net.URLStream;
    var volume : Int;
    var bytesTotal : Int;
    public var bytesLoaded : UInt;
    var bytesPlayed: Int;
	var req:flash.net.URLRequest;
    var read_started : Bool;
    var read_pending : Bool;
    var _bootstrap_pending:Bool;
    var read_buff_pending: Bool;
    var _pcm : Array<Array<Vector<Float>>>;
    var _index : Vector<Int>;
	var dmx : Demuxer;
    var vi : Info;
    var vc : Comment;
    var vd : DspState;
    var vb : Block;	
	
    var _packets : Int;
	
    var playBuffer:flash.utils.ByteArray;
    var isPaused:Bool;
 
    var buff_write_pos:Int;
    var play_buffered:Bool;//use buffer, don't set to true for streaming?
    var streamDetected:Bool;//do NOT use buffer.

    var oldBytesTotal:Int;
    var adjustCount:Int; 
	
    // Create a new OVSound

    public function new(){
		super();
		play_buffered = false;
    }
	
	public function stop(){
		if(asink!=null){
			asink.stop();
		}
	}

    public function play(){
		ul.addEventListener(flash.events.Event.OPEN, _on_open	);
        ul.addEventListener(flash.events.ProgressEvent.PROGRESS, _on_progress);
        ul.addEventListener(flash.events.Event.COMPLETE, _on_complete);
        ul.addEventListener(flash.events.IOErrorEvent.IO_ERROR, _on_error);
        ul.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, _on_security);
		ul.load(req);
	}

	public function close(){
		ul.close();
		ul.removeEventListener(flash.events.Event.OPEN, _on_open	);
        ul.removeEventListener(flash.events.ProgressEvent.PROGRESS, _on_progress);
        ul.removeEventListener(flash.events.Event.COMPLETE, _on_complete);
        ul.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, _on_error);
        ul.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, _on_security);
		
		Reflect.deleteField(this,'asink');
		Reflect.deleteField(this,'_pcm');
		Reflect.deleteField(this,'_index');
		Reflect.deleteField(this,'dmx');
		Reflect.deleteField(this,'vi');
		Reflect.deleteField(this,'vc');
		Reflect.deleteField(this,'vd');
		Reflect.deleteField(this,'playBuffer');
		Reflect.deleteField(this,'ul');
		
		ul = null;
		asink = null;
		_pcm = null;
		_index = null;
		dmx = null;
		vi = null;
		vc = null;
		vd = null;
		vb = null;
		playBuffer = null;
	}
	
	public function load(request:flash.net.URLRequest){
		playBuffer=new flash.utils.ByteArray();
    	streamDetected=false;
    	oldBytesTotal=0;//nothing loaded
    	buff_write_pos=0;
    	bytesPlayed =0;
    	isPaused=false;
		req=request;
		ul=new flash.net.URLStream();
		
	}
	
    public function getPosition():Float{
        if(asink==null) return -1;
        return asink.getPosition();
    }

	public function setVolume(vol:Float){
		volume=Math.round(vol*100);
		if(asink!=null){
			asink.setVolume(volume);
		}
	}
	
    function _on_open(e : flash.events.Event) : Void {
		if (hasEventListener(flash.events.Event.OPEN)) dispatchEvent(e);
        read_pending = false;
        read_started = false;
        try_ogg();		
    }
	
    function _on_progress(e : flash.events.ProgressEvent) : Void {
		if (hasEventListener(flash.events.ProgressEvent.PROGRESS)) dispatchEvent(e);
		bytesLoaded = cast(e.bytesLoaded,Int);
        if(oldBytesTotal==0){
        	_bootstrap_pending=false;
        	read_started=false;
        	oldBytesTotal=bytesTotal;
        	if(adjustCount>3)adjustCount=0;
        }
        bytesTotal = cast(e.bytesTotal,Int);
        if((bytesTotal==0)&&(!streamDetected))
        {
        	adjustCount++;
        	if(adjustCount>3){
        		streamDetected=true;
        	}
        }
        if(oldBytesTotal!=bytesTotal)
        {
        	oldBytesTotal=bytesTotal;
        	if(!streamDetected){
        		adjustCount++;
        		if(adjustCount>10){
        			streamDetected=true;
        			adjustCount=0;
        		}
        	}
        }
        _doProgress(Math.ceil(bytesLoaded*100/(bytesTotal+2)),Math.ceil(bytesPlayed*100/(bytesTotal+2)));
        if (ul.bytesAvailable > 16284){
            _read_data();
            if (!read_started ) {
               //to fix immediate preload on ogg on IE 6
                if(!_bootstrap_pending)_bootstrap_read();
            }
        }
		
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
	
    function _on_sound_complete(e : flash.events.Event ) {
		if (hasEventListener(flash.events.Event.SOUND_COMPLETE)) dispatchEvent(e);
    }
	
	
    function _doProgress(loaded:Int,played:Int):Void {
		played=Math.ceil(asink.available*100/(132300*3));
    }	
	
	function _read_data() : Void {
        var to_read : Int = ul.bytesAvailable;
        var chunk : Int = 16384;
        read_pending = false;

        if (to_read == 0)
            return;

        if (to_read < chunk && !read_pending) {
            read_pending = true;
            haxe.Timer.delay(_read_data, 50);
            return;
        }

        to_read = ul.bytesAvailable;
        if (to_read > chunk) {
            to_read = chunk;
        }
	
        /*this was here, now we read to buffer, not to demuxer
        dmx.read(ul, to_read);
        bytesPlayed+=to_read;
        _doProgress(Math.ceil(bytesLoaded*100/(bytesTotal+2)),Math.ceil(bytesPlayed*100/(bytesTotal+2)));
        */
        to_read=ul.bytesAvailable;
        ul.readBytes(playBuffer,buff_write_pos,/*chunk*/to_read);
        buff_write_pos+=to_read;
       // bytesPlayed+=to_read;
    }

    //this functions hand-feeds audiosink new data until it starts playing on it's own
    function _bootstrap_read():Void
    {
    	_bootstrap_pending=false;
    	_read_buffer();//this function feeds the actual data
    	if((!asink.triggered)&&(!_bootstrap_pending))
    	{
    		_bootstrap_pending=true;
    		haxe.Timer.delay(_bootstrap_read, 50);
    		return;
    	}
    	
    }	
	
	function _read_buffer():Void{
     	var to_read : Int = playBuffer.bytesAvailable;
    	//var chunk : Int = 8192;
    	var chunk : Int = 16384;//test?
    	var did_read:Int=0;
    	read_buff_pending = false;

    	if (to_read == 0) return;

    	if (to_read < chunk && !read_buff_pending) {
			read_buff_pending = true;
			haxe.Timer.delay(_read_buffer, 50);
			return;
    	}
    	to_read = playBuffer.bytesAvailable;
    	if (to_read > chunk) {
			to_read = chunk;
    	}
    	did_read=dmx.read(playBuffer, to_read);
    	if(did_read==to_read) {
    		bytesPlayed+=to_read;
    		if((!play_buffered)||(streamDetected)) {
    			var tmp:flash.utils.ByteArray = new flash.utils.ByteArray();
    			playBuffer.readBytes(tmp);
    			playBuffer=tmp;
    			buff_write_pos=playBuffer.length;
    			
    		}
			_doProgress(Math.ceil(bytesLoaded*100/(bytesTotal+2)),Math.ceil(bytesPlayed*100/(bytesTotal+2)));    
    	}
    }
	
	function try_ogg() : Void {
        dmx = new Demuxer();
        vi = new Info();
        vc = new Comment();
        vd = new DspState();
        vb = new Block(vd);
        _packets = 0;
        dmx.set_packet_cb(-1, _proc_packet_head);
        asink = new PAudioSink(8192, true, 132300);
		//params: data chunk for Sound.onSampleData, doFill with zeroes, trigger play after...
        asink.setVolume(volume);
        asink.set_cb(88200, _on_data_needed);
    }

    function _proc_packet_head(p : Packet, sn : Int) : DemuxerStatus {
        vi.init();
        vc.init();
        if (vi.synthesis_headerin(vc, p) < 0) {
            // not vorbis - clean up and ignore
            vc.clear();
            vi.clear();
        } else {
            dmx.set_packet_cb(sn, _proc_packet);
        }
	_packets = 0;
        _packets++;
        return dmx_ok;
    }


    function _proc_packet(p : Packet, sn : Int) : DemuxerStatus {
        var samples : Int;

        switch(_packets) {
        case 0:
            
        case 1:
            vi.synthesis_headerin(vc, p);

        case 2:
            vi.synthesis_headerin(vc, p);

            {
                var ptr : Array<Bytes> = vc.user_comments;
                var j : Int = 0;
                var comments : String;
                var comment: Array<String>;
                comments="";
				var metadata=new AudioMetadata();
                while (j < ptr.length) {
                    if (ptr[j] == null) {
                        break;
                    };
                    comment = System.fromBytes(ptr[j], 0, ptr[j].length - 1).split("=");
                    comments = comments+comment[0];
                    comments = comments +":\""+StringTools.replace(comment[1],"\"","'")+"\",";
					metadata.set(comment[0],comment[1]);
                    j++;
                };
				// HERE IS THE METADATA FOR OGG STREAMING!!! SOON WILL BE AVAILABLE FOR EVERYBODY!
				// FIRST WITH JAVASCRIPT AND THEN INSIDE THE SKINS!
				dispatchEvent(new MetadataEvent(metadata));
            }

            vd.synthesis_init(vi);
            vb.init(vd);

            _pcm = [null];
            _index = new Vector(vi.channels, true);

        default:
            if (vb.synthesis(p) == 0) {
                vd.synthesis_blockin(vb);
            }

            while ((samples = vd.synthesis_pcmout(_pcm, _index)) > 0) {
                asink.write(_pcm[0], _index, samples);
                vd.synthesis_read(samples);
            }
        }

        _packets++;

        return dmx_ok;
    }

	
    function _on_data_needed(s : PAudioSink) : Void {
         //trace("on_data: " + ul.bytesAvailable);
        read_started = true;
        //_read_data();
      	_read_buffer();
    }
}
