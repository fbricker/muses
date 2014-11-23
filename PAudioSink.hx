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
import org.xiph.system.AudioSink;
import flash.Vector;


class PAudioSink extends AudioSink {
    /**
       A very quick&dirty wrapper around the AudioSink to somewhat
       make up for the lack of a proper demand-driven ogg demuxer a.t.m.
     */

    var cb_threshold : Int;
    var cb_pending : Bool;
    var cb : PAudioSink -> Void;

    public function new(chunk_size : Int, fill = true, trigger = 0) {
        super(chunk_size, fill, trigger);
        cb_threshold = 0;
        cb = null;
        cb_pending = false;

    }

    public function set_cb(threshold : Int, cb : PAudioSink -> Void) : Void {
        cb_threshold = threshold;
        this.cb = cb;
    }

    override function _data_cb(event : flash.events.SampleDataEvent) :Void {
        super._data_cb(event);

        if (cb_threshold > 0) {
            if (available < cb_threshold && !cb_pending) {
                cb_pending = true;
                haxe.Timer.delay(_delayed_cb, 1);
            }
        }
    }

    function _delayed_cb() : Void {
        this.cb_pending = false;
        this.cb(this);
    }

    public function getPosition():Float{
        if(sch==null) return 0;
        return sch.position;
    }

    override public function write(pcm : Array<Vector<Float>>,
                                   index : Vector<Int>, samples : Int) : Void {
        super.write(pcm, index, samples);

        if (cb_threshold > 0) {
            if (available < cb_threshold && !cb_pending) {
                cb_pending = true;
                haxe.Timer.delay(_delayed_cb, 1);
            }
        }
    }
}
