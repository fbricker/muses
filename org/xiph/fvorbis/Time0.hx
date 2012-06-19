package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;
import org.xiph.fvorbis.FuncTime;

class Time0 extends FuncTime {
    /*
     * generated source for Time0
     */

    // modifiers: 
    override function pack(i : Dynamic, opb : Buffer) : Void {
    }

    // modifiers: 
    override public function unpack(vi : Info, opb : Buffer) : Dynamic {
        return "";
    }

    // modifiers: 
    override function look(vd : DspState, mi : InfoMode, i : Dynamic) : Dynamic {
        return "";
    }

    // modifiers: 
    override function free_info(i : Dynamic) : Void {
    }

    // modifiers: 
    override function free_look(i : Dynamic) : Void {
    }

    // modifiers: 
    override function forward(vb : Block, i : Dynamic) : Int {
        return 0;
    }

    // modifiers: 
    override function inverse(vb : Block, i : Dynamic, in_ : Vector<Float>, out : Vector<Float>) : Int {
        return 0;
    }

    public function new() {
    }
}
