package org.xiph.system;

//import org.xiph.system.Bytes;

import flash.Vector;

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.events.SampleDataEvent;


class AudioSink {
    var buffer : Bytes;
    public var available : Int;
    public var triggered : Bool;
    var trigger : Int;
    var fill : Bool;
    var size : Int;
    var volume:Int;
    var s : Sound;
    var sch : SoundChannel;
    var strans: SoundTransform;
    var statusCB : String -> Void;
    var bufferCB : Int -> Void;
    
    function doBuffer(value: Int) :Void {
        if(bufferCB != null) bufferCB(value);
    }
    
    public function setBufferCB(newCB : Int -> Void): Void {
    	bufferCB = newCB;
    }
    
    function doStatus(state: String) :Void {
    	if(statusCB != null) statusCB(state);
    }
    public function setStatusCB(newCB : String -> Void): Void {
    	statusCB = newCB;
    
    }
    public function new(chunk_size : Int, fill = true, trigger = 0) {
        size = chunk_size;
        this.fill = fill;
        this.trigger = trigger;
        if (this.trigger == -1)
            this.trigger = size;
        triggered = false;

        buffer = new Bytes();
        available = 0;
        s = new Sound();
        volume=100;
        //strans = new SoundTransform(1,0);
        sch = null;
    }
    public function setVolume(vol : Int) {
        //strans.volume = (vol+0.0001)/100;
    	volume = vol;
    	if (sch != null) {
    	   //trace("Volume change:"+vol);
    	   strans = sch.soundTransform;
    	   strans.volume = (volume+0.0001)/100;
    	   sch.soundTransform = strans;
    	}
    }
    public function play() : Void {
        //trace("adding callback");
        s.addEventListener("sampleData", _data_cb);
        //trace("playing");
        doStatus("playing");
        sch = s.play(0,0,strans);
        setVolume(volume);
        //trace(sch);
    }

    public function stop() : Void {
        if (sch != null) {
            sch.stop();
        }
    }

    function _data_cb(event : SampleDataEvent) : Void {
        var i : Int;
        var to_write : Int = available > size ? size : available;
        var missing = to_write < size ? size - to_write : 0;
        var bytes : Int = to_write * 8;
        if (to_write > 0) {
            event.data.writeBytes(buffer, 0, bytes);
            available -= to_write;
            System.bytescopy(buffer, bytes, buffer, 0, available * 8);
        }
        i = 0;
        if (missing > 0 && missing != size && fill) {
            //trace("samples data underrun: " + missing);
            doStatus("error=underflow");
            while (i < missing) {
                untyped {
                event.data.writeFloat(0.0);
                event.data.writeFloat(0.0);
                };
                i++;
            }
        } else if (missing > 0) {
            //trace("not enough data, stopping");
            doStatus("streamstop");
            //stop();
        }
    }
    public function resetBuffer():Void
    {
    	buffer.position=0;
    	buffer.length=0;
    	available=0;
    }
    public function write(pcm : Array<Vector<Float>>, index : Vector<Int>,
                          samples : Int) : Void {
        var i : Int;
        var end : Int;
        buffer.position = available * 8; // 2 ch * 4 bytes per sample (float)
        if (pcm.length == 1) {
            // one channel
            //trace("1 chan");
            var c = pcm[0];
            var s : Float;
            i = index[0];
            end = i + samples;
            while (i < /*samples*/end) {
                s = c[i++];
                buffer.writeFloat(s);
                buffer.writeFloat(s);
            }
        } else if (pcm.length == 2) {
            // two channels
            //trace("2 chan");
            var c1 = pcm[0];
            var c2 = pcm[1];
            i = index[0];
            var i2 = index[1];
            end = i + samples;
            while (i < end) {
                buffer.writeFloat(c1[i]);
                buffer.writeFloat(c2[i2++]);
                i++;
            }
        } else {
            throw "-EWRONGNUMCHANNELS";
            doStatus("error=badformat");
        }

        available += samples;
        if (!triggered && trigger > 0 && available > trigger) {
            triggered = true;
            //trace("triggered");
            doBuffer(100);
            play();
        }
        else if(!triggered)
        {
            var bst=Std.int(available*100/trigger);
            doBuffer(bst);
        }
    }
}
